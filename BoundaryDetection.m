function BoundaryDetection
%% INSTRUCTIONS FOR USE
%
% You will need to specify the path that contains the images on Line 13.
%
% Interactive segments will walk you through choosing the layer colors, 
% choosing the images in each sequence to analyze, specifying the ROI for 
% each image, and choosing the function with which to find the layers.

%% Setup logistics

set(0,'DefaultFigureWindowStyle','docked')
%path_image='G:\My Drive\Maddy_Boundary_Detection\Raw_Photos';
path_image='G:\My Drive\Maddy_Boundary_Detection\BoundaryDetection\New Photos from Jenny';
path_save='G:\My Drive\Maddy_Boundary_Detection\BoundaryDetection\New Photos from Jenny\Estimated_Proportions';

%% Set Layer Colors

prompt = 'Select the colors in the layers.';
col_list = {'Blue';'Turquoise';'Purple';'Pink'};
[indx,tf] = listdlg('PromptString',prompt,'ListSTring',col_list)
ColChoices = indx;

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

%% Do image analysis
histfig=figure;
compfig=figure;
for i = 1:imNum
    
    I = imread([path_image filesep filename{i}]);
    
    %% Choose ROI
    
    if i ~= 1
        tmpfig=figure;
        imshow(I)
        hold on
        plot(roi.x,roi.y,'r-')
        pause(1)
        hold off
        bName = questdlg('Does this ROI work for this image?','ROI Check','Yes', 'No ','Yes');
        close(tmpfig)
        clear tmpfig
    else
        bName = 'No ';
    end
    
    if bName == 'No '
        
        %Give instructions to person finding the ROI
        bName = questdlg('On the following figure, click the four points that correspond to the square of sediment. Include as little of the white tank within the square as possible. Once the four points have been chosen, double click the first point to complete the square.','Instructions','Start','Start');
        
        roifig=figure;
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
    roishowfig=figure;
    imshow(I_roi)
    
    clear tmp 
    if exist('roifig','var')
    close(roifig)
    clear roifig
    end
    if exist('roishowfig','var')
    close(roishowfig)
    clear roishowfig
    end
    
    %% Color masks
    tmp = size(I_roi);
    if ismember(1,ColChoices)
        [bwBlue,BlueMask]=brightBlue(I_roi);
    else
        bwBlue=zeros(tmp(1:2));
    end
    if ismember(2,ColChoices)
        [bwTurquoise,TurquoiseMask]=brightTurquoise(I_roi);
        else
        bwTurquoise=zeros(tmp(1:2));
    end
    if ismember(3,ColChoices)
        [bwPurple,PurpleMask]=bothPurples(I_roi);
        else
        bwPurple=zeros(tmp(1:2));
    end
    if ismember (4,ColChoices)
        [bwPink,PinkMask]=bottomPink(I_roi);
        else
        bwPink=zeros(tmp(1:2));
    end
    
    %%WARNING: This next bit only works with the Turquoise layer
    if ismember(1,ColChoices) || ismember(3,ColChoices) || ismember(4,ColChoices)
        warning('Histogram analysis only currently available for Turquoise layers')
    end
    
    figure(histfig)
    subplot(imNum,1,i)
    [yh,yx]=imhist(TurquoiseMask(:,:,1));
    [ys,yx]=imhist(TurquoiseMask(:,:,2));
    [yv,yx]=imhist(TurquoiseMask(:,:,3));
    
    plot(yx,yh,'Red',yx,ys,'Green',yx,yv,'Blue')
    xlim([4,250])
    title(flnm)
    
    figure(compfig)
    subplot(round((imNum+1)/2),round((imNum+1)/2),i)
    imshow(TurquoiseMask)
    title(num2str(i))
        
    comp=bwBlue+bwTurquoise+bwPurple+bwPink;
    
    testfig=figure;
    imshow(comp)
    title(filename{i})
    
    imBoundaries {i} = comp;
    totBlue{i}=bwBlue;
    totTurquoise{i}=bwTurquoise;
    totPurple{i}=bwPurple;
    totPink{i}=bwPink;
    imOrig{i} = I_roi;
    [falsecolor]=FalseColor(I_roi,bwTurquoise, bwBlue, bwPurple, bwPink);
    
    clear tmp
    
    %Give instructions to person finding the ROI
    bName = questdlg('Are all the layers present?','Redo Layers?','Yes','No ','Yes');
    
    close(testfig,falsecolor)
    clear testfig falsecolor 
    
        if bName == 'No '
            
            clear 'comp' 'bwTurquoise' 'bwPurple' 'bwBlue' 'bwPink'
            
            [bwBlue,BlueMask]=backupBlue(I_roi);
            [bwTurquoise,TurquoiseMask]=backupTurquoise(I_roi);
            [bwPurple,PurpleMask]=backupPurples(I_roi);
            [bwPink,PinkMask]=backupPink(I_roi);
                   
            
            comp=bwBlue+bwTurquoise+bwPurple+bwPink;
            
            testfig=figure;
            imshow(comp)
            title(filename{i})
            
            FalseColor(I_roi,bwTurquoise, bwBlue, bwPurple, bwPink)
            bName = questdlg('Are all the layers present?','Redo Layers?','Yes','No ','Yes');
            
            close(testfig)
            clear testfig
            
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
     % THIS IS WHERE I NEED TO ADD THE STANDARD COMPARISON FUNCTION
    [prop]=proportion_estimation(TurquoiseMask);
    save([path_save filesep filename{i}(1:length(filename{i})-4) '.mat'], 'prop')
    
end

figure
subplot(2,1,1)
montage(imBoundaries,'size',[1 NaN])
subplot(2,1,2)
montage(imOrig,'size',[1 NaN])


end
