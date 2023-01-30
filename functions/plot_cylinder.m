function plot_cylinder(imageData, npoints, radius, height, center)
    
    n = npoints;
    R = radius;
    x0 = center(1);
    y0 = center(2);
    
    it = linspace(1,n,n);
    X = cos(2*pi/n*it)*R + x0;
    Y = sin(2*pi/n*it)*R + y0;
    
    center = [x0; y0; 0; 1];
    coords_low = [X; Y; zeros(1,n); ones(1,length(X))];
    coords_high = [X; Y; -ones(1,n)*height; ones(1,length(X))];

    for ii=1:length(imageData)
        figure
        imshow(imageData(ii).I, 'InitialMagnification', 200);
        hold on
        
        
        proj_hom_low = imageData(ii).P*coords_low;
        proj_hom_high = imageData(ii).P*coords_high;
        proj_center = imageData(ii).P*center;
        proj_center = [proj_center(1)/proj_center(3); proj_center(2)/proj_center(3)];
        
        proj_low = [proj_hom_low(1, :)./proj_hom_low(3, :); proj_hom_low(2, :)./proj_hom_low(3, :)];
        proj_high = [proj_hom_high(1, :)./proj_hom_high(3, :); proj_hom_high(2, :)./proj_hom_high(3, :)];
        
        plot(proj_low(1, :), proj_low(2, :), 'r', 'LineWidth', 2);
        plot(proj_high(1, :), proj_high(2, :), 'r', 'LineWidth', 2);
        plot([proj_low(1,1) proj_high(1,1)], [proj_low(2,1) proj_high(2,1)], 'g', 'LineWidth', 2)
        plot([proj_low(1,n/2) proj_high(1,n/2)], [proj_low(2,n/2) proj_high(2,n/2)], 'g', 'LineWidth', 2)
        plot([proj_low(1,n/4) proj_high(1,n/4)], [proj_low(2,n/4) proj_high(2,n/4)], 'g', 'LineWidth', 2)
        plot([proj_low(1,n/4*3) proj_high(1,n/4*3)], [proj_low(2,n/4*3) proj_high(2,n/4*3)], 'g', 'LineWidth', 2)
        plot(proj_center(1), proj_center(2), 'or')
    end
end