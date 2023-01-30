function [imageData, k_convCheck_tot, P_convCheck_tot] = compensate_radialDistortion(imageData, K, maxIter, tol)

    n = length(imageData(1).XYmm);
    N = length(imageData);

    old_k = [0; 0];
    old_P = [];
    for kk = 1:N
        old_P = [old_P; imageData(kk).P]; %#ok
    end
    
    k_convCheck_tot = [];
    P_convCheck_tot = [];
    for jj = 1:maxIter
       
        k = estimate_radialDistortionCoeffs(imageData, K, n);
        k_convCheck = norm(k - old_k);
        k_convCheck_tot = [k_convCheck_tot; k_convCheck]; %#ok
        old_k = k;
        
        for kk = 1:N
        
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
            x_hat = (u_hat - u0)/alpha_u;
            y_hat = (v_hat - v0)/alpha_v;
      
            %Newthon's method      
            newxy = NewtonsMethod(x_hat, y_hat, x, y, k, tol, maxIter);
            u = newxy(1,:)*alpha_u + u0;
            v = newxy(2,:)*alpha_v + v0;
                  
            imageData(kk).newXYpixel = [u', v'];
        end
        
        imageData = compute_Homographies(imageData, true);
        K = compute_IntrinsicParams(imageData);
        imageData = compute_ExtrinsicParams(imageData, K);
    
        new_P = [];
        for kk = 1:N
            new_P = [new_P; imageData(kk).P]; %#ok
        end
        P_convCheck = norm(new_P - old_P);
        old_P = new_P;
        P_convCheck_tot = [P_convCheck_tot; P_convCheck]; %#ok
    
        if P_convCheck < tol || k_convCheck < tol
            break
        end
    end
end