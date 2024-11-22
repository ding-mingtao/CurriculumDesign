function LOC = Segment4_Num(COUNT, LOC)
    assert(length(COUNT) <= 4 && length(COUNT) > 0, 'COUNT的长度必须在1到4之间');
    
    if length(COUNT) == 4  % (1,1,1,1)
        return;
    end
    
    if length(COUNT) == 3  % (1,1,2)
        [~, idx] = max(COUNT);  % 最大片段下标
        r = LOC(idx, :);  % 最大片段位置
        start = r(1);
        end_ = r(2);
        m = floor((start + end_) / 2);  % 中间位置
        % 修改LOC(idx, :)
        LOC(idx, :) = [start, m];
        LOC = [LOC(1:idx, :); [m+1, end_]; LOC(idx+1:end, :)];
        return;
    end
    
    if length(COUNT) == 2  % (2,2) or (1,3)
        skew = max(COUNT) / min(COUNT);  % 计算偏移程度
        if skew < 1.7  % 认为是(2,2)
            start1 = LOC(1, 1);
            end1 = LOC(1, 2);
            start2 = LOC(2, 1);
            end2 = LOC(2, 2);
            m1 = floor((start1 + end1) / 2);
            m2 = floor((start2 + end2) / 2);
            LOC = [start1, m1; m1+1, end1; start2, m2; m2+1, end2];
        else  % 认为是(1,3)
            [~, idx] = max(COUNT);  % 最大片段下标
            start = LOC(idx, 1);
            end_ = LOC(idx, 2);
            m1 = floor((end_ - start) / 3) + start;
            m2 = floor((end_ - start) / 3 * 2) + start;
            % 修改LOC(idx, :)
            LOC(idx, :) = [start, m1];
            LOC = [LOC(1:idx, :); [m1+1, m2]; [m2+1, end_]; LOC(idx+1:end, :)];
        end
        return;
    end
    
    if length(COUNT) == 1  % (4)
        start = LOC(1, 1);
        end_ = LOC(1, 2);
        m1 = floor((end_ - start) / 4) + start;
        m2 = floor((end_ - start) / 4 * 2) + start;
        m3 = floor((end_ - start) / 4 * 3) + start;
        LOC = [start, m1; m1+1, m2; m2+1, m3; m3+1, end_];
        return;
    end
end