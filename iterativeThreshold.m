function threshold = iterativeThreshold(image)
    % Step 1: 选择一个初始估计阈值 T1
    T1 = mean(image(:));
    % 预设值 &xi;
    epsilon = 0.01;
    
    while true
        % Step 2: 用 T1 把给定图像分割
        G1 = image(image > T1);
        G2 = image(image <= T1);
        
        % Step 3: 对区域 G1 和 G2 中的所有像素计算平均灰度值 &mu;1 和 &mu;2
        mu1 = mean(G1(:));
        mu2 = mean(G2(:));
        
        % Step 4: 选择一个新阈值 T2，更新 T2
        T2 = (mu1 + mu2) / 2;
        
        % Step 5: 重复进行 Step 2～Step 4，直至 |T2 - T1| > &xi;
        if abs(T2 - T1) <= epsilon
            break;
        end
        
        % 更新 T1
        T1 = T2;
    end
    
    % 输出 T2 作为最终阈值
    threshold = T2;
end