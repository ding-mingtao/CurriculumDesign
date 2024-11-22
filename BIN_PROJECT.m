% 二值图像一维投影
function PROJ = BIN_PROJECT(bin)
    IMG = double(bin) / 255.0;  % 浮点型
    PROJ = zeros(1, size(IMG, 2));
    for col = 1:size(IMG, 2)
        v = IMG(:, col);  % 列向量
        PROJ(col) = sum(v);
    end
end
