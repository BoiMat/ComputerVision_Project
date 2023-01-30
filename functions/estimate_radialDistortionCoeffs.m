function k = estimate_radialDistortionCoeffs(imageData, K, n)
    A = [];
    b = [];
    for kk = 1:length(imageData)
    
        uv = imageData(kk).P * [imageData(kk).XYmm(:,1)'; imageData(kk).XYmm(:,2)'; zeros(1,n); ones(1,n)];
        u = uv(1,:)./uv(3,:);
        v = uv(2,:)./uv(3,:);
        
        u_hat = imageData(kk).XYpixel(:,1)'; 
        v_hat = imageData(kk).XYpixel(:,2)';
        
        u0 = K(1,3);
        v0 = K(2,3);
        alpha_u = K(1,1);
        alpha_v = K(2,2)*sin(acot(K(1,2)/alpha_u));
        
        x = (u - u0)/alpha_u;
        y = (v - v0)/alpha_v;
    
        rd_sqr = x.^2 + y.^2;
    
        for ii = 1:n
            A_i = [(u(ii) - u0)*rd_sqr(ii), (u(ii) - u0)*rd_sqr(ii)^2;
                   (v(ii) - v0)*rd_sqr(ii), (v(ii) - v0)*rd_sqr(ii)^2];
            b_i = [u_hat(ii) - u(ii); v_hat(ii) - v(ii)];
        
            A = [A; A_i]; %#ok
            b = [b; b_i]; %#ok
        end
    
    end
    
    k = (A'*A)^-1*A'*b;
end