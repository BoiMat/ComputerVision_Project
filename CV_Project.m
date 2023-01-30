%% Data load
% The twenty images are loaded from the images folder. The path can
% modified to 
% imageFileName_full = "phone_images" + filesep + "image" + num2str(iimage_full(ii)) + ".jpg";
% to use the second set of images. In addition the function call
% 'imread()',
% the function 'rgb2gray()' should called to convert the images from RGB to
% gray scale.

clear imageData

iimage_full= 1:20;
addpath('functions/')

for ii=1:length(iimage_full)

  imageFileName_full = "images" + filesep + "image" + num2str(iimage_full(ii)) + ".tif";
 
  imageData(ii).I = imread(imageFileName_full); %#ok

  [imageData(ii).XYpixel, boardsize] = detectCheckerboardPoints(imageData(ii).I, 'PartialDetections', false); %#ok

end

%% Detected points plot
% The detected points are plotted with an index assigned to each point. 
for ii = 1:length(iimage_full)
    hnd = figure;
    img = imshow(imageData(ii).I);
    hold on  
    
    for jj=1:size(imageData(ii).XYpixel,1)
      x=imageData(ii).XYpixel(jj,1);
      y=imageData(ii).XYpixel(jj,2);
      plot(x,y,'or')
    
      hndtxt = text(x,y,num2str(jj));
      set(hndtxt,'fontsize',10,'color','green');
    end
end

%% Zhang's camera calibration method

squaresize = 30; % = 25 if using the phone images

n = length(imageData(1).XYpixel);

imageData = compute_realworldPoints(imageData, boardsize, squaresize);

imageData = compute_Homographies(imageData, false);

K = compute_IntrinsicParams(imageData);

imageData = compute_ExtrinsicParams(imageData, K);

%% Reprojection Error

[imageData, reprError] = compute_reprojectionError(imageData, '.', false, 0, K, false);
mean(reprError)

%% Cylinder projection

center = imageData(1).XYmm(n/2 + 1,:);
radius = 60;
height = 80;
npoints = 1000;

plot_cylinder(imageData, npoints, radius, height, center)

%% Radial Distortion

maxIter = 500;
tolerance = 1e-8;

tic
oldData = imageData;
[imageData, k_conCheck, P_conCheck] = compensate_radialDistortion(imageData, K, maxIter, tolerance);
toc

k = estimate_radialDistortionCoeffs(imageData, K, n);
[imageData, reprError] = compute_reprojectionError(imageData, '.', true, k, K, false);
mean(reprError)