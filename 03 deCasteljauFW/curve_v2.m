 close all;

% Init control polygon
fig = figure;
axis([0 1 0 1]);
[x, y] = getpts();
cPoly = [x y];

% Plot control polygon
plot(cPoly(:,1), cPoly(:,2),'b-s');
hold on;

while true
    set(fig, 'KeyPressFcn', @quit);
    
    %Make room for curve
    stepSize = 0.01;
    c = zeros(round(1/stepSize)+1, 2);
    
    % Iterate over curve and apply deCasteljau
    for i = 0:stepSize:1
        c(round(i*(1/stepSize)+1),:) = deCasteljau(cPoly,i);  
    end
  
    % Plot curve
    axis([0 1 0 1]);
    %plot
    plot(c(:,1), c(:,2), 'r', "LineWidth",2);
    
    %select Control Point and reposition
    %cPoly = reposition(cPoly);
    cPoly = repositionInsert(cPoly);
    clf(fig);
    plot(cPoly(:,1),cPoly(:,2),'b-s', 'MarkerFaceColor','b');
    hold on;
    
end

    

