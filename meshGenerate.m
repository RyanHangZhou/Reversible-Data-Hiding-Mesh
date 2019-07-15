% ========================================================================
% USAGE: vertex2 = meshGenerate(ver_bin, magnify, face, bit_len, file_name, encrypt_name)
% Convey binarized mesh stream into 3D structure
%
% Inputs
%       ver_bin       -binarized mesh stream
%       magnify       -magnify of converting integers to decimals
%       face          -information of connectivity among vertices
%       bit_len       -bit-length of each vertice's coordinate
%       file_name     -filename of 3D mesh
%       encrypt_name  -filename of encrypted mesh
%
% Outputs
%       vertex2       -binarized encrypted 3D mesh
%
% Hang Zhou, June, 2016
% ========================================================================
function vertex2 = meshGenerate(ver_bin, magnify, face, bit_len, file_name, encrypt_name)
% show encrypted mesh

ver2_int = [];
for i = 1:length(ver_bin)/bit_len
    ver2_temp_bin = ver_bin((i-1)*bit_len+1: i*bit_len);
    ver2_temp = 0;
    for j = 0:bit_len-1
        ver2_temp = ver2_temp + ver2_temp_bin(bit_len-j)*2^j;
    end
    if(ver2_temp_bin(1)==1)
        inv_dec = dec2bin(ver2_temp - 1, bit_len);
        true_dec = [];
        for j = 1:bit_len
            true_dec = [true_dec; xor(str2num(inv_dec(j)), 1)];
        end
        ver2_temp = 0;
        for j = 0:bit_len-1
            ver2_temp = ver2_temp + true_dec(bit_len-j)*2^j;
        end
        ver2_temp = -ver2_temp;
    end
    ver2_int = [ver2_int; ver2_temp];
end

vertex2 = [];
for i = 1:length(ver_bin)/bit_len/3
    vertex2(i, 1) = ver2_int(3*(i-1)+1);
    vertex2(i, 2) = ver2_int(3*(i-1)+2);
    vertex2(i, 3) = ver2_int(3*(i-1)+3);
end

vertex2 = vertex2/magnify;

out_file = fullfile('data', encrypt_name, [file_name, '.off']);
write_off(out_file, vertex2, face);

end