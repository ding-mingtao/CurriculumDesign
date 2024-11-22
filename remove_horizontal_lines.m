function result_image = remove_horizontal_lines(binary_image)
    % 进行一维投影
    PROJ = BIN_PROJECT(binary_image);
    
    % 找到投影分量较小的区域（字符间横线）
    flaw_area = find(PROJ < 10);
    
    % 去除横线
    img_dila = binary_image;
    img_dila(:, flaw_area) = 0;
    
    % 去除小连通区域
    img_dila = RemoveSmallCC(img_dila, 25,4);
    
    result_image = img_dila;
end



