function imageData = compute_Homographies(imageData, radial_dist)
    for ii=1:length(imageData)
        
        if (radial_dist == true)
            XYpixel = imageData(ii).newXYpixel;
        else
            XYpixel = imageData(ii).XYpixel;
        end
        
        XYmm=imageData(ii).XYmm;
        A=[];
        b=[];
        for jj=1:length(XYpixel)
    
            Xpixel=XYpixel(jj,1);
            Ypixel=XYpixel(jj,2);
            Xmm=XYmm(jj,1);
            Ymm=XYmm(jj,2);
    
            m=[Xmm; Ymm; 1];
            O=[0;0;0];
    
            A=[A; m' O' -Xpixel*m' ; O' m' -Ypixel*m']; %#ok
            b=[b;0;0]; %#ok
    
        end
        
        [~,~,V]=svd(A);
        h=V(:,end);
    
        imageData(ii).H = reshape(h,[3 3])';
    end
end