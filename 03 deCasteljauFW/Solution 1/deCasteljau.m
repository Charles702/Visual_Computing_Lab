function point = deCasteljau(cPoly, t)

nrCPs = size(cPoly,1);

% P = (CPs, coordinates, levels)
P = zeros(nrCPs, 2, nrCPs);
P(:,:,1) = cPoly;

for i=1:nrCPs
    for j=1:nrCPs-i
        P(j,:,i+1) = t*P(j,:,i) + (1-t)*P(j+1,:,i);
    end
end

point = P(1,:,nrCPs);

end

