function varargout = gui2(varargin)
% GUI2 MATLAB code for gui2.fig
%      GUI2, by itself, creates a new GUI2 or raises the existing
%      singleton*.
%
%      H = GUI2 returns the handle to a new GUI2 or the handle to
%      the existing singleton*.
%
%      GUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2.M with the given input arguments.
%
%      GUI2('Property','Value',...) creates a new GUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui2

% Last Modified by GUIDE v2.5 30-Apr-2016 21:47:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui2_OpeningFcn, ...
                   'gui_OutputFcn',  @gui2_OutputFcn, ...
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


% --- Executes just before gui2 is made visible.
function gui2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui2 (see VARARGIN)

% Choose default command line output for gui2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
%global M;
filepath = getappdata(findobj('Name','testUI'),'filepath');
filenames = getappdata(findobj('Name','testUI'),'filenames');
if(ischar(filenames))
    filenames = {filenames};
end

for i = 1:size(filenames,2)
    s = sprintf('set(handles.pushbutton%d,%s,%s)',i,'''visible''','''On''');
    eval(s);
    s = sprintf('set(handles.clear%d,%s,%s)',i,'''visible''','''On''');
    eval(s);
    s = sprintf('set(handles.text%d,%s,%s)',i,'''visible''','''On''');
    eval(s);
    s = sprintf('set(handles.text%d,%s,''%s'')',i,'''string''',filenames{i});
    eval(s);   
    s = sprintf('set(handles.text%d,%s,%s)',i+10,'''visible''','''On''');
    eval(s);
    s = sprintf('set(handles.text%d,%s,%s)',i+20,'''visible''','''On''');
    eval(s);
    %testID2 = (getTestID(filepath,filenames{i}) == 2);
    if(getTestID(filepath,filenames{i}) == testID.fullLLH)
        s = sprintf( 'set(handles.pushbutton%d,%s,%s)',i,'''Enable''','''Off''');
        eval(s);
        s = sprintf('set(handles.clear%d,%s,%s)',i,'''Enable''','''Off''');
       
        s = sprintf('set(handles.text%d,%s,%s)',i+10,'''string''','''(Full LLH)''');
        eval(s);
        
        s = sprintf('set(handles.text%d,%s,%s)',i+10,'''Enable''','''off''');
        eval(s);
        s = sprintf('set(handles.text%d,%s,%s)',i+20,'''string''','''100% L-LH''');
        eval(s);
        s = sprintf('set(handles.text%d,%s,%s)',i+20,'''Enable''','''Off''');
        eval(s);
    end
end
handles.numOfFields = size(filenames,2);
guidata(hObject, handles);
% UIWAIT makes gui2 wait for user response (see UIRESUME)
 %uiwait(handles.figure2);


% --- Outputs from this function are returned to the command line.
function varargout = gui2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function filename = loadFile()
filepath = getappdata(findobj('Name','testUI'),'filepath');
filename = uigetfile('*.dat','Please select part 2 File',filepath);
if (isa(filename,'numeric'))
    filename = '';
end
testid = getTestID(filepath,filename);
if(testid ~= testID.partialLLH2)
         err = sprintf('Error. Expected partial LLH part 2 file. %s have testID of %d\n',...
            filename,testid);
    msgbox(err,'Error in files consistency');
    filename = '';
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = loadFile();
set(handles.text11,'String',filename);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = loadFile();
set(handles.text12,'String',filename);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = loadFile();
set(handles.text13,'String',filename);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = loadFile();
set(handles.text14,'String',filename);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = loadFile();
set(handles.text15,'String',filename);


% --- Executes on button press in clear1.
function clear1_Callback(hObject, eventdata, handles)
% hObject    handle to clear1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text11,'String','');


% --- Executes on button press in clear2.
function clear2_Callback(hObject, eventdata, handles)
% hObject    handle to clear2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text12,'String','');


% --- Executes on button press in clear3.
function clear3_Callback(hObject, eventdata, handles)
% hObject    handle to clear3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text13,'String','');


% --- Executes on button press in clear4.
function clear4_Callback(hObject, eventdata, handles)
% hObject    handle to clear4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text14,'String','');


% --- Executes on button press in clear5.
function clear5_Callback(hObject, eventdata, handles)
% hObject    handle to clear5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text15,'String','');


% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filepath = getappdata(findobj('Name','testUI'),'filepath');
filenames = getappdata(findobj('Name','testUI'),'filenames');
if(ischar(filenames))
    filenames = {filenames};
end
for i = 1:handles.numOfFields
    s = sprintf('get(handles.text%d,''String'')',i+10);
    filename = eval(s);
    %filename = filenames{i};
    s = sprintf('get(handles.text%d,''String'')',i+20);
    graph_name = eval(s);
    if(isempty(filename))
       s = sprintf('get(handles.text%d,''String'')',i);
       filename_print = eval(s);
       s = sprintf('Missing part 2 file.\n Please select part 2 file for %s',filename_print);
       msgbox(s,'Missing file');
       return;
    else
        part2_array{i} = filename;
        if(isempty(graph_name))
            s = strcat(filepath,filenames{i});
            x = countLines(s);
            s = strcat(filepath,filename);
            y = countLines(s);
            graph_names{i} = sprintf('%d%s',uint8((100*x)/(x+y)),'% L-LH');
            %graphname = 
        else
            graph_names{i} = graph_name;
        end
    end
end
%setappdata(handles.figure2,'part2_array',part2_array);
setappdata(findobj('Name','testUI'),'part2_array',part2_array);
setappdata(findobj('Name','testUI'),'graph_names',graph_names);
close(handles.figure2);





% --- Executes on button press in pushbuttonCancel.
function pushbuttonCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure2);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = loadFile();
set(handles.text16,'String',filename);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = loadFile();
set(handles.text17,'String',filename);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = loadFile();
set(handles.text18,'String',filename);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = loadFile();
set(handles.text19,'String',filename);


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = loadFile();
set(handles.text20,'String',filename);


% --- Executes on button press in clear6.
function clear6_Callback(hObject, eventdata, handles)
% hObject    handle to clear6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text16,'String','');


% --- Executes on button press in clear7.
function clear7_Callback(hObject, eventdata, handles)
% hObject    handle to clear7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text17,'String','');


% --- Executes on button press in clear8.
function clear8_Callback(hObject, eventdata, handles)
% hObject    handle to clear8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text18,'String','');


% --- Executes on button press in clear9.
function clear9_Callback(hObject, eventdata, handles)
% hObject    handle to clear9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text19,'String','');


% --- Executes on button press in clear10.
function clear10_Callback(hObject, eventdata, handles)
% hObject    handle to clear10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text20,'String','');



function text26_Callback(hObject, eventdata, handles)
% hObject    handle to text26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text26 as text
%        str2double(get(hObject,'String')) returns contents of text26 as a double


% --- Executes during object creation, after setting all properties.
function text26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text27_Callback(hObject, eventdata, handles)
% hObject    handle to text27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text27 as text
%        str2double(get(hObject,'String')) returns contents of text27 as a double


% --- Executes during object creation, after setting all properties.
function text27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text28_Callback(hObject, eventdata, handles)
% hObject    handle to text28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text28 as text
%        str2double(get(hObject,'String')) returns contents of text28 as a double


% --- Executes during object creation, after setting all properties.
function text28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text29_Callback(hObject, eventdata, handles)
% hObject    handle to text29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text29 as text
%        str2double(get(hObject,'String')) returns contents of text29 as a double


% --- Executes during object creation, after setting all properties.
function text29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text30_Callback(hObject, eventdata, handles)
% hObject    handle to text30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text30 as text
%        str2double(get(hObject,'String')) returns contents of text30 as a double


% --- Executes during object creation, after setting all properties.
function text30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
