function [ver_bin2] = dec2binPN(numdec, N)

if (numdec>= 0)
    numbin1 = dec2bin(numdec, N);
    ver_bin2 = logical([]);
    for i = 1:N
        ver_bin2 = [ver_bin2; logical(str2num(numbin1(i)))];
    end
else
    numbin1 = dec2bin(abs(numdec), N);
    l1 = length(numbin1);
    if(N<64)
        numbin4 = 0;
        for i = 1:l1
            if (numbin1(l1-i+1) == num2str(1))
                numbin4 = numbin4 + 0;
            else
                numbin4 = numbin4 + 2^(i-1);
            end
        end
        
        numbin4 = numbin4 + 1;
        
        numbin5 = dec2bin(numbin4, N);
        numbin1 = num2str(numbin5, N);
        ver_bin2 = logical([]);
        for i = 1:N
            ver_bin2 = [ver_bin2; logical(str2num(numbin1(i)))];
        end
    else
        numbin4_1 = 0;
        numbin4_2 = 0;
        for i = 1:l1/2
            if (numbin1(l1-i+1) == num2str(1))
                numbin4_1 = numbin4_1 + 0;
            else
                numbin4_1 = numbin4_1 + 2^(i-1);
            end
        end
        for i = l1/2+1:l1
            if (numbin1(l1-i+1) == num2str(1))
                numbin4_2 = numbin4_2 + 0;
            else
                numbin4_2 = numbin4_2 + 2^(i-1-32);
            end
        end
        
        numbin4_1 = numbin4_1 + 1;
        if(numbin4_1==2^32)
            numbin4_1 = 0;
            numbin4_2 = numbin4_2 + 1;
        end
        
        num_hbin = dec2bin(numbin4_2, 32);
        num_lbin = dec2bin(numbin4_1, 64);
        ver_bin2 = logical([]);
        for i = 1:N/2
            ver_bin2 = [ver_bin2; logical(str2num(num_hbin(i)))];
        end
        for i = 33:N
            ver_bin2 = [ver_bin2; logical(str2num(num_lbin(i)))];
        end
    end
end

end