function imageData = compute_ExtrinsicParams(imageData, K)
    for ii=1:length(imageData)
        H = imageData(ii).H./imageData(ii).H(3,3);

        h1 = H(:,1);
        h2 = H(:,2);
        h3 = H(:,3);

        Kinv = K^-1;
  
        lambda = 1 / norm( Kinv*h1 );

        r1 = lambda * Kinv * h1;
        r2 = lambda * Kinv * h2;
        r3 = cross( r1, r2 );
        
        t = lambda * Kinv * h3;
        R = [ r1 r2 r3 ];
        
        [U,~,V] = svd(R);
        R_prime = U*V';
    
        imageData(ii).R = R_prime;
        imageData(ii).t = t;
        imageData(ii).P = K*[R_prime t];
    end
end