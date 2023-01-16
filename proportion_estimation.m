function [prop]=proportion_estimation(input_image)

standards_path = 'G:\My Drive\Maddy_Boundary_Detection\Color Standards\Color Standards Analyzed';


%Load in the standards table
load('G:\My Drive\Maddy_Boundary_Detection\Color Standards\Color Standards Analyzed\standard_table.mat')

rmean=mean(mean(input_image(:,:,1)));
gmean=mean(mean(input_image(:,:,2)));
bmean=mean(mean(input_image(:,:,3)));

rst = std(mean(input_image(:,:,1)));
gst = std(mean(input_image(:,:,2)));
bst = std(mean(input_image(:,:,3)));

[minValue, closestIndex] = min(abs(T.Red_Mean - rmean .'));
closest_mean.r = T.Red_Mean(closestIndex)
prop.r = T.Proportion(closestIndex);
clear closestIndex minValue

[minValue, closestIndex] = min(abs(T.Green_Mean - gmean .'));
closest_mean.g = T.Green_Mean(closestIndex)
prop.g = T.Proportion(closestIndex);
clear closestIndex minValue

[minValue, closestIndex] = min(abs(T.Blue_Mean - bmean .'));
closest_mean.b = T.Blue_Mean(closestIndex)
prop.b = T.Proportion(closestIndex);
clear closestIndex minValue

if isequal(prop.r,prop.b) && isequal(prop.r,prop.g)
    figure
    [yr,yx]=imhist(input_image(:,:,1));
    [yg,yx]=imhist(input_image(:,:,2));
    [yb,yx]=imhist(input_image(:,:,3));
    %         experimental=plot(yx,yr,'Red',yx,yg,'Green',yx,yb,'Blue');
    
    experimental_r=area(yx,yr,'FaceColor','Red','EdgeColor','Red');
    hold on
    experimental_g=area(yx,yg,'FaceColor','Green','EdgeColor','Green');
    experimental_b=area(yx,yb,'FaceColor','Blue','EdgeColor','Blue');
    alpha(experimental_r,0.5)
    alpha(experimental_g,0.5)
    alpha(experimental_b,0.5)
    xlim([4,250])
    
    clear yr yg yb yx
    
    load([standards_path filesep num2str(prop.g) '.mat'],'yh','yx','ys', 'yv')
    
    hold on
    %         predicted=plot(yx,yh,'Magenta',yx,ys,'Yellow',yx,yv,'Cyan');
    predicted_r=area(yx,yh,'FaceColor','Magenta','EdgeColor','Red');
    hold on
    predicted_g=area(yx,ys,'FaceColor','Yellow','EdgeColor','Green');
    predicted_b=area(yx,yv,'FaceColor','Cyan','EdgeColor','Blue');
    
    alpha(predicted_r,0.5)
    alpha(predicted_g,0.5)
    alpha(predicted_b,0.5)
    
    clear yh ys yv yx
    
    legend('Exp-Red','Exp-Green','Exp-Blue','Pred-Red','Pred-Green','Pred-Blue')
else
    warning('Different channels predict different proportions')
    disp([prop.r,prop.g,prop.b])
    
    %Red Channel Prediction
    figure
    subplot(3,1,1)
    [yr,yx]=imhist(input_image(:,:,1));
    [yg,yx]=imhist(input_image(:,:,2));
    [yb,yx]=imhist(input_image(:,:,3));
    %experimental=plot(yx,yr,'Red',yx,yg,'Green',yx,yb,'Blue');
    
    experimental_r=area(yx,yr,'FaceColor','Red','EdgeColor','Red');
    hold on
    experimental_g=area(yx,yg,'FaceColor','Green','EdgeColor','Green');
    experimental_b=area(yx,yb,'FaceColor','Blue','EdgeColor','Blue');
    alpha(experimental_r,0.5)
    alpha(experimental_g,0.5)
    alpha(experimental_b,0.5)
    xlim([4,250])
    
    clear yr yg yb yx
    
    load([standards_path filesep num2str(prop.r) '.mat'],'yh','yx','ys', 'yv')
    
    hold on
    
    %predicted=plot(yx,yh,'Magenta',yx,ys,'Yellow',yx,yv,'Cyan');
    predicted_r=area(yx,yh,'FaceColor','Magenta','EdgeColor','Red');
    hold on
    predicted_g=area(yx,ys,'FaceColor','Yellow','EdgeColor','Green');
    predicted_b=area(yx,yv,'FaceColor','Cyan','EdgeColor','Blue');
    
    alpha(predicted_r,0.5)
    alpha(predicted_g,0.5)
    alpha(predicted_b,0.5)
    
    clear yh ys yv yx
    
    legend('Exp-Red','Exp-Green','Exp-Blue','Pred-Red','Pred-Green','Pred-Blue')
    title(['Red Channel Predicts ' num2str(prop.r)])
    
    %Green Channel Prediction
    subplot(3,1,2)
    [yr,yx]=imhist(input_image(:,:,1));
    [yg,yx]=imhist(input_image(:,:,2));
    [yb,yx]=imhist(input_image(:,:,3));
    %experimental=plot(yx,yr,'Red',yx,yg,'Green',yx,yb,'Blue');
    
    experimental_r=area(yx,yr,'FaceColor','Red','EdgeColor','Red');
    hold on
    experimental_g=area(yx,yg,'FaceColor','Green','EdgeColor','Green');
    experimental_b=area(yx,yb,'FaceColor','Blue','EdgeColor','Blue');
    alpha(experimental_r,0.5)
    alpha(experimental_g,0.5)
    alpha(experimental_b,0.5)
    xlim([4,250])
    
    clear yr yg yb yx
    
    load([standards_path filesep num2str(prop.g) '.mat'],'yh','yx','ys', 'yv')
    
    hold on
    
    %predicted=plot(yx,yh,'Magenta',yx,ys,'Yellow',yx,yv,'Cyan');
    predicted_r=area(yx,yh,'FaceColor','Magenta','EdgeColor','Red');
    hold on
    predicted_g=area(yx,ys,'FaceColor','Yellow','EdgeColor','Green');
    predicted_b=area(yx,yv,'FaceColor','Cyan','EdgeColor','Blue');
    
    alpha(predicted_r,0.5)
    alpha(predicted_g,0.5)
    alpha(predicted_b,0.5)
    
    clear yh ys yv yx
    
    legend('Exp-Red','Exp-Green','Exp-Blue','Pred-Red','Pred-Green','Pred-Blue')
    title(['Green Channel Predicts ' num2str(prop.g)])
    
    %Blue Channel Prediction
    subplot(3,1,3)
    [yr,yx]=imhist(input_image(:,:,1));
    [yg,yx]=imhist(input_image(:,:,2));
    [yb,yx]=imhist(input_image(:,:,3));
    %experimental=plot(yx,yr,'Red',yx,yg,'Green',yx,yb,'Blue');
    
    experimental_r=area(yx,yr,'FaceColor','Red','EdgeColor','Red');
    hold on
    experimental_g=area(yx,yg,'FaceColor','Green','EdgeColor','Green');
    experimental_b=area(yx,yb,'FaceColor','Blue','EdgeColor','Blue');
    alpha(experimental_r,0.5)
    alpha(experimental_g,0.5)
    alpha(experimental_b,0.5)
    xlim([4,250])
    
    clear yr yg yb yx
    
    load([standards_path filesep num2str(prop.b) '.mat'],'yh','yx','ys', 'yv')
    
    hold on
    
    %predicted=plot(yx,yh,'Magenta',yx,ys,'Yellow',yx,yv,'Cyan');
    predicted_r=area(yx,yh,'FaceColor','Magenta','EdgeColor','Red');
    hold on
    predicted_g=area(yx,ys,'FaceColor','Yellow','EdgeColor','Green');
    predicted_b=area(yx,yv,'FaceColor','Cyan','EdgeColor','Blue');
    
    alpha(predicted_r,0.5)
    alpha(predicted_g,0.5)
    alpha(predicted_b,0.5)
    
    clear yh ys yv yx
    
    legend('Exp-Red','Exp-Green','Exp-Blue','Pred-Red','Pred-Green','Pred-Blue')
    title(['Blue Channel Predicts ' num2str(prop.b)])
end

end