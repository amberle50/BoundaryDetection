function BoundaryDetection
%% INSTRUCTIONS FOR USE
% 
% You will need to specify the path that contains the images on Line 12.
% 
% Interactive segments will walk you through choosing the images in each
% sequence to analyze and specifying the ROI for each image.

%% Setup logistics

set(0,'DefaultFigureWindowStyle','docked')
path_image='G:\My Drive\Maddy_Boundary_Detection\Raw_Photos';

%% Load images

prompt = 'How many images are in this sequence?';
input = inputdlg(prompt)
imNum = str2num(input{1});

filename = {};
for i = 1:imNum
    list=dir(path_image);
    lst={list.name};
    [indx,tf] = listdlg('PromptString',{['Select image number ' num2str(i)], ' in the image sequence.'},'ListSTring',lst,'SelectionMode','single')
    flnm=lst{indx};
    
    filename{i} = flnm;
end

for i = 1:imNum
    
    I = imread([path_image filesep filename{i}]);
    
    %% Choose ROI
    
    if i ~= 1
       % I_roi=I(y(1):y(2),x(1):x(2),:);
        figure
        imshow(I)
        hold on
        plot(roi.x,roi.y,'r-')
        pause(1)
        hold off
        bName = questdlg('Does this ROI work for this image?','ROI Check','Yes', 'No ','Yes');
    else 
        bName = 'No ';
    end
    
    if bName == 'No '
        
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
        
    end
    
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
    title(filename{i})
    
%     figure
%     imshow(imcomplement(comp))
    
    imBoundaries {i} = comp;
    
end

figure
montage(imBoundaries,'size',[1 NaN])

end
