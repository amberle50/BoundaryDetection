function standard_table
% Creates a table of standards with means and standard deviations
load_path = 'G:\My Drive\Maddy_Boundary_Detection\Color Standards\Color Standards Analyzed';

prop=[1 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 2.15];

T=table('Size',[length(prop) 7],'VariableTypes',["double","double","double","double","double","double","double"],'VariableNames',{'Proportion','Red_Mean','Green_Mean', 'Blue_Mean', 'Red_StDev', 'Green_StDev', 'Blue_StDev'});

for i=1:length(prop)
    load([load_path filesep num2str(prop(i)) '.mat'],'histfig','yh','yx','ys', 'yv', 'I_roi')
    title(prop(i))
 
    rmean=mean(mean(I_roi(:,:,1)));
    gmean=mean(mean(I_roi(:,:,2)));
    bmean=mean(mean(I_roi(:,:,3)));
    
    rst = std(mean(I_roi(:,:,1)));
    gst = std(mean(I_roi(:,:,2)));
    bst = std(mean(I_roi(:,:,3)));
    
    T(i,1)={prop(i)};
    T(i,2)={rmean};
    T(i,3)={gmean};
    T(i,4)={bmean};
    T(i,5)={rst};
    T(i,6)={gst};
    T(i,7)={bst};
    
    hold on 
    line([rmean,rmean],[0, max(max([yh,ys,yv]))],'Color','Red');
    line([gmean,gmean],[0, max(max([yh,ys,yv]))],'Color','Green');
    line([bmean,bmean],[0, max(max([yh,ys,yv]))],'Color','Blue');
    
end
save([load_path filesep 'standard_table.mat'],'T')
end
