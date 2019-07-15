% =========================================================================
% An example code for the algorithm proposed in
%
%   Ruiqi Jiang, Hang Zhou, Weiming Zhang, and Nenghai Yu.
%   "Reversible Data Hiding in Encrypted 3D Mesh Models", TMM 2017.
%
%
% Written by Hang Zhou @ EEIS USTC
% July, 2016.
% =========================================================================

clear; clc; close all;
addpath(genpath(pwd));

fprintf('Conduct RDH-ED in 3D meshes:\n');

tic

m = 6;
xorlen = 6;
mu = 10;
gamma = 1.3;

name = 'beetle.off';
source_dir = 'data/source';
source_dir = [source_dir,'/',name];

%% Read a 3D mesh file
[~, file_name, suffix] = fileparts(source_dir);
if(strcmp(suffix,'.obj')==0) %off
    [vertex, face] = read_mesh(source_dir);
    vertex = vertex'; face = face';
else %obj
    Obj = readObj(source_dir);
    vertex = Obj.v; face = Obj.f.v;
end

vertex0 = vertex;

%% Preprocessing
magnify = 10^m;
[vertex, bit_len] = meshPrepro(m, vertex);

%% Encryption
%Compute mesh length
[meshlen, ver_bin] = meshLength(vertex, bit_len);
%Generate a psudorandom stream
k_enc = 12345;
sec_bin = logical(pseudoGenerate(meshlen, k_enc));
%Encrypt
enc_bin = xor(ver_bin, sec_bin);
%Generate encrypted mesh
encrypt_name = 'encrypted';
vertex1 = meshGenerate(enc_bin, magnify, face, bit_len, file_name, encrypt_name);

%% Message embedding
[vertex1, message_bin] = meshEmbed(m, vertex1, face, xorlen, file_name);

%% Decryption
vertex2 = meshDecrypt(vertex1, sec_bin, m);
out_file = fullfile('data', 'decrypted', [file_name, '.off']);
write_off(out_file, vertex2, face);

%% Message extraction & mesh recovery
[ext_m, vertex3] = meshRecovery(m, vertex2, face, xorlen, file_name, mu);

%capacity = m/v
[v_n, ~] = size(vertex);
capacity = length(ext_m)/v_n;
fid1 = fopen('result/capacity.txt', 'a');
fprintf(fid1, '%f', capacity);
fprintf(fid1, '\r\n');
fclose(fid1);

err_dist = message_bin - ext_m;
err_len = length(find(err_dist(:)~=0));
err_percentg = err_len/length(ext_m);
fid2 = fopen('result/errorperctg.txt', 'a');
fprintf(fid2, '%f', err_percentg);
fprintf(fid2, '\r\n');
fclose(fid2);
correct_percentg = 1 - err_percentg;
fid3 = fopen('result/correctperctg.txt', 'a');
fprintf(fid3, '%f', correct_percentg);
fprintf(fid3, '\r\n');
fclose(fid3);

%direct recovery
snr1 = meshSNR(vertex0, vertex2);
fid4 = fopen('result/snr1.txt', 'a');
fprintf(fid4, '%f', snr1);
fprintf(fid4, '\r\n');
fclose(fid4);
%lossless recovery
snr2 = meshSNR(vertex0, vertex3);
fid5 = fopen('result/snr2.txt', 'a');
fprintf(fid5, '%f', snr2);
fprintf(fid5, '\r\n');
fclose(fid5);

toc

