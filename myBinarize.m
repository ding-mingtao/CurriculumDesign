function binaryImage = myBinarize(image, threshold)
    % 将图像归一化到 [0, 1] 范围
    normalizedImage = mat2gray(image);
    
    % 应用给定的阈值进行逆向二值化
    binaryImage = normalizedImage < (threshold / 255);
    % 将二值图像转换为 0 和 255
    binaryImage = uint8(binaryImage) * 255;
    
    % 去除小连通域
    binaryImage = RemoveSmallCC(binaryImage, 25, 4); % 例如，去除小于55像素的小连通域
    
    % 定义结构元素
    size = 3;
    kernel = strel('square', size); % 创建一个3x3的方形结构元素
    
    % 形态学开运算（先腐蚀后膨胀）
    binaryImage = imopen(binaryImage, kernel);
    binaryImage = remove_horizontal_lines(binaryImage);
end

