function [LOC, COUNT] = Extract_Num(PROJ)
    num = 0;
    COUNT = [];
    LOC = [];
    for i = 1:length(PROJ)
        if PROJ(i) ~= 0  % 如果非零则累加
            num = num + 1;
            if i == 1 || PROJ(i-1) == 0  % 记录片段起始位置
                start = i;
            end
            if i == length(PROJ) || PROJ(i+1) == 0  % 定义片段结束标志，并记录片段
                end_ = i;
                if num > 10  % 提取有效片段
                    COUNT = [COUNT, num];
                    LOC = [LOC; start, end_];
                end
                num = 0;  % 清0
            end
        end
    end
end
