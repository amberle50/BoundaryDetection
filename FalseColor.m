function [falsecolor]=FalseColor(Original,TurquoiseLayer, BlueLayer, PurpleLayer, PinkLayer) 
E=Original;

falsecolor=figure;
subplot(1,2,1)
imshow(E, 'InitialMag', 'fit') 

subplot(1,2,2)
black = cat(3, zeros(size(E(:,:,1))), zeros(size(E(:,:,2))), zeros(size(E(:,:,3))));
imshow(black)
 
green = cat(3, zeros(size(E(:,:,1))), ones(size(E(:,:,2))), zeros(size(E(:,:,3))));
hold on 
h = imshow(green); 
hold off 
set(h, 'AlphaData', TurquoiseLayer) 

blue = cat(3, zeros(size(E(:,:,1))), zeros(size(E(:,:,2))), ones(size(E(:,:,3))));
hold on 
h = imshow(blue); 
hold off 
set(h, 'AlphaData', BlueLayer)

purple = cat(3, ones(size(E(:,:,1))), ones(size(E(:,:,2))), ones(size(E(:,:,3))));
purple(:,:,1) = purple(:,:,1) * 0.49; 
purple(:,:,2) = purple(:,:,2) * 0.18;
purple(:,:,3) = purple(:,:,3) * 0.55;
hold on 
h = imshow(purple); 
hold off 
set(h, 'AlphaData', PurpleLayer)

pink = cat(3, ones(size(E(:,:,1))), ones(size(E(:,:,2))), ones(size(E(:,:,3))));
pink(:,:,2) = pink(:,:,2) * 0.5;
pink(:,:,3) = pink(:,:,3) * 0.8;
hold on 
h = imshow(pink); 
hold off 
set(h, 'AlphaData', PinkLayer)
end