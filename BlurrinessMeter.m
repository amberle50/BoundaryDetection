function BlurrinessMeter

%% Setup logistics

set(0,'DefaultFigureWindowStyle','docked')
path_image='G:\My Drive\Maddy_Boundary_Detection\BoundaryDetection\New Photos from Jenny';
path_roisave='G:\My Drive\Maddy_Boundary_Detection\BoundaryDetection\New Photos from Jenny\Estimated_Proportions';

%% Load images

prompt = 'How many images are in this sequence?';
input = inputdlg(prompt);
imNum = str2double(input{1});

filename = cell(1,imNum);
for i = 1:imNum
    list=dir(path_image);
    lst={list.name};
    [indx,~] = listdlg('PromptString',{['Select image number ' num2str(i)], ' in the image sequence.'},'ListSTring',lst,'SelectionMode','single');
    filename{i} = lst{indx};
end

%% Do image analysis
prop_pix=NaN(imNum,250);
for i = 1:imNum
    
    I = imread([path_image filesep filename{i}]);
    
    
%     if 0
%         isfolder([path_roisave filesep filename{i}(1:length(filename{i})-4)]);
%         I_roi=imread([path_roisave filesep filename{i}(1:length(filename{i})-4) filesep 'ROI.jpg']);
%     else
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
            title('Choose ROI points.')
            
            % Interactively find ROI
            h = impoly;
            wait(h);
            
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
   %% end %THIS MIGHT NOT BE THE RIGHT END TO COMMENT OUT
    
    
    %% Adjust white balance
    if isfile([path_roisave filesep filename{i}(1:length(filename{i})-4) filesep 'WhiteAdjusted.jpg'])
        I_roi_whiteadjusted=imread([path_roisave filesep filename{i}(1:length(filename{i})-4) filesep 'WhiteAdjusted.jpg']);
    else
         %Give instructions to person finding the white plastic
            bName = questdlg('On the following figure, click the four points that correspond to a square of white plastic. Once the four points have been chosen, double click the first point to complete the square.','Instructions','Start','Start');
            
            wtadjfig=figure;
            imshow(I)
            title('Choose white plastic.')
            
            % Interactively find white plastic
            h = impoly;
            wait(h);
            
            % Store white plastic points
            tmp = getPosition(h);
            wtadj.x = tmp(:,1);
            wtadj.y = tmp(:,2);
            
            % Show white plastic points
            delete(h)
            hold on
            plot(wtadj.x,wtadj.y,'r-')
            pause(1)
            hold off
            
            x=[round(min(wtadj.x)),round(max(wtadj.x))];
            y=[round(min(wtadj.y)),round(max(wtadj.y))];
            
            I_whitecontrol=I(y(1):y(2),x(1):x(2),:);
            whitecontrolmean=mean(mean(I_whitecontrol));
            
            for ch=1:3
                I_roi_whiteadjusted(:,:,ch)=I_roi(:,:,ch) - (whitecontrolmean(ch)/3);
            end
            
            wtadjshowfig=figure;
            imshow(I_roi_whiteadjusted)
            
            imwrite(I_roi_whiteadjusted,[path_roisave filesep filename{i}(1:length(filename{i})-4) filesep 'WhiteAdjusted.jpg']);
            
        clear tmp
        close wtadjfig
        close wtadjshowfig
        clear wtadjshowfig
        clear wtadjfig
    end    
    
    %% Plot each channel separately
    figure
    subplot(2,1,1)
    imshow(I_roi_whiteadjusted)
    title('Color image')
    subplot(2,3,4)
    imshow(I_roi_whiteadjusted(:,:,1))
    title('R channel only')
    subplot(2,3,5)
    imshow(I_roi_whiteadjusted(:,:,2))
    title('G channel only')
    subplot(2,3,6)
    imshow(I_roi_whiteadjusted(:,:,3))
    title('B chanel only')
    
    %% G Channel Mask
    
    g_roi = I_roi_whiteadjusted(:,:,2);
    gsize=size(g_roi);
    totpix=gsize(1)*gsize(2);
    thresh=1:250;
    
    for j=thresh
        prop_pix(i,j)=(length(find(g_roi<thresh(j))))/totpix;
    end
    
    clear I_roi_whiteadjusted
    
end

colorpattern=linspace(0,1,imNum);

figure
for k=1:imNum
    hold on
    color=[0 colorpattern(k) colorpattern(k)];
    plot(thresh,prop_pix(k,:),'Color',color)
end
xlabel('Mask Threshold')
ylabel('Number of pixels')
title('Green channel mask')
legend(filename)

end