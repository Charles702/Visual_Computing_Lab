function cPoly = repositionInsert(cPoly)
    % Select point
    [x,y] = ginput(1);
    point = [x,y];
    
    % Calculate midpoints of edges
    %msize = size(cPoly, 1) - 1;
    mPoly = cPoly(1:end-1,:) + .5*(cPoly(2:end,:)-cPoly(1:end-1,:));
    %mPoly = [cPloy; mPoly ];
    % Test if mouse is near CP or edge midpoint
    [minEdge, iEdge] = min(vecnorm(mPoly -  point, 2, 2));
    [minCP, iCP] = min(vecnorm(cPoly - point, 2, 2));

    if minCP < minEdge
        plot(cPoly(iCP, 1), cPoly(iCP, 2), 'gs', "MarkerEdgeColor","g");
    else % Highlight edge
        plot(cPoly(iEdge:iEdge+1, 1), cPoly(iEdge:iEdge+1,2), 'g-s', 'MarkerFaceColor','g')
    end

    % Select new pos
    [x,y] = ginput(1);
    
    if(minCP <= minEdge) % Move CP
        cPoly(iCP,:) = [x, y];
    else %Insert new CP
        cPoly = [cPoly(1:iEdge,:); [x,y]; cPoly(iEdge+1:end,:)];
    end
    % Move CP or insert new CP
end