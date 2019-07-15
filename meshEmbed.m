% ========================================================================
% USAGE: [vertex1, message_bin] = meshEmbed(m, vertex, face, xorlen, file_name)
% Embed data into binary stream
%
% Inputs
%       m            -bits of precision
%       vertex       -binarized mesh vertices
%       face         -information of connectivity among vertices
%       xorlen       -bit-length of each vertice's coordinate
%
% Outputs
%       vertex1      -data-embedded binarized vertices
%       message_bin  -embedded messages
%
% Hang Zhou, June, 2016
% ========================================================================
function [vertex1, message_bin] = meshEmbed(m, vertex, face, xorlen, file_name)
%Embed messages into vertexes of the encrypted mesh

%% Convert Vertexes into Bitstream
magnify = 10^m;
[vertex, bit_len] = meshPrepro(m, vertex);
[~, ver_bin] = meshLength(vertex, bit_len);

%% Separate Vertexes into 2 Sets
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

%% Embed messages into selected vertexes
%Generate the embedded message
[~, num_vertemb] = size(Vertemb);
k_emb = 54321;
message_bin = logical(pseudoGenerate(num_vertemb, k_emb));
%XOR
for i = 1:num_vertemb
    if(message_bin(i)==1)
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
%Reset into vertexes
encrypt_name = 'embedded';
vertex1 = meshGenerate(ver_bin, magnify, face, bit_len, file_name, encrypt_name);

end