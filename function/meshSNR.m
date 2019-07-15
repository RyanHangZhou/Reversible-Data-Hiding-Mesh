function snr = meshSNR(Pts1, Pts2)
v = mean(Pts1);
vv = Pts1 - repmat(v, size(Pts1,1), 1);
up = sum(sum(vv.^2));

ww = Pts2 - Pts1;
down = sum(sum(ww.^2));

snr = up / down;
snr = 10 * log10(snr);
end