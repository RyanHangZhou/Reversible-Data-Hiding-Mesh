function s = pseudoGenerate(len, key)

rand('state', key);
s = rand(len, 1)>0.5;