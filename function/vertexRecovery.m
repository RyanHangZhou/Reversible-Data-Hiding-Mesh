function operated_v = vertexRecovery(operated_bits, bit_len, magnify)
%Get float value of the vertex

operated_v = 0;
for j = 0:bit_len-1
    operated_v = operated_v + operated_bits(bit_len-j)*2^j;
end
if(operated_bits(1)==1)
    inv_dec = dec2bin(operated_v - 1, bit_len);
    true_dec = [];
    for j = 1:bit_len
        true_dec = [true_dec; xor(str2num(inv_dec(j)), 1)];
    end
    operated_v = 0;
    for j = 0:bit_len-1
        operated_v = operated_v + true_dec(bit_len-j)*2^j;
    end
    operated_v = -operated_v;
end

operated_v = operated_v/magnify;

end