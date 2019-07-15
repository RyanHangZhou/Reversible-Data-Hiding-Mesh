
clear; clc;

%proper vertexes
% face_c1 = [0.8768   -0.1650   -0.0482;
%            0.3203   -0.0875   -0.0326;
%            0.3203   -0.0875   -0.0326;
%            0.8768   -0.1650   -0.0482;
%            0.6405   -0.1448   -0.2977;
%            0.7421   -0.1650    0.3101];
% face_c2 = [0.7421   -0.1650    0.3101;
%            0.3084   -0.0875   -0.1516;
%            0.5644   -0.1448    0.2281;
%            0.6405   -0.1448   -0.2977;
%            0.3084   -0.0875   -0.1516;
%            0.5644   -0.1448    0.2281];
% operated_v2 = [0.5627   -0.2649   -0.3674];

%wrong vertexes
face_c1 = [  0.3203   -0.0875   -0.0326;
    0.0974   -0.3055   -0.0263;
    0.0974   -0.3055   -0.0263;
    0.3203   -0.0875   -0.0326;
    0.3099   -0.2784   -0.3499;
    0.2729   -0.0875    0.0934];
face_c2 = [   0.2729   -0.0875    0.0934;
    0.3152   -0.1042   -0.3522;
    0.0897   -0.1313    0.0088;
    0.3099   -0.2784   -0.3499;
    0.3152   -0.1042   -0.3522;
    0.0897   -0.1313    0.0088];
operated_v2 = [0.1029   -0.1313   -0.0265];


axis([-1,1,-1,1,-1,1])
% plot3(operated_v2(1),operated_v2(2),operated_v2(3),'.r','markersize',50)
for i = 1:6
    c1 = face_c1(i, :);
    c2 = face_c2(i, :);
    x = [face_c1(i, 1); face_c2(i, 1); operated_v2(1); face_c1(i, 1)];
    y = [face_c1(i, 2); face_c2(i, 2); operated_v2(2); face_c1(i, 2)];
    z = [face_c1(i, 3); face_c2(i, 3); operated_v2(3); face_c1(i, 3)];
    plot3(x,y,z, 'b')
    hold on
end

xlabel('X')
ylabel('Y')
zlabel('Z')
grid on
