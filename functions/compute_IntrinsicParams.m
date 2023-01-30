function K = compute_IntrinsicParams(imageData)
    V = [];
    for ii = 1:length(imageData)
        v12 = calculate_vij(1,2, imageData(ii).H);
        v11 = calculate_vij(1,1, imageData(ii).H);
        v22 = calculate_vij(2,2, imageData(ii).H);
        
        V = [V; v12'; (v11 - v22)']; %#ok
    end
    
    [~,~,S]=svd(V);
    b = S(:,end);
    b = b./b(6);
    B = [b(1) b(2) b(4); b(2) b(3) b(5); b(4) b(5) b(6)];
    
    L=chol(B, "lower");
    K = (L')^(-1);
    K = K/K(3,3);
end