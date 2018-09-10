% Copyright 2018 Novartis Institutes for BioMedical Research Inc. Licensed
% under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0. Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.%


close all
clc

dir_path = uigetdir(pwd,'Choose image folder:');
file_list = dir(fullfile(dir_path,'*.tif*'));

prompt = 'Enter threshold value:';
level = inputdlg(prompt);
level = str2double(level{:})/255;

prompt = 'Enter radius for ROI:';
radius = inputdlg(prompt);
radius = str2double(radius{:});

prompt = 'Enter Number of ROI:';
ROInumber = inputdlg(prompt);
ROInumber = str2double(ROInumber{:});

se_roi = strel('disk',radius,0);
se_border = strel('disk',5,0);

roi = getnhood(se_roi);
roi_border = uint8(bwperim(roi).*255);
roi_border = padarray(roi_border,[5,5]);
roi_border = imdilate(roi_border,se_border);

x_val = zeros(1,3);
y_val = zeros(1,3);
area = zeros(1,3);
roi_area = zeros(2*radius+1);
roi_gray = zeros(2*radius+1);
mean_gray = zeros(size(file_list,1),3);
intDen = zeros(size(file_list,1),3);

rand_ind    = randperm(size(file_list,1));

figure()
for ind0 = 1:size(file_list,1)
    raw_img     = imread(fullfile(dir_path,file_list(rand_ind(ind0)).name));
    raw_img     = uint8(raw_img(:,:,1));
    thresh_img  = im2bw(raw_img,level);

    disp_data(:,:,1) = raw_img;
    disp_data(:,:,2) = raw_img;
    disp_data(:,:,3) = raw_img+uint8(thresh_img.*255);
    imshow(disp_data,'InitialMagnification','fit')
    title(sprintf('Image %u of %u',ind0,size(file_list,1)))
    
    for ind1 = 1:ROInumber
        [x,y] = ginput(1);

        while x < 156 || x > size(raw_img,2) - 156 || y < 156 || y > size(raw_img,1) - 156
            uiwait(warndlg('Point too close to edge of image, click again','Warning','replace'))
            [x,y] = ginput(1);
        end
        
        disp_data(floor(y)-(radius+5):floor(y)+(radius+5),floor(x)-(radius+5):floor(x)+(radius+5),1) = raw_img(floor(y)-(radius+5):floor(y)+(radius+5),floor(x)-(radius+5):floor(x)+(radius+5)) + roi_border.*255;
        imshow(disp_data,'InitialMagnification','fit')
        title(sprintf('Image %u of %u',ind0,size(file_list,1)))
        x_val(ind1) = x;
        y_val(ind1) = y;
        
        roi_area = thresh_img(floor(y)-radius:floor(y)+radius,floor(x)-radius:floor(x)+radius).*roi;
        roi_gray = raw_img(floor(y)-radius:floor(y)+radius,floor(x)-radius:floor(x)+radius).*uint8(roi_area);
        
        area(ind0,ind1)         = nnz(roi_area);
        mean_gray(ind0,ind1)    = mean(nonzeros(roi_gray));
        intDen(ind0,ind1)       = area(ind0,ind1) * mean_gray(ind0,ind1);
    end
    waitforbuttonpress()
end
close all
output_data = cell(11,size(file_list,1)+1);
for ind0 = 1:size(file_list,1)
    if ind0 == 1
        output_data{1,ind0}     = 'Filename';
        output_data{2,ind0}     = 'IntDen';
        output_data{3,ind0}     = 'MeanGray';
        
        output_data{5,ind0}     = 'Lesion 1 IntDen';
        output_data{6}          = 'Lesion 2 IntDen';
        output_data{7}          = 'Lesion 3 IntDen';
        
        output_data{9,ind0}     = 'Lesion 1 MeanGray';
        output_data{10,ind0}	= 'Lesion 2 MeanGray';
        output_data{11,ind0}	= 'Lesion 3 MeanGray';
        
        output_data{13,ind0}	= 'Lesion 1 Area';
        output_data{14,ind0}	= 'Lesion 2 Area';
        output_data{15,ind0}	= 'Lesion 3 Area';
    end
        
    output_data{1,ind0+1} = file_list(rand_ind(ind0)).name;
    output_data{2,ind0+1} = mean(intDen(ind0,:));
    output_data{3,ind0+1} = mean(mean_gray(ind0,:));
    for ind1 = 1:3
        output_data{4+ind1,ind0+1}	= intDen(ind0,ind1);
        output_data{8+ind1,ind0+1}	= mean_gray(ind0,ind1);
        output_data{12+ind1,ind0+1}	= area(ind0,ind1);
    end
end
OutputFile_XLSX = fullfile(dir_path,strcat('Output_Data_', datestr(now,'mmddyy_HHMM'), '.xlsx'));
xlswrite(OutputFile_XLSX,output_data)
fprintf('Excel data saved to:\n%s\n',OutputFile_XLSX)
winopen(OutputFile_XLSX)

% output_path = fullfile(dir_path,'Output_excel_file.xls');                   % Build filepath
% fprintf('Writing data to Excel...\n')                                       % Alert user of export
% xlswrite(output_path,output_data)                                           % Write data to Excel
% winopen(output_path)