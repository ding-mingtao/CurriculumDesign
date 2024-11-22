function varargout = CurriculumDesign(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CurriculumDesign_OpeningFcn, ...
                   'gui_OutputFcn',  @CurriculumDesign_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before CurriculumDesign is made visible.
function CurriculumDesign_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CurriculumDesign (see VARARGIN)

% Choose default command line output for CurriculumDesign
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CurriculumDesign wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CurriculumDesign_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% 初始化
axes(handles.axes1); cla reset;
axes(handles.axes2); cla reset;

set(handles.axes1, 'Box', 'on', 'Color', 'w', 'XTickLabel', '', 'YTickLabel', '');
set(handles.axes2, 'Box', 'on', 'Color', 'w', 'XTickLabel', '', 'YTickLabel', '');
set(handles.text2, 'String', '');

% --- 载入图像.
function loading_IMG_Callback(hObject, eventdata, handles)
% hObject    handle to loading_IMG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1); cla reset;
axes(handles.axes2); cla reset;


set(handles.axes1, 'Box', 'on', 'Color', 'w', 'XTickLabel', '', 'YTickLabel', '');
set(handles.axes2, 'Box', 'on', 'Color', 'w', 'XTickLabel', '', 'YTickLabel', '');
set(handles.text2, 'String', '');

file = fullfile(pwd, '*.png');
[Filename, Pathname] = uigetfile({'*.png;*.jpg' }, file);
if isequal(Filename, 0) || isequal(Pathname, 0)
    return;
end
%显示读入图像
fileurl = fullfile(Pathname,Filename);
I = imread(fileurl);
imshow(I, [], 'Parent', handles.axes1);
handles.I = I;
guidata(hObject, handles);

% --- 图像降噪.
function IMG_Denoising_Callback(hObject, eventdata, handles)
% hObject    handle to IMG_Denoising (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(handles.I, 0)
    return;
end


J = handles.I;
J = rgb2gray(J);     % 灰度化
% 中值滤波器
fsize = [3 3];
K = myMedianFilter(J, fsize);  % 使用3x3的窗口进行中值滤波
imshow(K, [], 'Parent', handles.axes2);
handles.K = K;
handles.J = J;
guidata(hObject, handles);



% --- 图像二值化.
function IMG_Binarization_Callback(hObject, eventdata, handles)
% hObject    handle to IMG_Binarization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(handles.J, 0)
    return;
end

% 获取图像
L = handles.J;
threshold = 0.9 * 255; % 0.9倍的最大灰度值
M = myBinarize(L, threshold);


imshow(M, [], 'Parent', handles.axes2);
handles.M = M;
guidata(hObject, handles);


% --- 验证码定位.
function Captcha_localization_Callback(hObject, eventdata, handles)
% hObject    handle to Captcha_localization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 检查是否已经进行了二值化处理
if isequal(handles.M, 0)
    return;
end

% 获取二值化后的图像
N = handles.M;

% 使用形态学操作分离粘在一起的数字
se = strel('disk', 2); % 创建一个半径为1的圆形结构元素
N = imerode(N, se); % 腐蚀操作
N = imdilate(N, se); % 膨胀操作

% 使用bwlabel标记连通区域
L = bwlabel(N);

% 使用regionprops获取所有连通区域的属性
STATS = regionprops(L, 'BoundingBox', 'Area');

% 过滤掉面积过小的区域（可能是噪声）
minArea = 30; % 设置最小面积阈值
validIndices = find([STATS.Area] > minArea);

% 在图像上绘制矩形框
axes(handles.axes2); % 确保在第二个坐标轴上绘制
cla reset; % 清除之前的绘图
imshow(N, [], 'Parent', handles.axes2); % 显示二值化图像
hold on; % 保持图像，以便绘制矩形框

for i = 1:length(validIndices)
    % 获取当前连通区域的边界框
    boundingBox = STATS(validIndices(i)).BoundingBox;
    
    % 绘制矩形框
    rectangle('Position', boundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
end

hold off; % 释放保持状态
handles.R=N;
% 更新句柄结构体
guidata(hObject, handles);

function IMG_Segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to IMG_Segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(handles.R, 0)
    return;
end
Q=handles.R;
% 提取数字部分
PROJ = sum(Q, 1);  % 水平投影
[LOC, COUNT] = Extract_Num(PROJ);

% 分割数字
LOC = Segment4_Num(COUNT, LOC);

% 提取每个数字
T = cell(1, length(LOC));
for i = 1:length(LOC)
    T{i} = Q(:, LOC(i, 1):LOC(i, 2));
end

% 加入蓝色边框
It = [];
spcr = ones(size(T{1}, 1), 3)*0;
spcg = ones(size(T{1}, 1), 3)*0;
spcb = ones(size(T{1}, 1), 3)*255;
spc = cat(3, spcr, spcg, spcb);
% 整合到一起
It = [It spc];
for i = 1 : length(T)
    ti = T{i};
    ti = cat(3, ti, ti, ti);
    ti = im2uint8(mat2gray(ti));
    It = [It ti spc];
end
imshow(It, [], 'Parent', handles.axes2);

% 保存分割后的图像
handles.segmentedImages = T;
guidata(hObject, handles);


function Captcha_Recognition_Callback(hObject, eventdata, handles)
if isequal(handles.segmentedImages, 0)
    return;
end

% 加载训练好的神经网络
net = load('trainedNet.mat'); % 训练好的网络保存在'trainedNet.mat'文件中
net = net.net;

% 识别分割后的单个数字
T = handles.segmentedImages;
str = '';
for i = 1 : length(T)
    ti = T{i};
    ti = imresize(ti, [32 32]); % 调整图像大小以匹配网络输入
    ti = im2uint8(mat2gray(ti));
    ti = reshape(ti, [32 32 1]); % 调整维度以匹配网络输入
    pred = classify(net, ti);
    str = [str, char(pred)];
end

% 显示识别结果
set(handles.text2, 'String', str);





function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
