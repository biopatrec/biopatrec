function ok = plotThresshold(img,thresshold)
%08.08.2006, Bjarni Bodvarsson (bb@imm.dtu.dk)
[x y slice frame] = size(img);
meanImg = mean(img,4);
rowsColumns = ceil(sqrt(slice));
addImages = rowsColumns^2-slice;
%imgTmp = zeros(x*rowsColumns,y*rowsColumns);
imgTmp = zeros(x*rowsColumns,y*rowsColumns);

n=1;
clim = [min(meanImg(:)) max(meanImg(:))];
indx = find(meanImg < thresshold(1) | meanImg > thresshold(2));
meanImg(indx) = 0;

for j=1:rowsColumns
    for i=1:rowsColumns
        if n>slice;
            imgTmp((j*y-y+1):j*y,(i*x-x+1):i*x) = zeros(y,x); 
        else
            imgTmp((j*y-y+1):j*y,(i*x-x+1):i*x) = rot90(meanImg(:,:,n));
        end
        n = n+1;
    end
end
imagesc(imgTmp), axis equal, ylim([0 rowsColumns*y]), xlim([0 rowsColumns*x]);