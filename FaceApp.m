#Simple GUI Matlab stream webcam, capture and detect faces using pre-trained Viola Jones Method

function varargout = FaceApp(varargin)
%FACEAPP MATLAB code file for FaceApp.fig
%      FACEAPP, by itself, creates a new FACEAPP or raises the existing
%      singleton*.
%
%      H = FACEAPP returns the handle to a new FACEAPP or the handle to
%      the existing singleton*.
%
%      FACEAPP('Property','Value',...) creates a new FACEAPP using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to FaceApp_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      FACEAPP('CALLBACK') and FACEAPP('CALLBACK',hObject,...) call the
%      local function named CALLBACK in FACEAPP.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FaceApp

% Last Modified by GUIDE v2.5 21-Mar-2018 13:31:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FaceApp_OpeningFcn, ...
                   'gui_OutputFcn',  @FaceApp_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before FaceApp is made visible.
function FaceApp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for FaceApp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FaceApp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FaceApp_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in START.
function START_Callback(hObject, eventdata, handles)
% hObject    handle to START (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid vidRes 
vid = videoinput('winvideo');
axes(handles.axes1);
vidRes = vid.VideoResolution;
nBands = vid.NumberOfBands;
hImage = image( zeros(vidRes(2), vidRes(1), nBands) );
preview(vid, hImage);

% --- Executes on button press in capture.
function capture_Callback(hObject, eventdata, handles)
% hObject    handle to capture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid im vidRes
global IFaces faceDetector  videoFrameGray 
global bbox bboxPoints bboxPolygon noFace m output
%stop(vid);
vidRes = vid.VideoResolution;
im=getsnapshot(vid);%trigger DepthVid to capture image
im=imresize(im,[420, 580]);
axes(handles.axes2);
%im=imresize(im,[vidRes(2) vidRes(1)]);
faceDetector = vision.CascadeObjectDetector();
videoFrameGray = rgb2gray(im);
bbox = faceDetector.step(videoFrameGray);
if ~isempty(bbox)
%bboxPoints = bbox2points(bbox(1, :));
%bboxPolygon = reshape(bboxPoints', 1, []);
%IFaces = insertShape(im, 'Polygon', bboxPolygon, 'LineWidth', 3);
IFaces = insertObjectAnnotation(im, 'rectangle', bbox, 'Face','LineWidth', 3);
[noFace,m ]=size(bbox);
imshow(IFaces);output=[ num2str(noFace) ' Faces Detected'];
set(handles.edit1,'string',output);
else 
imshow(im);
set(handles.edit1,'string',['No Faces Detected']);
end
delete(vid);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
