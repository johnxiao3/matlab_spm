function varargout = afm_img_demo(varargin)
% AFM_IMG_DEMO MATLAB code for afm_img_demo.fig
%      AFM_IMG_DEMO, by itself, creates a new AFM_IMG_DEMO or raises the existing
%      singleton*.
%
%      H = AFM_IMG_DEMO returns the handle to a new AFM_IMG_DEMO or the handle to
%      the existing singleton*.
%
%      AFM_IMG_DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFM_IMG_DEMO.M with the given input arguments.
%
%      AFM_IMG_DEMO('Property','Value',...) creates a new AFM_IMG_DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before afm_img_demo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to afm_img_demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help afm_img_demo

% Last Modified by GUIDE v2.5 01-Jul-2023 15:52:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @afm_img_demo_OpeningFcn, ...
                   'gui_OutputFcn',  @afm_img_demo_OutputFcn, ...
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


% --- Executes just before afm_img_demo is made visible.
function afm_img_demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to afm_img_demo (see VARARGIN)

% Choose default command line output for afm_img_demo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes afm_img_demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = afm_img_demo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_open.
function pb_open_Callback(hObject, eventdata, handles)
% hObject    handle to pb_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,path] = uigetfile('*.spm');

handles.path = path;
handles.files = dir([path '\*.spm']);
handles.curr_file_index = 1;
handles.tot = length(handles.files);

if ~isequal(file,0)
    file_name = fullfile(path,handles.files(1).name);
    NSMU = NSMatlabUtilities();
    NSMU.Open(file_name);
    [data, scale_units, type_desc] = NSMU.GetImageData(1, NSMU.METRIC);
    NSMU.Close();
    data_flatten = flatten(data,1);
    axes(handles.axes1);
    imagesc(data_flatten);
    handles.data_flatten = data_flatten;
    str1 = [num2str(1) '/' num2str(handles.tot) ': ' handles.files(1).name];
    set(handles.txt_name,'String',str1);
end

guidata(hObject, handles);

% --- Executes on button press in pb_planefit.
function pb_planefit_Callback(hObject, eventdata, handles)
% hObject    handle to pb_planefit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1);
a = imrect;
wait(a);
pos = round(getPosition(a)); % pos have format of [x,y,w,h]
delete(a);
img_pf = planefit(handles.data_flatten,pos(2),pos(2)+pos(4),pos(1),pos(1)+pos(3));
axes(handles.axes1);
imagesc(img_pf);
rectangle('Position',pos,'EdgeColor','g','LineWidth',2);
handles.pf_pos = pos;
handles.img_pf = img_pf;
guidata(hObject, handles);


% --- Executes on button press in pb_placeboxes.
function pb_placeboxes_Callback(hObject, eventdata, handles)
% hObject    handle to pb_placeboxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1);
a = imrect;
wait(a);
pos = round(getPosition(a)); % pos have format of [x,y,w,h]
delete(a);


img_pf = handles.img_pf(pos(2):pos(2)+pos(4),pos(1):pos(1)+pos(3));
result = round(mean(img_pf(:)),2);

axes(handles.axes1);
imagesc(handles.img_pf);
rectangle('Position',handles.pf_pos,'EdgeColor','g','LineWidth',2);
rectangle('Position',pos,'EdgeColor','b','LineWidth',2);

set(handles.txt_result,'String',[num2str(result) ' nm'])

handles.result = result;
guidata(hObject, handles);



% figure;imagesc(img_pf)
% 
% flat_subimg = img_pf(:)
% p = prctile(flat_subimg,100-20);
% bw = flat_subimg > p;
% result2 = mean(bw.*flat_subimg);
% 
% bw_subimg = img_pf > p;
% figure;imagesc(bw_subimg);


% --- Executes on button press in pb_Next.
function pb_Next_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

screenshot_path = [handles.path '\results\'];
status = mkdir(screenshot_path);
cur_fn = handles.files(handles.curr_file_index).name;
sc_fn = [screenshot_path cur_fn(1:end-4), '.jpg'];
saveas(handles.figure1,sc_fn,'jpg');

if handles.curr_file_index == 1
    fid = fopen([handles.path 'result.csv'], 'w' );
    fprintf( fid, 'FileName,Value\n');
    fprintf( fid, '"%s",%f\n', cur_fn, handles.result);
else
    fid = fopen([handles.path 'result.csv'], 'a+' );
    fprintf( fid, '"%s",%f\n', cur_fn, handles.result);
end

if handles.curr_file_index == handles.tot
    set(handles.txt_name,'String','completed!');
    return
end

handles.curr_file_index = handles.curr_file_index+1;
file_name = fullfile(handles.path,handles.files(handles.curr_file_index ).name);
NSMU = NSMatlabUtilities();
NSMU.Open(file_name);
[data, scale_units, type_desc] = NSMU.GetImageData(1, NSMU.METRIC);
NSMU.Close();
data_flatten = flatten(data,1);
axes(handles.axes1);
imagesc(data_flatten);
handles.data_flatten = data_flatten;
str1 = [num2str(handles.curr_file_index) '/'  ...
    num2str(handles.tot) ': ' ...
    handles.files(handles.curr_file_index).name];
set(handles.txt_name,'String',str1);

guidata(hObject, handles);


