%Interpret the proportion estimation for the layered images

path_load='G:\My Drive\Maddy_Boundary_Detection\New Photos\Estimated_Proportions';

%Figure out which images to look at
prompt = 'How many images are in this sequence?';
input = inputdlg(prompt)
imNum = str2num(input{1});

filename = {};
for i = 1:imNum
    list=dir(path_load);
    lst={list.name};
    [indx,tf] = listdlg('PromptString',{['Select image number ' num2str(i)], ' in the image sequence.'},'ListSTring',lst,'SelectionMode','single')
    flnm=lst{indx};
    
     filename{i} = flnm;
end


%Step through each experiment
estimatefig=figure;
for i =1:length(filename)

        
        load([path_load filesep filename{i} filesep 'Proportion_estimates.mat'])
        I=imread([path_load filesep filename{i} filesep 'ROI.jpg']);
        
        transp=linspace(0.5,1,length(filename));
        
        %% Restructure variables
        
        estimate.layer=NaN(8,1);
        estimate.r=NaN(8,1);
        estimate.g=NaN(8,1);
        estimate.b=NaN(8,1);
        
        estimate.layer(1:8)=1:8;
        estimate.layer=estimate.layer';
        
        estimate.r(1)=prop.L1.r;
        estimate.r(2)=prop.L2.r;
        estimate.r(3)=prop.L3.r;
        estimate.r(4)=prop.L4.r;
        estimate.r(5)=prop.L5.r;
        estimate.r(6)=prop.L6.r;
        estimate.r(7)=prop.L7.r;
        estimate.r(8)=prop.L8.r;
        
        estimate.g(1)=prop.L1.g;
        estimate.g(2)=prop.L2.g;
        estimate.g(3)=prop.L3.g;
        estimate.g(4)=prop.L4.g;
        estimate.g(5)=prop.L5.g;
        estimate.g(6)=prop.L6.g;
        estimate.g(7)=prop.L7.g;
        estimate.g(8)=prop.L8.g;
        
        estimate.b(1)=prop.L1.b;
        estimate.b(2)=prop.L2.b;
        estimate.b(3)=prop.L3.b;
        estimate.b(4)=prop.L4.b;
        estimate.b(5)=prop.L5.b;
        estimate.b(6)=prop.L6.b;
        estimate.b(7)=prop.L7.b;
        estimate.b(8)=prop.L8.b;
        
        %% Plot estimates for each layer
        figure(estimatefig)
        
%         subplot(1,4,2)
%         hold on
%         set(gca, 'YDir','reverse')
%         r(i)=scatter(estimate.r,estimate.layer,100,'Red','square','filled')
%         ylabel('Layers of the mud')
%         xlabel(['Proportion of luminiphores to mud' newline 'estimated by each color channel'])
%         xlim([1,2.15])
%         title('Red channel estimates')
%         %axis square
        
        subplot(1,3,2)
        hold on
        set(gca, 'YDir','reverse')
        g(i)=scatter(estimate.g,estimate.layer,100,'Green','square','filled')
        ylabel('Layers of the mud')
        xlabel(['Proportion of luminiphores to mud' newline 'estimated by each color channel'])
        xlim([1,2.15])
        title('Green channel estimates')
        %axis square
        
        subplot(1,3,3)
        hold on
        set(gca, 'YDir','reverse')
        b(i)=scatter(estimate.b,estimate.layer,100,'Blue','square','filled')
%         alpha(r(i),transp(i))
        alpha(g(i),transp(i))
        alpha(b(i),transp(i))
        ylabel('Layers of the mud')
        xlabel(['Proportion of luminiphores to mud' newline 'estimated by each color channel'])
        xlim([1,2.15])
        title('Blue channel estimates')
        %axis square
        
%         title(filename(i));
   

end
        
        
        subplot(2,3,4)
        imshow(I)
        title('Last frame')
        
        I=imread([path_load filesep filename{1} filesep 'ROI.jpg']);
        subplot(2,3,1)
        imshow(I)
        title('First frame')