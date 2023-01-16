function layered_image_processing

%% Setup logistics

set(0,'DefaultFigureWindowStyle','docked')
%path_image='G:\My Drive\Maddy_Boundary_Detection\Raw_Photos';
path_image='G:\My Drive\Maddy_Boundary_Detection\New Photos';
path_save='G:\My Drive\Maddy_Boundary_Detection\New Photos\Estimated_Proportions';

%Step through each new image
list=dir(path_image);
isdir={list.isdir};
filename={list.name};
for i =1:length(list)
    if isdir{i} == 0
        %load in image
        I = imread([path_image filesep filename{i}]);
        
        %% Calibration
        %Select bottom of tank
        calfig=figure;
        imshow(I)
        title('Select bottom of tank.')
        
        % Interactively find cal
        h = impoly;
        roi_poly = wait(h);
        
        % Store cal points
        tmp = getPosition(h);
        cl.x = tmp(:,1);
        cl.y = tmp(:,2);
        
        % Show cal points
        delete(h)
        hold on
        plot(cl.x,cl.y,'r-')
        pause(1)
        hold off
        
        x=[round(min(cl.x)),round(max(cl.x))];
        y=[round(min(cl.y)),round(max(cl.y))];
        
        p1 = [x(1); y(1)];
        p2 = [x(2); y(2)];
        d = norm(p1 - p2);% This is the distance between the two end points on the bottom of the tank
        
        %Calibration: in/pix
        cal=5.25/d;
        
        close(calfig)
        clear calfig
        
        %% ROI 
        %Select mud in tank
        roifig=figure;
        imshow(I)
        title('Select mud in tank for ROI.')
        
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
        
        %Here is the ROI image
        I_roi=I(y(1):y(2),x(1):x(2),:);
        roishowfig=figure;
        imshow(I_roi)
        
        %% Segment ROI image into 8 layers
        size_roi=size(I_roi);
        size_layer=size_roi(1)/8;
        L1=I_roi(1:size_layer,:,:);
        L2=I_roi(size_layer+1:size_layer*2,:,:);
        L3=I_roi((size_layer*2)+1:size_layer*3,:,:);
        L4=I_roi((size_layer*3)+1:size_layer*4,:,:);
        L5=I_roi((size_layer*4)+1:size_layer*5,:,:);
        L6=I_roi((size_layer*5)+1:size_layer*6,:,:);
        L7=I_roi((size_layer*6)+1:size_layer*7,:,:);
        L8=I_roi((size_layer*7)+1:size_layer*8,:,:);
        
        %Verify all the slices are correct
        layeredfig=figure;
        subplot(8,1,1)
        imshow(L1)
        subplot(8,1,2)
        imshow(L2)
        subplot(8,1,3)
        imshow(L3)
        subplot(8,1,4)
        imshow(L4)
        subplot(8,1,5)
        imshow(L5)
        subplot(8,1,6)
        imshow(L6)
        subplot(8,1,7)
        imshow(L7)
        subplot(8,1,8)
        imshow(L8)
        
        %% Show histograms for each layer
        tothistfig=figure;
        
        %Layer 1
        subplot(8,1,1)
        [yr,~]=imhist(L1(:,:,1));
        [yg,~]=imhist(L1(:,:,2));
        [yb,yx]=imhist(L1(:,:,3));
        L1r=area(yx,yr,'FaceColor','Red','EdgeColor','Red');
        hold on
        L1g=area(yx,yg,'FaceColor','Green','EdgeColor','Green');
        L1b=area(yx,yb,'FaceColor','Blue','EdgeColor','Blue');
        
        %Layer 2
        subplot(8,1,2)
        [yr,~]=imhist(L2(:,:,1));
        [yg,~]=imhist(L2(:,:,2));
        [yb,yx]=imhist(L2(:,:,3));
        L2r=area(yx,yr,'FaceColor','Red','EdgeColor','Red');
        hold on
        L2g=area(yx,yg,'FaceColor','Green','EdgeColor','Green');
        L2b=area(yx,yb,'FaceColor','Blue','EdgeColor','Blue');
        
        %Layer 3
        subplot(8,1,3)
        [yr,~]=imhist(L3(:,:,1));
        [yg,~]=imhist(L3(:,:,2));
        [yb,yx]=imhist(L3(:,:,3));
        L3r=area(yx,yr,'FaceColor','Red','EdgeColor','Red');
        hold on
        L3g=area(yx,yg,'FaceColor','Green','EdgeColor','Green');
        L3b=area(yx,yb,'FaceColor','Blue','EdgeColor','Blue');
        
        %Layer 4
        subplot(8,1,4)
        [yr,~]=imhist(L4(:,:,1));
        [yg,~]=imhist(L4(:,:,2));
        [yb,yx]=imhist(L4(:,:,3));
        L4r=area(yx,yr,'FaceColor','Red','EdgeColor','Red');
        hold on
        L4g=area(yx,yg,'FaceColor','Green','EdgeColor','Green');
        L4b=area(yx,yb,'FaceColor','Blue','EdgeColor','Blue');
        
        %Layer 5
        subplot(8,1,5)
        [yr,~]=imhist(L5(:,:,1));
        [yg,yx]=imhist(L5(:,:,2));
        [yb,yx]=imhist(L5(:,:,3));
        L5r=area(yx,yr,'FaceColor','Red','EdgeColor','Red');
        hold on
        L5g=area(yx,yg,'FaceColor','Green','EdgeColor','Green');
        L5b=area(yx,yb,'FaceColor','Blue','EdgeColor','Blue');
        
        %Layer 6
        subplot(8,1,6)
        [yr,~]=imhist(L6(:,:,1));
        [yg,~]=imhist(L6(:,:,2));
        [yb,yx]=imhist(L6(:,:,3));
        L6r=area(yx,yr,'FaceColor','Red','EdgeColor','Red');
        hold on
        L6g=area(yx,yg,'FaceColor','Green','EdgeColor','Green');
        L6b=area(yx,yb,'FaceColor','Blue','EdgeColor','Blue');
        
        %Layer 7
        subplot(8,1,7)
        [yr,~]=imhist(L7(:,:,1));
        [yg,~]=imhist(L7(:,:,2));
        [yb,yx]=imhist(L7(:,:,3));
        L7r=area(yx,yr,'FaceColor','Red','EdgeColor','Red');
        hold on
        L7g=area(yx,yg,'FaceColor','Green','EdgeColor','Green');
        L7b=area(yx,yb,'FaceColor','Blue','EdgeColor','Blue');
        
        %Layer 8
        subplot(8,1,8)
        [yr,~]=imhist(L8(:,:,1));
        [yg,~]=imhist(L8(:,:,2));
        [yb,yx]=imhist(L8(:,:,3));
        L8r=area(yx,yr,'FaceColor','Red','EdgeColor','Red');
        hold on
        L8g=area(yx,yg,'FaceColor','Green','EdgeColor','Green');
        L8b=area(yx,yb,'FaceColor','Blue','EdgeColor','Blue');
        
        %% Compare each layer to standard images
        [prop.L1]=proportion_estimation(L1);
        [prop.L2]=proportion_estimation(L2);
        [prop.L3]=proportion_estimation(L3);
        [prop.L4]=proportion_estimation(L4);
        [prop.L5]=proportion_estimation(L5);
        [prop.L6]=proportion_estimation(L6);
        [prop.L7]=proportion_estimation(L7);
        [prop.L8]=proportion_estimation(L8);
        
        %% Save
        %Save ROI image
         mkdir([path_save filesep filename{i}(1:length(filename{i})-4)]);
        imwrite(I_roi,[path_save filesep filename{i}(1:length(filename{i})-4) filesep 'ROI.JPG'])
        imwrite(L1,[path_save filesep filename{i}(1:length(filename{i})-4) filesep 'L1.JPG'])
        imwrite(L2,[path_save filesep filename{i}(1:length(filename{i})-4) filesep 'L2.JPG'])
        imwrite(L3,[path_save filesep filename{i}(1:length(filename{i})-4) filesep 'L3.JPG'])
        imwrite(L4,[path_save filesep filename{i}(1:length(filename{i})-4) filesep 'L4.JPG'])
        imwrite(L5,[path_save filesep filename{i}(1:length(filename{i})-4) filesep 'L5.JPG'])
        imwrite(L6,[path_save filesep filename{i}(1:length(filename{i})-4) filesep 'L6.JPG'])
        imwrite(L7,[path_save filesep filename{i}(1:length(filename{i})-4) filesep 'L7.JPG'])
        imwrite(L8,[path_save filesep filename{i}(1:length(filename{i})-4) filesep 'L8.JPG'])
        save([path_save filesep filename{i}(1:length(filename{i})-4) filesep 'Calibration.mat'], 'cal')
        save([path_save filesep filename{i}(1:length(filename{i})-4) filesep 'Proportion_estimates.mat'], 'prop')
        
    end
    close all
    
end

