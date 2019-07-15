function [meshlen, ver_bin] = meshLength(vertex, bit_len)
%Convert vertex into binary stream

[v_h, ~] = size(vertex);
ver_int = [];
for i = 1:v_h
    ver_int = [ver_int; vertex(i, 1); vertex(i, 2); vertex(i, 3);];
end
ver_bin = logical([]);
for i = 1:length(ver_int)
    temp = dec2binPN(ver_int(i), bit_len);
    ver_bin = [ver_bin; temp];
end

meshlen = length(ver_bin);

end