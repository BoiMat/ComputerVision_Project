function [imageData, reprError] = compute_reprojectionError(imageData, symbol, radial_dist, k, K, plot)
    reprError = [];
    n = length(imageData(1).XYmm);
    for ii=1:length(imageData)
    
        P = imageData(ii).P;
        m = [imageData(ii).XYmm(:,1)'; imageData(ii).XYmm(:,2)'; zeros(1,n); ones(1,n)];
        imagePoints = imageData(ii).XYpixel';
    
        projectedPoints = P * m;
        projectedPoints = [projectedPoints(1,:)./projectedPoints(3,:); projectedPoints(2,:)./projectedPoints(3,:)];
        
        if radial_dist == true
            u = projectedPoints(1,:);
            v = projectedPoints(2,:);
            u0 = K(1,3);
            v0 = K(2,3);
            alpha_u = K(1,1);
            alpha_v = K(2,2)*sin(acot(K(1,2)/alpha_u));

            rd_sqr = ((u-u0)/alpha_u).^2 + ((v-v0)/alpha_v).^2;
            u_hat = (u - u0).*(1 + k(1)*rd_sqr + k(2)*rd_sqr.^2) + u0;
            v_hat = (v - v0).*(1 + k(1)*rd_sqr + k(2)*rd_sqr.^2) + v0;

            term1 = u_hat - imagePoints(1,:);
            term2 = v_hat - imagePoints(2,:);

        else
            term1 = projectedPoints(1,:) - imagePoints(1,:);
            term2 = projectedPoints(2,:) - imagePoints(2,:);
        end

        e_ii = sum(term1.^2 + term2.^2);

        reprError = [reprError; e_ii]; %#ok
        
        if ii == 1 && plot == true
            figure
            imshow(imageData(ii).I);
            hold on
    
            scatter(imagePoints(1,:), imagePoints(2,:), symbol, 'r');
            scatter(projectedPoints(1,:), projectedPoints(2,:), symbol, 'b');
        end
    
    end
    
    
    if radial_dist == true
        for ii=1:length(imageData)
            imageData(ii).reprErr_RD = reprError(ii);
        end
    else
        for ii=1:length(imageData)
            imageData(ii).reprErr = reprError(ii);
        end
    end
end