function varargout = arbok(varargin)
% ARBOK MATLAB code for arbok.fig
%      ARBOK, by itself, creates a new ARBOK or raises the existing
%      singleton*.
%
%      H = ARBOK returns the handle to a new ARBOK or the handle to
%      the existing singleton*.
%
%      ARBOK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARBOK.M with the given input arguments.
%
%      ARBOK('Property','Value',...) creates a new ARBOK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before arbok_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to arbok_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help arbok

% Last Modified by GUIDE v2.5 15-Jun-2015 13:30:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @arbok_OpeningFcn, ...
                   'gui_OutputFcn',  @arbok_OutputFcn, ...
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


% --- Executes just before arbok is made visible.
function arbok_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to arbok (see VARARGIN)

% Choose default command line output for arbok
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes arbok wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = arbok_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
 setappdata(handles.figure1,'currentFrame',get(handles.slider1,'value'));
 iImage = round(getappdata(handles.figure1,'currentFrame'));
 setappdata(0, 'iImage', iImage);
 imFiles = getappdata(0,'imFiles');
centerlines = getappdata(0, 'centerlines');
plotWsnake(centerlines, iImage, imFiles, handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in loadImages.
function loadImages_Callback(hObject, eventdata, handles)
% hObject    handle to loadImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imFolder = uigetdir([],'Select imFile Folder');
setappdata(0,'imFolder',imFolder);
imFiles=dir([imFolder filesep '*.jpeg']);
setappdata(0,'imFiles',imFiles);
%set slider properties based on # of images
set(handles.slider1,'Min',1);
set(handles.slider1,'Max',length(imFiles));
set(handles.slider1,'Value',1)
set(handles.slider1,'SliderStep',[1/length(imFiles) , 10/length(imFiles)])

% --- Executes on button press in background.
function background_Callback(hObject, eventdata, handles)
% hObject    handle to background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[bpath, parent] = uigetfile;
background = load([parent filesep bpath]);
background = cell2mat(struct2cell(background));
setappdata(0, 'background', background);

% --- Executes on button press in loadTips.
function loadTips_Callback(hObject, eventdata, handles)
% hObject    handle to loadTips (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[bpath, parent] = uigetfile;
tips = load([parent filesep bpath]);
tips = cell2mat(struct2cell(tips));
tip1 = tips(1:length(tips)/2,:)
tip2 = tips((length(tips)/2+1):end, :)
setappdata(0, 'tip1', tip1);
setappdata(0, 'tip2', tip2);

% --- Executes on button press in getCenterlines.
function getCenterlines_Callback(hObject, eventdata, handles)
% hObject    handle to getCenterlines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[bpath, parent] = uigetfile;
centerlines = load([parent filesep bpath]);
centerlines = cell2mat(struct2cell(centerlines));
setappdata(0, 'centerlines', centerlines);


% --- Executes on button press in autopilot.
function autopilot_Callback(hObject, eventdata, handles)
% hObject    handle to autopilot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
iImage = getappdata(0, 'iImage');
imFiles = getappdata(0, 'imFiles');
imFolder = getappdata(0, 'imFolder');
background = getappdata(0, 'background');
centerlines = getappdata(0, 'centerlines');
tip1 = getappdata(0, 'tip1');
tip2 = getappdata(0, 'tip2');


while(get(handles.autotoggle,'value'))
    image = im2double(imread(imFiles(iImage).name));
    I = image(:,:,1) - background(:,:,1);
    
    snakeInit = centerlines(:,:,iImage-1); 
    rightTips(1,:) = tip1(iImage,:);
    rightTips(2,:) = tip2(iImage,:);
    centerlines(:,:,iImage) = SnakeySnakey(rightTips(1,:), rightTips(2,:), snakeInit, I);
    
      plotWsnake(centerlines, iImage, imFiles, handles);
    save('20150610_cl.mat', 'centerlines', '-v6');
    setappdata(0, 'centerlines', centerlines);
    disp('Waiting..');
    pause(.4);
    iImage = iImage+1;
    setappdata(0, 'iImage', 'iImage');
    set(handles.slider1, 'Value', iImage);
end
    
    
    
% --- Executes on button press in autotoggle.
function autotoggle_Callback(hObject, eventdata, handles)
% hObject    handle to autotoggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autotoggle


% --- Executes on button press in manualTips.
function manualTips_Callback(hObject, eventdata, handles)
% hObject    handle to manualTips (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
iImage = getappdata(0, 'iImage');
imFiles = getappdata(0, 'imFiles');
imFolder = getappdata(0, 'imFolder');
background = getappdata(0, 'background');
centerlines = getappdata(0, 'centerlines');

[y,x]=ginput(2);

 image = im2double(imread(imFiles(iImage).name));

tip1 = [x(1) y(1)];
tip2 = [x(2) y(2)];
snakeInit = centerlines(:,:, iImage-1);

I = image(:,:,1)- background(:,:,1);

disp('Computing centerline...');
centerlines(:,:,iImage) = SnakeySnakey(tip1, tip2, snakeInit, I);
disp('OK!');
plotWsnake(centerlines, iImage, imFiles, handles);
save('20150611_w8_cl.mat', 'centerlines', '-v6');

setappdata(0, 'centerlines', centerlines);


% Updates the main window of the gui
function plotWsnake(centerlines, iImage, imFiles, handles)
cla(handles.axes1);


 image = im2double(imread(imFiles(iImage).name));
 hold on;
 ax1 = imagesc(image, 'parent', handles.axes1);
 if size(centerlines,3)>=iImage
     hold on;
     plot(centerlines(:,2,iImage), centerlines(:,1,iImage), '-g','parent', handles.axes1)
     hold off;
 end
 disp(iImage)


% --- Executes on button press in snakeInit.
function snakeInit_Callback(hObject, eventdata, handles)
% hObject    handle to snakeInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
iImage = getappdata(0, 'iImage');
background = getappdata(0, 'background');
imFiles = getappdata(0, 'imFiles');
imFolder = getappdata(0, 'imFolder');
centerlines = getappdata(0,'centerlines');
image = im2double(imread(imFiles(iImage).name));

centerlines(:,:, iImage) = initialSnake(imFolder, image, background);

plotWsnake(centerlines, iImage, imFiles, handles);
save('20150611_w8_cl.mat', 'centerlines', '-v6');
setappdata(0, 'centerlines', centerlines);
