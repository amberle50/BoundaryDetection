set(0,'DefaultFigureWindowStyle','docked')

path_standards = 'G:\My Drive\Maddy_Boundary_Detection\Color Standards';
path_save = 'G:\My Drive\Maddy_Boundary_Detection\Color Standards\Color Standards Analyzed';
files=dir(path_standards);
histfig=figure;

for i = 4:length(files)
    I=imread([path_standards filesep files(i).name]);
    
    if i ~= 4
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
    
    %Open ROI choice figure
    roifig=figure;
    imshow(I)
    title(['Original Image'])
    
    %Give instructions to person finding the ROI
    bName = questdlg('Click the four points that correspond to the square of sediment. Include as little of the white tank within the square as possible. Once the four points have been chosen, double click the first point to complete the square.','Instructions','Start','Start');
        
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
    
    %Show ROI
    I_roi=I(y(1):y(2),x(1):x(2),:);
    roishowfig=figure;
    imshow(I_roi)
    
    close(roishowfig)
    

    
    %Find the proportion of mud and luminiphores
    temp=figure;
    imshow(I)
    prompt1 = 'How many mls of mud is in this sample?';
    prompt2 = 'How many mls of luminiphores are in this sample?';
    mud = inputdlg(prompt1)
    luminiphores = inputdlg(prompt2)
    proportion = (str2num(luminiphores{1})+str2num(mud{1}))/str2num(mud{1}); %this is the proportion of luminiphores to mud

    close(temp)
    
    %Find average and range of values in each channel
    meanI=mean(mean(I_roi));
    minI=min(min(I_roi));
    maxI=max(max(I_roi));
    
    figure(histfig)
    [yh,yx]=imhist(I_roi(:,:,1));
    [ys,yx]=imhist(I_roi(:,:,2));
    [yv,yx]=imhist(I_roi(:,:,3));
    
    plot(yx,yh,'Red',yx,ys,'Green',yx,yv,'Blue')
    xlim([4,250])
    
    
    save([path_save filesep num2str(proportion) '.mat'])
end

props = [1, 1.05, 1.1, 1.15, 1.2, 1.25, 1.3, 1.35, 1.4, 1.45, 1.5, 1.55, 1.6, 1.65, 1.7, 1.75, 1.8, 1.85, 1.9, 2.15];

ColNum = length(props); %for a framerate of 30fps

c1 = [1 0 0]; %rgb value for the starting color
c2 = [0 0 1]; %rgb value for the ending color

cr=(c2(1)-c1(1))/(ColNum-1);
cg=(c2(2)-c1(2))/(ColNum-1);
cb=(c2(3)-c1(3))/(ColNum-1);

%Initializes matrices.
gradient=zeros(ColNum,3);
r=zeros(10,ColNum);
g=zeros(10,ColNum);
b=zeros(10,ColNum);
%for each color step, increase/reduce the value of Intensity data.
for j=1:ColNum
    gradient(j,1)=c1(1)+cr*(j-1);
    gradient(j,2)=c1(2)+cg*(j-1);
    gradient(j,3)=c1(3)+cb*(j-1);
    r(:,j)=gradient(j,1);
    g(:,j)=gradient(j,2);
    b(:,j)=gradient(j,3);
end

%merge R G B matrix and obtain our image.
imColGradient=cat(3,r,g,b);


reds = figure;
greens = figure;
blues = figure;
for i=1:length(props)
    load([path_save filesep num2str(props(i)) '.mat'],'yx','yh','ys','yv')
    leg{i}=num2str(props(i));
    
    figure(reds)
    hold on
    plot(yx,yh,'Color',gradient(i,:))
    xlim([4,250])
    
    figure(greens)
    hold on
    plot(yx,ys,'Color',gradient(i,:))
    xlim([4,250])
    
    figure(blues)
    hold on
    plot(yx,yv,'Color',gradient(i,:))
    xlim([4,250])
end

figure(reds)
title('Red Channel: (Luminiphores + Mud)/Mud')
legend(leg)
axis square

figure(greens)
title('Green Channel: (Luminiphores + Mud)/Mud')
legend(leg)
axis square

figure(blues)
title('Blue Channel: (Luminiphores + Mud)/Mud')
legend(leg)
axis square

