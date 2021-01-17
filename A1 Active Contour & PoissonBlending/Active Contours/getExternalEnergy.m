function [Eext] = getExternalEnergy(I,Wline,Wedge,Wterm)
%Derivtion of external energies
%Eline
Eline = I;

%calculate Edge: 
%[Eedge,Gdir] = imgradient(I_smooth);
[grady,gradx] = gradient(I);
Eedge = -1 * sqrt ((gradx .* gradx + grady .* grady));

%Cacluate Eterm
%Calculate derivative  Cx
fx = [0 0 0;0 -1 1;0 0 0];
Cx = conv2(I,fx,'same');

%Calculate derivative Cxx
fxx = [0 0 0;1 -2 1;0 0 0];
Cxx = conv2(I,fxx,'same');

%Calculate derivative Cy
fy = [0 0 0;0 -1 0;0 1 0];
Cy = conv2(I,fy,'same');

%Calculate derivative Cyy
fyy = [0 1 0;0 -2 0; 0 1 0];
Cyy = conv2(I,fyy,'same');

%Calculate derivative Cxy
fxy = [0 0 0; 0 1 -1;0 -1 1];
Cxy = conv2(I,fxy,'same');

% Calculate Eterm
Eterm = (Cyy.*(Cx.^2)-2*Cxy.*Cx.*Cy+ Cxx.*(Cy.^2))./((1+Cx.^2+Cy.^2).^(3/2));
Eext= Wline*Eline + Wedge*Eedge + Wterm * Eterm; 
end
