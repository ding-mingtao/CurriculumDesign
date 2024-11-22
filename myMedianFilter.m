function image2 = myMedianFilter(image1, fsize)
    % 将彩色图像转换为灰度图像
    if size(image1, 3) == 3 % 检查图像是否为三通道彩色图像
        image1 = double(image1);
        gray_image = 0.299 * image1(:,:,1) + 0.578 * image1(:,:,2) + 0.114 * image1(:,:,3);
    else
        gray_image = double(image1); % 如果已经是灰度图像，则直接转换为double类型
    end
    
    [r c] = size(gray_image);
    m = fsize(1);
    n = fsize(2);
    rs = r + m - 1;
    cs = c + n - 1;

    ims = zeros(rs,cs);
    ims2 = ims;
    ims((m-1)/2+1:(rs-(m-1)/2),(n-1)/2+1:(cs-(n-1)/2)) = gray_image;
    for i = 1:(rs-m+1)
        for j = 1:(cs-n+1)
            img1_temp = ims(i:(i+m-1),j:(j+n-1));
            indr = i + (m-1)/2;
            indc = j + (n-1)/2;
            ims2(indr,indc)=median(img1_temp(:));
        end
    end
    image2 = ims2((m-1)/2+1:(rs-(m-1)/2),(n-1)/2+1:(cs-(n-1)/2));
    image2 = uint8(image2);
end