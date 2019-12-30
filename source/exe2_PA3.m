clc; clear; close all;

%% Parameter
width = 352;
height = 288;
YUV_type = [1, 0.5, 0.5]; 
blk_size = 4;
rgb_flow_path = '..\data\new_flownets\flow_map.mat';

%% Read yuv file
f_name = '..\data\Calendar_CIF30.yuv';
f_id = fopen(f_name, 'r');
fr_0 = YUV_READER(f_id, width, height, YUV_type, 10, 1);
fr_1 = YUV_READER(f_id, width, height, YUV_type, 11, 1);

%% Estimate motion vectors
[v1_LK, v2_LK] = Lucas_Kanade(fr_0, fr_1, blk_size);  % Using Lucas-Kanade algorithm
[v1_HS, v2_HS] = Horn_Schunck(fr_0, fr_1, blk_size);  % Using Horn-Schunck algorithm
[v1_new_flownets, v2_new_flownets] = FlowNet(rgb_flow_path); % Get optical flows predicted by new FlowNetS

%% Reconstruct frame
[~, rec_LK] = Motion_Compensation(fr_0, fr_1, v1_LK, v2_LK, blk_size);
[~, rec_HS] = Motion_Compensation(fr_0, fr_1, v1_HS, v2_HS, blk_size);
[~, rec_new_flownets] = Motion_Compensation(fr_0, fr_1, v1_new_flownets, v2_new_flownets, blk_size);

%% Quality measurement
% Calculate the differences
diff_LK = abs(fr_0 - rec_LK);
diff_HS = abs(fr_0 - rec_HS);
diff_new_flownets = abs(fr_0 - rec_new_flownets);

% L1 Error
L1_LK = sum(sum(diff_LK))/(height*width);
L1_HS = sum(sum(diff_HS))/(height*width);
L1_new_flownets = sum(sum(diff_new_flownets))/(height*width);

% Determine PSNR
psnr_LK = psnr(rec_LK, fr_0, 255);
psnr_HS = psnr(rec_HS, fr_0, 255);
psnr_new_flownets = psnr(rec_new_flownets, fr_0, 255);

%% Display
% Plot the difference between reference and recontructed frame
figure('Name', 'Reconstruction and Reference Frame');
subplot(3,3,1); imshow(uint8(fr_0)); title('10th Frame');
subplot(3,3,2); imshow(uint8(rec_LK)); title('Lucas-Kanade Reconstruction');
subplot(3,3,3); imshow(uint8(diff_LK)); title('Lucas-Kanade Difference');

subplot(3,3,4); imshow(uint8(fr_0)); title('10th Frame');
subplot(3,3,5); imshow(uint8(rec_HS)); title('Horn-Schunck Reconstruction');
subplot(3,3,6); imshow(uint8(diff_HS)); title('Horn-Schunck Difference');

subplot(3,3,7); imshow(uint8(fr_0)); title('10th Frame');
subplot(3,3,8); imshow(uint8(rec_new_flownets)); title('New FlowNetS Reconstruction');
subplot(3,3,9); imshow(uint8(diff_new_flownets)); title('New FlowNetS Difference');

% Print PSNR values
fprintf('Lucas-Kanade: PSNR = %2.2f dB\n', psnr_LK);
fprintf('Horn-Schunck: PSNR = %2.2f dB\n', psnr_HS);
fprintf('New FlowNetS: PSNR = %2.2f dB\n', psnr_new_flownets);

% Print L1 Errors
fprintf('\nLucas-Kanade: L1 Error = %1.4f\n', L1_LK);
fprintf('Horn-Schunck: L1 Error = %1.4f\n', L1_HS);
fprintf('New FlowNetS: L1 Error = %1.4f\n', L1_new_flownets);
