function binaryImage = myOtsu(rawImage)
  ima = double(rawImage);
  im2 = ima;
  H = myHist(ima);
  L = length(H);
  P1 = cumsum(H); % 累积和
  avg_global = mean(ima(:));
  
  max_sigmaB = -1; % 初始化最大类间方差
  threshold = 0;   % 初始化阈值
  
  for k = 1:L
      w0 = P1(k);
      w1 = 1 - w0;
      if w0 == 0 || w1 == 0
          continue;
      end
      u0 = sum((0:k-1) .* H(1:k)) / w0;
      u1 = (avg_global - u0 * w0) / w1;
      sigmaB = w0 * w1 * (u0 - u1)^2;
      if sigmaB > max_sigmaB
          max_sigmaB = sigmaB;
          threshold = k - 1;
      end
  end
  
  im2(im2 >= threshold) = 255;
  im2(im2 < threshold) = 0;
  binaryImage = uint8(im2);
end

function H = myHist(ima)
  ima = double(ima);
  [r, c] = size(ima);
  L = 256;
  H = zeros(1, L);
  for k = 1:L
      H(k) = sum(ima(:) == k - 1);
  end
  H = H / (r * c);
end
