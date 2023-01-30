function j = compute_jacobian(x, y, k1, k2)

    j = zeros(2,2);
               
    j(1,1) = x*(k2*(4*x^3 + 4*x*y^2) + 2*k1*x) + k1*(x^2 + y^2) + k2*(x^4 + 2*x^2*y^2 + y^4) + 1;        
    j(1,2) = x*(k2*(4*x^2*y + 4*y^3) + 2*k1*y);
    j(2,1) = y*(k2*(4*x^3 + 4*x*y^2) + 2*k1*x);
    j(2,2) = y*(k2*(4*x^2*y + 4*y^3) + 2*k1*y) + k1*(x^2 + y^2) + k2*(x^4 + 2*x^2*y^2 + y^4) + 1;

end