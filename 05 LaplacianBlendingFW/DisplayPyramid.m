function [f] = DisplayPyramid(pyramid)
    f = figure;

    % https://stackoverflow.com/questions/27002563/display-a-gaussian-pyramid-stored-in-a-cell-array-in-a-single-figure
    m = size(pyramid{1}, 1);
    newI = pyramid{1};
    for i = 2 : numel(pyramid)
        [q,p,~] = size(pyramid{i});
        I = cat(1,repmat(zeros(1 , p),[m - q , 1]),pyramid{i});
        newI = cat(2,newI,I);
    end
    imshow(newI)

end