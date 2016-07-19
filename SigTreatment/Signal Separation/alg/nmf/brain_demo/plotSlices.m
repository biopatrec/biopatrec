function ok = plotSlices(W,indx,dim)
%08.08.2006, Bjarni Bodvarsson (bb@imm.dtu.dk)
%dim = [x y slice frame];
x = dim(1);
y = dim(2);
slice = dim(3);
frame = dim(4);

rowsColumns = ceil(sqrt(slice));
imgTmp = zeros(y*rowsColumns,x*rowsColumns);

for source=1:size(W,2)
    n=1;
    sourceImg = zeros(x,y,slice);
    sourceImg(indx) = W(:,source);

    for j=1:rowsColumns
        for i=1:rowsColumns
            if n>slice;
                imgTmp((j*y-y+1):j*y,(i*x-x+1):i*x) = zeros(y,x);
            else
                imgTmp((j*y-y+1):j*y,(i*x-x+1):i*x) = rot90(sourceImg(:,:,n));
            end
            n = n+1;
        end
    end
figure,
imagesc(imgTmp), axis equal, ylim([0 rowsColumns*y]), xlim([0 rowsColumns*x]);
title(['Spatial image of sources number ' num2str(source)])
end