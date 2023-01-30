function imageData = compute_realworldPoints(imageData, boardsize, squaresize)
    for ii=1:length(imageData)
        XYpixel = imageData(ii).XYpixel;
        clear Xmm Ymm
   
        for jj=1:length(XYpixel)
            [row, col] = ind2sub(boardsize-1, jj);
             
            Xmm = (col-1) * squaresize;
            Ymm = (row-1) * squaresize;
            
            imageData(ii).XYmm(jj, :) = [ Xmm Ymm ];
        end
    end
end