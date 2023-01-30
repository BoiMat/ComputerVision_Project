function newxy = NewtonsMethod(x_hat, y_hat, x, y, k, tol, maxIter)
    
    for ll = 1:maxIter            
        res = f(x_hat, y_hat, x, y, k(1), k(2));
        
        delta = [];
        for ii = 1:length(x)
            J = compute_jacobian(x(ii), y(ii), k(1), k(2));
            delta_i = -J^-1 * res(:,ii);
            delta = [delta, delta_i]; %#ok
        end
    
        x = x + delta(1,:);
        y = y + delta(2,:);
    
        if (norm(delta) < tol)
            break
        end
    end
    newxy = [x; y];

end