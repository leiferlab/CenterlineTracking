function varargout = ekans(varargin)
% EKANS MATLAB code for ekans.fig
%      EKANS, by itself, creates a new EKANS or raises the existing
%      singleton*.
%
%      H = EKANS returns the handle to a new EKANS or the handle to
%      the existing singleton*.
%
%      EKANS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EKANS.M with the given input arguments.
%
%      EKANS('Property','Value',...) creates a new EKANS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ekans_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ekans_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ekans

% Last Modified by GUIDE v2.5 09-Jun-2015 16:28:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ekans_OpeningFcn, ...
                   'gui_OutputFcn',  @ekans_OutputFcn, ...
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


% --- Executes just before ekans is made visible.
function ekans_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ekans (see VARARGIN)

% Choose default command line output for ekans
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ekans wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ekans_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in imageFolder.
function imageFolder_Callback(hObject, eventdata, handles)
% hObject    handle to imageFolder (see GCBO)
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

% --- Executes on button press in initSnake.
function initSnake_Callback(hObject, eventdata, handles)
% hObject    handle to initSnake (see GCBO)
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
save('20150610_cl.mat', 'centerlines', '-v6');
setappdata(0, 'centerlines', centerlines);

% --- Executes on button press in autoSnake.
function autoSnake_Callback(hObject, eventdata, handles)
% hObject    handle to autoSnake (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
iImage = getappdata(0, 'iImage');
imFiles = getappdata(0, 'imFiles');
imFolder = getappdata(0, 'imFolder');
background = getappdata(0, 'background');
centerlines = getappdata(0, 'centerlines');



while(get(handles.autoPilot,'value'))
    
    if (size(centerlines,3)<iImage-1)
        disp('Aborting autopilot because the previous frame has no snake!');
        disp('Go back a frame and get a snake.')
        break
    end
    
    disp('Auto piloting..');
    image = im2double(imread(imFiles(iImage).name));
    I = image(:,:,1) - background(:,:,1);
    
    
    snakeInit = centerlines(:,:,iImage-1); 
    %tips
    tips = tiptry(imFolder, iImage, background);
    tips = cell2mat(struct2cell(tips));
    fixtips = zeros(length(tips)/2,2);
    fixtips(:,1) = tips(1:2:end-1);
    fixtips(:,2) = tips(2:2:end);
    rightTips = goodTips(snakeInit, fixtips);
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

% --- Executes on button press in autoPilot.
function autoPilot_Callback(hObject, eventdata, handles)
% hObject    handle to autoPilot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Toggling autopilot!');


% --- Executes on button press in manTips.
function manTips_Callback(hObject, eventdata, handles)
% hObject    handle to manTips (see GCBO)
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
save('20150610_cl.mat', 'centerlines', '-v6');

setappdata(0, 'centerlines', centerlines);


% --- Executes on button press in lastTips.
function lastTips_Callback(hObject, eventdata, handles)
% hObject    handle to lastTips (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Grabbing tips from last frame...');
iImage = getappdata(0, 'iImage');
imFiles = getappdata(0, 'imFiles');
imFolder = getappdata(0, 'imFolder');
background = getappdata(0, 'background');
centerlines = getappdata(0, 'centerlines');

rightTips = [centerlines(1, :, iImage-1);centerlines(end,:,iImage-1)];
image = im2double(imread(imFiles(iImage).name));

I = image(:,:,1) - background(:,:,1);
snakeInit = centerlines(:,:,iImage-1);
disp('Calculating centerline...');
centerlines(:,:,iImage) = SnakeySnakey(rightTips(1,:), rightTips(2,:), snakeInit, I);
disp('OK!');
plotWsnake(centerlines, iImage, imFiles, handles);
    
    save('20150610_cl.mat', 'centerlines', '-v6');
    setappdata(0, 'centerlines', centerlines);


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Key
    case {'w' 'space'}
         manTips_Callback(hObject, eventdata, handles)
    case 'shift'
         lastTips_Callback(hObject, eventdata, handles)
    case 'd'
        sliderVal=get(handles.slider1,'Value');
        set(handles.slider1,'Value',sliderVal+1);
        slider1_Callback(handles.slider1, eventdata, handles)
    case 'a'
        sliderVal=get(handles.slider1,'Value');
        set(handles.slider1,'Value',sliderVal-1);
        slider1_Callback(handles.slider1, eventdata, handles)
end


% --- Executes on button press in loadCenterlines.
function loadCenterlines_Callback(hObject, eventdata, handles)
% hObject    handle to loadCenterlines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[bpath, parent] = uigetfile;
centerlines = load([parent filesep bpath]);
centerlines = cell2mat(struct2cell(centerlines));
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
