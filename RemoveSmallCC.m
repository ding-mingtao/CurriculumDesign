function binaryImage = RemoveSmallCC(binaryImage, minArea, connectivity)
    % 获取连通域标签
    CC = bwconncomp(binaryImage, connectivity);
    
    % 初始化标签矩阵
    labels = zeros(size(binaryImage));
    
    % 为每个连通域分配唯一的标签
    for idx = 1:CC.NumObjects
        idx_pixels = CC.PixelIdxList{idx};
        labels(idx_pixels) = idx;
    end
    
    % 去除小连通域
    for n = 1:max(labels(:))
        num = sum(labels == n);
        if num < minArea
            binaryImage(labels == n) = 0;
        end
    end
end