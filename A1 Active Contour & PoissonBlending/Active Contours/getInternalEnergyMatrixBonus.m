function [Ainv] = getInternalEnergyMatrix(nPoints, alpha, beta, gamma)
    A = zeros(nPoints,nPoints);
    pattern = zeros(1,nPoints);
    
    pattern(1,1) = 2*alpha + 6 *beta;
    pattern(1,2) = -(alpha + 4*beta);
    pattern(1,3) = beta;
    pattern(1,nPoints-1) = beta;
    pattern(1,nPoints) = -(alpha + 4*beta);
    
    %shift the pattern and assigned to each row.
    for i=1:nPoints
        A(i,:) = pattern;
        pattern = circshift(pattern',1)';
    end
    
    Ainv =inv(A + gamma.* eye(nPoints));
end
