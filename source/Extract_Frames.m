clc; clear; close all;

% Parameter
width = 352;
height = 288;
YUV_type = [1, 0.5, 0.5]; 

% Read yuv file
f_name = '..\data\Calendar_CIF30.yuv';
f_id = fopen(f_name, 'r');
fr_1 = YUV_READER(f_id, width, height, YUV_type, 10, 3);
fr_2 = YUV_READER(f_id, width, height, YUV_type, 11, 3);

fr_1 = uint8(fr_1);
fr_2 = uint8(fr_2);
fr_1 = uint8(ycbcr2rgb(fr_1));
fr_2 = uint8(ycbcr2rgb(fr_2));
imwrite(fr_1, '../data/frame_0.png');
imwrite(fr_2, '../data/frame_1.png');