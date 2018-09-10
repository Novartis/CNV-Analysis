# CNV_Analysis_V3

### License
Copyright 2018 Novartis Institutes for BioMedidical Research Inc.
Licensed under the Apache License, Version 2.0 (the "License");
ou may not use this file except in complicane with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/License-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distrubuted on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONITIONS OF ANY KIND, either express or 
implied. See the License for the specific Language Governing the permissions 
and limiations under the License. 

### Overview
This MatLab Image Analysis code will analyze the area of staining, mean gray 
value, and the integrated density (product of the are and mean gray value) 
of the selected choroidal neovascularization (CNV). 

This analysis requires the Image Processing Toolbox and Signal Processing 
Toolbox for MatLab to function. 

All files must be Tagged Image Format (.tiff). Images will be displayed 
to the user in a masked, and randomized fashion to avoid an biases. 

### Procedure 
1. Run the script in MatLab
2. Direct the program to the folder containing the images
3. Input a threshold value to be applied to every image (0-255)
4. Input a radius for each region of interest (ROI) in pixels
5. Input a number of ROIs (1-3)
6. Place first ROI over a CNV Lesion
7. Click to advance to the next ROI
8. Space bar will advance to the next image
9. Once all images have been analyzed an excel file will compile the results