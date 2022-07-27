function BoundaryDetection

%Setup logistics

set(0,'DefaultFigureWindowStyle','docked')
path_image='G:\My Drive\Maddy_Boundary_Detection\Raw_Photos';

%% Load image
I = imread([path_image filesep 'DSC_0011.JPG']);

%% Choose ROI

%Give instructions to person finding the ROI
bName = questdlg('On the following figure, click the four points that correspond to the square of sediment. Include as little of the white tank within the square as possible. Once the four points have been chosen, double click the first point to complete the square.','Instructions','Start','Start');

figure
imshow(I)
title(['Choose ROI points.'])

% Interactively find ROI
h = impoly;
roi_poly = wait(h);

% Store ROI points
tmp = getPosition(h);
roi.x = tmp(:,1);
roi.y = tmp(:,2);

% Show ROI points
delete(h)
hold on
plot(roi.x,roi.y,'r-')
pause(1)
hold off

x=[round(min(roi.x)),round(max(roi.x))];
y=[round(min(roi.y)),round(max(roi.y))];

I_roi=I(y(1):y(2),x(1):x(2),:);
figure
imshow(I_roi)

%% Color masks
[bwBlue,BlueMask]=brightBlue(I_roi);
[bwTurquiose,TurquioseMask]=brightTurquiose(I_roi);
[bwPurple,PurpleMask]=bothPurples(I_roi);
[bwPink,PinkMask]=bottomPink(I_roi);

comp=bwBlue+bwTurquiose+bwPurple+bwPink;

figure
imshow(comp)

grayroi=rgb2gray(I_roi);


withlines=imcomplement(comp)+im2double(rgb2gray(I_roi));

figure
imshow(withlines)

figure
imshow(imcomplement(comp))

figure
imshow(bwskel(I_roi(find(comp))))

end
