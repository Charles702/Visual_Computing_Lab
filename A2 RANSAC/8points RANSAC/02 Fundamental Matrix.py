'''
Install opencv:
pip install opencv-python==3.4.2.16
pip install opencv-contrib-python==3.4.2.16
'''

import cv2
import numpy as np
from matplotlib import pyplot as plt
from argparse import ArgumentParser

print(cv2.__version__);

parser = ArgumentParser()
parser.add_argument("--UseRANSAC", type=int, default=1 )
parser.add_argument("--image1", type=str,  default='data/myleft.jpg' )
parser.add_argument("--image2", type=str,  default='data/myright.jpg' )
args = parser.parse_args()

print(args)


def NormalizeInput(pts):
    numberp = pts.shape[0]
    # Reorganize matrix to 3D points, add 1 clone of z axis
    ptstrans = np.concatenate((np.transpose(pts), np.ones([1, numberp])), axis=0)
    # get the Centroid
    meanx = np.mean(np.transpose(pts)[0])
    meany = np.mean(np.transpose(pts)[1])
    newx = ptstrans[0] - meanx
    newy = ptstrans[1] - meany
    # Calculate distance from centroid
    dis = np.sqrt(np.square(newx) + np.square(newy))
    meandis = np.mean(dis)
    # calculate the scale
    scale = np.sqrt(2) / meandis
    # construct the coefficient matrix
    TM = np.array([[scale, 0, (-1) * meanx * scale],
                   [0, scale, (-1) * meany * scale],
                   [0, 0, 1]])
    #print(TM)
    normpts = np.dot(TM, ptstrans)
    return normpts, TM

def FM_by_normalized_8_point(pts1,  pts2):
    # Normalize inputs
    Pts1, T1 = NormalizeInput(pts1)
    Pts2, T2 = NormalizeInput(pts2)

    x1 = Pts1[0]
    y1 = Pts1[1]
    x2 = Pts2[0]
    y2 = Pts2[1]
    C1 = x2 * x1
    C2 = x2 * y1
    C3 = x2
    C4 = y2 * x1
    C5 = y2 * y1
    C6 = y2
    C7 = x1
    C8 = y1
    C9 = np.ones(len(x1))
    A = np.transpose(np.array([C1, C2, C3, C4, C5, C6, C7, C8, C9]))
    print(A.shape)

    # Solve A*f = 0 using least squares.
    U, D, V = np.linalg.svd(A)
    # draw the vector corresponding to least singular from V
    fMatrix = np.reshape(V[-1], (3, 3))
    # Enforce rank2 constraint on F
    U, S, V = np.linalg.svd(fMatrix)
    d = np.diag([S[0], S[1], 0])
    F = np.matmul(np.matmul(U, d), V)
    # Denormalize F
    F = np.matmul(np.matmul(np.transpose(T2), F), T1)
    # scale F
    F = F * (1 / F[2][2])
    print(F)
    return  F


def FM_by_RANSAC(pts1,  pts2):
    #F, mask = cv2.findFundamentalMat(pts1,pts2,  cv2.FM_RANSAC )
    # comment out the above line of code.
    # paramters:  1. myright,myleft, M = 600, threshold = 1.5
    #             2. wall_left, wall_right M =200 threshold = 1
    #             3. building_left, building_right M = 100, threshold = 2
    M = 600  #600
    threshold = 1.5  #1.5
    n = 0
    numberp = pts1.shape[0]   # Number of points
    errorMatrix = np.zeros(numberp)
    mask = np.zeros(numberp)
    F = np.zeros([3, 3])
    n_inliers = 0
    epiline = []

    # add 1 at 3rd column
    pts3D1 = np.concatenate((pts1, np.ones([numberp, 1])), axis=1)
    pts3D2 = np.concatenate((pts2, np.ones([numberp, 1])), axis=1)
    # print(pts3D1)
    for i in range(M):
        # choose 8 pair of points randomly
        selectP = np.random.randint(numberp, size=8)
        inputpts1 = pts3D1[selectP]
        inputpts2 = pts3D2[selectP]
        # print(inputpts1)
        # print(inputpts2)
        # calculate fundamental Matrix using 8 points
        F1, _ = cv2.findFundamentalMat(inputpts1, inputpts2, cv2.FM_8POINT)
        if F1 is None:
            print("none")
            continue
        # print(F1)
        # loop all key points, calculate inliers
        for k in range(numberp):
            # approach 1: measure x1T* F * x2, how does it close to 0,  this approach doesn't seem work well
            # errorMatrix[k] = np.matmul(pts3D1[k], np.matmul(F1, np.transpose(pts3D2[k])))

            # approach 2: for a pair of points (x1,x2):  F*x1 gives the epiline in another image, then measure the distance between x2 and epiline.
            # get epiplie of x1 in another image
            epiline = np.dot(F1, pts3D1[k])
            # calculate distance between x2 and epiline:ax + by + c = 0
            a = epiline[0]
            b = epiline[1]
            c = epiline[2]
            x = pts3D2[k][0]
            y = pts3D2[k][1]
            d = abs(a * x + b * y + c) / np.sqrt(a * a + b * b)
            # Save distance for  each pair of points
            errorMatrix[k] = d
        # print(errorMatrix)
        # Generate Mask Matrix according to the threshold
        mask1 = np.int8(np.absolute(errorMatrix) < threshold)
        # calculate number of inliers
        n_inliers = np.sum(mask1)
        # print(n_inlines)
        if n_inliers > n:  # Find the optimal Mask and F corresponding to most inlines
            n = n_inliers
            F = F1
            mask = mask1
    print("---inlines number---", n)
    return F, mask

    # F:  fundmental matrix
    # mask:   whetheter the points are inliers
    return  F, mask


img1 = cv2.imread(args.image1,0)
img2 = cv2.imread(args.image2,0)

sift = cv2.xfeatures2d.SIFT_create()

# find the keypoints and descriptors with SIFT
kp1, des1 = sift.detectAndCompute(img1,None)
kp2, des2 = sift.detectAndCompute(img2,None)

# FLANN parameters
FLANN_INDEX_KDTREE = 0
index_params = dict(algorithm = FLANN_INDEX_KDTREE, trees = 5)
search_params = dict(checks=50)

flann = cv2.FlannBasedMatcher(index_params,search_params)
matches = flann.knnMatch(des1,des2,k=2)

good = []
pts1 = []
pts2 = []

# ratio test as per Lowe's paper
for i,(m,n) in enumerate(matches):
    if m.distance < 0.8*n.distance:
        good.append(m)
        pts2.append(kp2[m.trainIdx].pt)
        pts1.append(kp1[m.queryIdx].pt)


pts1 = np.int32(pts1)
pts2 = np.int32(pts2)

F = None
if args.UseRANSAC:
    print("Ransac")
    F,  mask = FM_by_RANSAC(pts1,  pts2)
    #F, mask = cv2.findFundamentalMat(pts1, pts2, cv2.FM_RANSAC)
    # We select only inlier points
    pts1 = pts1[mask.ravel()==1]
    pts2 = pts2[mask.ravel()==1]
else:
    print("8 points algorithm")
    #F, _ = cv2.findFundamentalMat(pts1, pts2,  cv2.FM_8POINT )
    F = FM_by_normalized_8_point(pts1,  pts2)


def drawlines(img1,img2,lines,pts1,pts2):
    ''' img1 - image on which we draw the epilines for the points in img2
        lines - corresponding epilines '''
    r,c = img1.shape
    img1 = cv2.cvtColor(img1,cv2.COLOR_GRAY2BGR)
    img2 = cv2.cvtColor(img2,cv2.COLOR_GRAY2BGR)
    for r,pt1,pt2 in zip(lines,pts1,pts2):
        color = tuple(np.random.randint(0,255,3).tolist())
        x0,y0 = map(int, [0, -r[2]/r[1] ])
        x1,y1 = map(int, [c, -(r[2]+r[0]*c)/r[1] ])
        img1 = cv2.line(img1, (x0,y0), (x1,y1), color,1)
        img1 = cv2.circle(img1,tuple(pt1),5,color,-1)
        img2 = cv2.circle(img2,tuple(pt2),5,color,-1)
    return img1,img2


# Find epilines corresponding to points in second image,  and draw the lines on first image
lines1 = cv2.computeCorrespondEpilines(pts2.reshape(-1,1,2), 2,  F)
lines1 = lines1.reshape(-1,3)
img5,img6 = drawlines(img1,img2,lines1,pts1,pts2)
plt.subplot(121),plt.imshow(img5)
plt.subplot(122),plt.imshow(img6)
plt.show()

# Find epilines corresponding to points in first image, and draw the lines on second image
lines2 = cv2.computeCorrespondEpilines(pts1.reshape(-1,1,2), 1,F)
lines2 = lines2.reshape(-1,3)
img3,img4 = drawlines(img2,img1,lines2,pts2,pts1)
plt.subplot(121),plt.imshow(img4)
plt.subplot(122),plt.imshow(img3)
plt.show()

