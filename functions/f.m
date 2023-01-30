function residuals = f(x_hat, y_hat, x, y, k1, k2)
    res1 = x.*(1 + k1*(x.^2 + y.^2) + k2*(x.^4 + 2*x.^2.*y.^2 + y.^4)) - x_hat;
    res2 = y.*(1 + k1*(x.^2 + y.^2) + k2*(x.^4 + 2*x.^2.*y.^2 + y.^4)) - y_hat;

    residuals = [res1; res2];
end