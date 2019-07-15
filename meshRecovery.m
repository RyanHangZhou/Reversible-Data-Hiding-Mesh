% ========================================================================
% USAGE: [ext_m, vertex2] = meshRecovery(m, vertex, face, xorlen, file_name, mu)
% Preprocess mesh data into integer structures
%
% Inputs
%       m            -bits of precision
%       vertex       -mesh vertices
%       face         -information of connectivity among vertices
%       xorlen       -bit-length of each vertice's coordinate
%       file_name    -filename of meshes
%       mu           -hyperparameter in fluctuation function
%
% Outputs
%       ext_m        -extracted messages
%       vertex2      -recovered vertices of meshes
%
% Hang Zhou, June, 2016
% ========================================================================
function [ext_m, vertex2] = meshRecovery(m, vertex, face, xorlen, file_name, mu)
%mesh recovery

%% Convert vertexes into bitstream
magnify = 10^m;
[vertex1, bit_len] = meshPrepro(m, vertex);
[~, ver_bin] = meshLength(vertex1, bit_len);

%% Separate vertexes into 2 sets
[num_face, ~] = size(face);
face = int32(face);
Vertemb = int32([]);
Vertnoemb = int32([]);

for i = 1:num_face
    v1 = isempty(find(face(i, 1)==Vertemb))==0;
    v2 = isempty(find(face(i, 2)==Vertemb))==0;
    v3 = isempty(find(face(i, 3)==Vertemb))==0;
    v4 = isempty(find(face(i, 1)==Vertnoemb))==0;
    v5 = isempty(find(face(i, 2)==Vertnoemb))==0;
    v6 = isempty(find(face(i, 3)==Vertnoemb))==0;
    if(v1==0 && v2==0 && v3==0) %no adjacent vertexes
        if(v4==0 && v5==0 & v6==0)
            Vertemb = [Vertemb face(i, 1)];
            Vertnoemb = [Vertnoemb face(i, 2) face(i, 3)];
        elseif(v4==0 && v5==0 & v6==1)
            Vertemb = [Vertemb face(i, 1)];
            Vertnoemb = [Vertnoemb face(i, 2)];
        elseif(v4==0 && v5==1 & v6==0)
            Vertemb = [Vertemb face(i, 1)];
            Vertnoemb = [Vertnoemb face(i, 3)];
        elseif(v4==1 && v5==0 & v6==0)
            Vertemb = [Vertemb face(i, 2)];
            Vertnoemb = [Vertnoemb face(i, 3)];
        elseif(v4==0 && v5==1 & v6==1)
            Vertemb = [Vertemb face(i, 1)];
        elseif(v4==1 && v5==0 & v6==1)
            Vertemb = [Vertemb face(i, 2)];
        elseif(v4==1 && v5==1 & v6==0)
            Vertemb = [Vertemb face(i, 3)];
        elseif(v4==1 && v5==1 & v6==1)
        end
    else %some adjacent vertexes
        if(v1==0)
            Vertnoemb = [Vertnoemb face(i, 1)];
        end
        if(v2==0)
            Vertnoemb = [Vertnoemb face(i, 2)];
        end
        if(v3==0)
            Vertnoemb = [Vertnoemb face(i, 3)];
        end
    end
    Vertnoemb = unique(Vertnoemb);
end

%% Use curvature to extract the messages
[~, num_vertemb] = size(Vertemb);
ext_m = [];
for i = 1:num_vertemb
    index = int32(Vertemb(i));
    %Get two cases of vertexes and convert to float
    for j = 1:3
        operated_bits1 = ver_bin(3*(index-1)*bit_len + ... 
            (j-1)*bit_len + 1: 3*(index-1)*bit_len + (j-1)*bit_len + bit_len);
        operated_bits2 = xor(operated_bits1, [zeros(bit_len-xorlen, 1); ones(xorlen, 1)]);
        operated_v1(j) = vertexRecovery(operated_bits1, bit_len, magnify);
        operated_v2(j) = vertexRecovery(operated_bits2, bit_len, magnify);
    end
    %Find surrounding vertexes' coordinates
    [row, ~, ~] = find(face==index);
    f_len = length(row);
    face_d = [];
    face_c1 = [];
    face_c2 = [];
    for j = 1:f_len
        face_d = [face_d; setdiff(face(row(j), :), index)];
        face_c1 = [face_c1; [vertex(face_d(j, 1), 1) vertex(face_d(j, 1), 2) vertex(face_d(j, 1), 3)]];
        face_c2 = [face_c2; [vertex(face_d(j, 2), 1) vertex(face_d(j, 2), 2) vertex(face_d(j, 2), 3)]];
    end
    %Calculate area
    %Case1
    ma1 = []; mb1 = []; mc1 = []; peri1 = []; area1 = []; theta1 = []; min_angle1 = []; max_peri1 = [];
    for j = 1:f_len
        ma1(j) = sqrt((operated_v1(1)-face_c1(j, 1))^2+(operated_v1(2)-face_c1(j, 2))^2+(operated_v1(3)-face_c1(j, 3))^2);
        mb1(j) = sqrt((operated_v1(1)-face_c2(j, 1))^2+(operated_v1(2)-face_c2(j, 2))^2+(operated_v1(3)-face_c2(j, 3))^2);
        mc1(j) = sqrt((face_c1(j, 1)-face_c2(j, 1))^2+(face_c1(j, 2)-face_c2(j, 2))^2+(face_c1(j, 3)-face_c2(j, 3))^2);
        peri1(j) = (ma1(j) + mb1(j) + mc1(j))/2;
        area1(j) = sqrt(peri1(j)*(peri1(j)-ma1(j))*(peri1(j)-mb1(j))*(peri1(j)-mc1(j)));
        theta1(j) = acosd(((ma1(j)^2)+(mb1(j)^2)-(mc1(j)^2))/(2*ma1(j)*mb1(j)));
%         theta11(j) = acosd((ma1(j)^2+(mc1(j)^2)-mb1(j)^2)/(2*ma1(j)*mc1(j)));
%         theta111(j) = acosd((mb1(j)^2+(mc1(j)^2)-ma1(j)^2)/(2*mb1(j)*mc1(j)));
%         min_angle1 = [min_angle1 min(theta1(j), min(theta11(j), theta111(j)))];
        max_peri1 = [max_peri1 max(ma1(j), max(mb1(j), mc1(j)))];
    end
    curv1 = (360 - sum(theta1))/sum(area1);
    peri1 = sum(max_peri1);
    g1 = curv1 + mu*peri1;
    %Case2
    ma2 = []; mb2 = []; mc2 = []; peri2 = []; area2 = []; theta2 = []; min_angle2 = []; max_peri2 = [];
    for j = 1:f_len
        ma2(j) = sqrt((operated_v2(1)-face_c1(j, 1))^2+(operated_v2(2)-face_c1(j, 2))^2+(operated_v2(3)-face_c1(j, 3))^2);
        mb2(j) = sqrt((operated_v2(1)-face_c2(j, 1))^2+(operated_v2(2)-face_c2(j, 2))^2+(operated_v2(3)-face_c2(j, 3))^2);
        mc2(j) = sqrt((face_c1(j, 1)-face_c2(j, 1))^2+(face_c1(j, 2)-face_c2(j, 2))^2+(face_c1(j, 3)-face_c2(j, 3))^2);
        peri2(j) = (ma2(j) + mb2(j) + mc2(j))/2;
        area2(j) = sqrt(peri2(j)*(peri2(j)-ma2(j))*(peri2(j)-mb2(j))*(peri2(j)-mc2(j)));
        theta2(j) = acosd(((ma2(j)^2)+(mb2(j)^2)-(mc2(j)^2))/(2*ma2(j)*mb2(j)));
        max_peri2 = [max_peri2 max(ma2(j), max(mb2(j), mc2(j)))];
    end
    curv2 = (360 - sum(theta2))/sum(area2);
    peri2 = sum(max_peri2);
    g2 = curv2 + mu*peri2;
    if(g1<g2)
        ext_m = [ext_m; 0];
    else
        ext_m = [ext_m; 1];
    end
end

%% Recover the mesh
%XOR
for i = 1:num_vertemb
    if(ext_m(i)==1)
        index = int32(Vertemb(i));
        for j = 1:3
            operated_bits = ver_bin(3*(index-1)*bit_len + ... 
                (j-1)*bit_len + 1: 3*(index-1)*bit_len + (j-1)*bit_len + bit_len);
            operated_bits = xor(operated_bits, [zeros(bit_len-xorlen, 1); ones(xorlen, 1)]);
            ver_bin(3*(index-1)*bit_len + (j-1)*bit_len + 1: ...
                3*(index-1)*bit_len + (j-1)*bit_len + bit_len) = operated_bits;
        end
    end
end
%Convert into the recovered
encrypt_name = 'recovered';
vertex2 = meshGenerate(ver_bin, magnify, face, bit_len, file_name, encrypt_name);


end