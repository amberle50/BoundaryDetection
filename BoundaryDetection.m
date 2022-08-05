function BoundaryDetection
%% INSTRUCTIONS FOR USE
%
% You will need to specify the path that contains the images on Line 13.
%
% Interactive segments will walk you through choosing the images in each
% sequence to analyze, specifying the ROI for each image, and choosing 
% the function with which to find the layers.

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
    [bwTurquoise,TurquoiseMask]=brightTurquoise(I_roi);
    [bwPurple,PurpleMask]=bothPurples(I_roi);
    [bwPink,PinkMask]=bottomPink(I_roi);
    
    comp=bwBlue+bwTurquoise+bwPurple+bwPink;
    
    figure
    imshow(comp)
    title(filename{i})
    
    imBoundaries {i} = comp;
    totBlue{i}=bwBlue;
    totTurquoise{i}=bwTurquoise;
    totPurple{i}=bwPurple;
    totPink{i}=bwPink;
    imOrig{i} = I_roi;
    FalseColor(I_roi,bwTurquoise, bwBlue, bwPurple, bwPink)
    
    %Give instructions to person finding the ROI
    bName = questdlg('Are all the layers present?','Redo Layers?','Yes','No ','Yes');
        
        if bName == 'No '
            
            clear 'comp' 'bwTurquoise' 'bwPurple' 'bwBlue' 'bwPink'
            
            [bwBlue,BlueMask]=backupBlue(I_roi);
            [bwTurquoise,TurquoiseMask]=backupTurquoise(I_roi);
            [bwPurple,PurpleMask]=backupPurples(I_roi);
            [bwPink,PinkMask]=backupPink(I_roi);
            
            
            comp=bwBlue+bwTurquoise+bwPurple+bwPink;
            
            figure
            imshow(comp)
            title(filename{i})
            
            FalseColor(I_roi,bwTurquoise, bwBlue, bwPurple, bwPink)
            bName = questdlg('Are all the layers present?','Redo Layers?','Yes','No ','Yes');
            
            if bName=='Yes'
                totBlue{i}=bwBlue;
                totTurquoise{i}=bwTurquoise;
                totPurple{i}=bwPurple;
                totPink{i}=bwPink;
                imBoundaries {i} = comp;
                imOrig{i} = I_roi;
            elseif bName == 'No '
                error 'Layering may need to detected by hand...'
            end

    end
end

figure
subplot(2,1,1)
montage(imBoundaries,'size',[1 NaN])
subplot(2,1,2)
montage(imOrig,'size',[1 NaN])


disp 'Breakpoint'

end
