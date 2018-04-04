function varargout = testUI(varargin)
% TESTUI MATLAB code for testUI.fig
%      TESTUI, by itself, creates a new TESTUI or raises the existing
%      singleton*.
%
%      H = TESTUI returns the handle to a new TESTUI or the handle to
%      the existing singleton*.
%
%      TESTUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTUI.M with the given input arguments.
%
%      TESTUI('Property','Value',...) creates a new TESTUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testUI

% Last Modified by GUIDE v2.5 24-Mar-2018 23:41:17

% Begin initialization code - DO NOT EDIT.           
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testUI_OpeningFcn, ...
                   'gui_OutputFcn',  @testUI_OutputFcn, ...
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



% --- Executes just before testUI is made visible.
function testUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testUI (see VARARGIN)

% Choose default command line output for testUI
handles.output = hObject;

%new gglobal veriables
%handles.oldHeadIterations = '0';
%handles.oldMiddleIterations = '0';
%handle.oldHeadGroupSize = '10';
%handle.oldMiddleGroupSize = '100';

%handle.oldTailGroupSize = '1';

% Update handles structure
guidata(hObject, handles);
disableAveragesParameters(handles);
disableButtons(handles);
py.importlib.import_module('ReadErrorMap_MP');



% UIWAIT makes testUI wait for user response (see UIRESUME)
 %uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = testUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;
vargout{1} = 2;
%function count =  countLines(filename)
%s = 'type ';
%command = sprintf('%s%s%s',s,filename, ' | find "0" /c');
%[status,cmdout] = dos(command);
%count = str2num(cmdout) - 2;



function setMetaDataInfo(handles)

% SETMETADATAINFO reads the information required from the file and saves it to the MetaData
% handles    structure with handles and user data (see GUIDATA)

global metaData
set(handles.cidText,'string',num2str(metaData.chipID));
manufacturer = metaData.manufacturer;
switch manufacturer
    case 0
        set(handles.manuText,'string','Micron');
    case 1
        set(handles.manuText,'string','Toshiba');
    case 2
        set(handles.manuText,'string','Samsung');
    case 3
        set(handles.manuText,'string','Intel');
    case 4
        set(handles.manuText,'string','Sandisk');
    case 5
        set(handles.manuText,'string','Hynix');
    otherwise
        set(handles.manuText,'string',num2str(metaData.manufacturer));
end
set(handles.pibText,'string',num2str(metaData.pagesPerBlock));
set(handles.bppText,'string',num2str(metaData.bytesPerPage));
set(handles.bnText,'string',num2str(metaData.blockNumber));
test = metaData.testID;
switch test
    case 0
        set(handles.tidText,'string','Standard Test');
    case 1
        set(handles.tidText,'string','L_Biased Test');
    case {2,3}
        set(handles.tidText,'string','L_LH Test');
    case 5
        set(handles.tidText,'string','Error map Test');
    case 6
        set(handles.tidText,'string','LH_H1 Test');
    case 7
        set(handles.tidText,'string','LH_H2 Test');
    otherwise
        set(handles.tidText,'string',num2str(metaData.testID));
end



function clearText(handles)
% CLEARTEXT clears all the text fields in the Gui
% handles    structure with handles and user data (see GUIDATA)

set(handles.cidText,'string','');
set(handles.manuText,'string','');
set(handles.pibText,'string','');
set(handles.bppText,'string','');
set(handles.bnText,'string','');
set(handles.tidText,'string','');
set(handles.iterationsText,'string','');
set(handles.numOfFiles,'string',' ');
set(handles.loadingText,'string','');
handles.numOfIterations = 0;
%handles.filesRead = 0;

function disableButtons(handles)
% DISABLEBUTTONS makes the buttons in the Gui disabled.
% handles    structure with handles and user data (see GUIDATA)

set(handles.buttonBer,'Enable','off');
set(handles.buttonZeroOne,'Enable','off');
set(handles.levelsButton,'Enable','off');
set(handles.bppButton,'Enable','off');
set(handles.selectivePagesText,'Enable','off');
set(handles.rawRadio,'Enable','off');
set(handles.averagesRadio,'Enable','off');
set(handles.compactGraphCB,'Enable','off');

function enableErrorMap(handles)
% ENABLEERRORMAP makes the Error Map section in the Gui enabled.
% handles    structure with handles and user data (see GUIDATA)

set(handles.errorMapButton,'Enable','on');
set(handles.errorMapSliderMin,'Enable','on');
set(handles.errorMap_Min,'Enable','on');
set(handles.text36,'Enable','on');
set(handles.errorMap_Max,'Enable','on');
set(handles.errorMapSlider_Max,'Enable','on');
set(handles.errorMapCB,'Enable','on');
set(handles.markersCB,'Enable','on');
set(handles.errorMapMarkerSize, 'Enable', 'on');
set(handles.MarkersSizeText, 'Enable', 'on');

function disableErrorMap(handles)
% DISABLEERRORMAP makes the Error Map section in the Gui disabled.
% handles    structure with handles and user data (see GUIDATA)

set(handles.errorMapButton,'Enable','off');
set(handles.errorMapSliderMin,'Enable','off');
set(handles.errorMap_Min,'Enable','off');
set(handles.text36,'Enable','off');
set(handles.errorMap_Max,'Enable','off');
set(handles.errorMapSlider_Max,'Enable','off');
set(handles.errorMapCB,'Enable','off');
set(handles.markersCB,'Enable','off');
set(handles.errorMap_Min,'string','');
set(handles.errorMap_Max,'string','');
set(handles.errorMapMarkerSize, 'Enable', 'off');
set(handles.MarkersSizeText, 'Enable', 'off');

function disableLLH(handles)
% DISABLELLH makes the LLH section in the Gui disabled.
% handles    structure with handles and user data (see GUIDATA)
%set(handles.rawRadio,'Enable','off');
%set(handles.averagesRadio,'Enable','off');
%disableAveragesParameters(handles);
set(handles.LLHbutton,'Enable','off');
set (handles.button_load2,'Enable','off');
set(handles.multipleSetsCB,'Enable','off');
set(handles.multipleSetsCB,'value',0);

function enableLLH(handles)
% ENABLELLH makes the LLH section in the Gui enabled.
% handles    structure with handles and user data (see GUIDATA)
%set(handles.rawRadio,'Enable','on');
%set(handles.averagesRadio,'Enable','on');
%enableAveragesParameters(handles);
%set(handles.LLHbutton,'Enable','on');
set (handles.button_load2,'Enable','on');
set(handles.multipleSetsCB,'Enable','on');
set(handles.multipleSetsCB,'value',0);

function setErrorMapFilterValues(handles,min, max)
% DISABLEBUTTONS sets the values in the Error Map section in the Gui.
% handles    structure with handles and user data (see GUIDATA)

set(handles.errorMapSliderMin,'max',max);
set(handles.errorMapSliderMin,'value',0);
set(handles.errorMapSliderMin,'SliderStep',[1/max,1/max]);

set(handles.errorMap_Min,'string','0');
set(handles.errorMap_Max,'string',num2str(max));
set(handles.errorMapSlider_Max,'max',max);
set(handles.errorMapSlider_Max,'value',max);
set(handles.errorMapSlider_Max,'SliderStep',[1/max,1/max]);

function enableButtons(handles)
% DISABLEBUTTONS makes the buttons in the Gui enabled.
% handles    structure with handles and user data (see GUIDATA)

set(handles.buttonBer,'Enable','on');
set(handles.buttonZeroOne,'Enable','on');
set(handles.levelsButton,'Enable','on');
set(handles.bppButton,'Enable','on');
set(handles.selectivePagesText,'Enable','on');
set(handles.rawRadio,'Enable','on');
set(handles.averagesRadio,'Enable','on');
set(handles.compactGraphCB,'Enable','on');


function clearGui(handles)
    set(handles.filePathText, 'string',' ');
    disableButtons(handles);
    disableErrorMap(handles);
    disableLLH(handles);
    disableAveragesParameters(handles);
    set(handles.rawRadio,'value',1);
    clearText(handles);

function [success,guiString,filenames, filepath,numOfLines, differentSizes,multipleTestID] = loadFiles(expectedNOF,expectedTestID,firstRead)
    success = false;
    fileChooserString = 'Please choose files of testID = 4:';
    if firstRead
        fileChooserString = 'Please choose files:';
        %expectedTestID = -1;
        %expectedTestID = testID.supportedTestID;
        %expectedNOF = 0;
    end
    
    [filenames, filepath] = uigetfile('*.dat',fileChooserString,'multiselect','on');
     if (isa(filenames,'numeric'))
         success = false;
         guiString = '';
         numOfLines = 0;
         differentSizes = false;
         multipleTestID = false;
         return;
     end;
     
     if(ischar(filenames))
        guiString = strcat(filepath,filenames);
        numOfFiles = 1;
    else
        guiString = strjoin(filenames,', ');
        numOfFiles = size(filenames,2);
    end
    if((expectedNOF > 0)&& (numOfFiles ~= expectedNOF))
         err = sprintf('Error. Expected %d files of test ID = %d.\n',...
            expectedNOF,expectedTestID);
        msgbox(err,'Error in files consistency');
        success = false;
        guiString = '';
        numOfLines = 0;
        differentSizes = false;
        multipleTestID = false;
        return;
    end;
    
    [numOfLines,consist, differentSizes,multipleTestID] = checkFilesConsistency(filenames,filepath,expectedTestID,firstRead);
    if(~consist)
        %warndlg('Error bad file name\s!');
        return;
    end
    
    success = true;
    return;
    
        
% --- Executes on button press in chooseFileButton.
function chooseFileButton_Callback(hObject, eventdata, handles)
% hObject    handle to chooseFileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%[filenames, filepath] = uigetfile('*.dat','choose files','multiselect','on');
global differentSizes;
global multipleTestID;
[success, guiFilePathString, filenames, filepath, numOfLines, differentSizes,multipleTestID] = loadFiles(0,testID.supportedTestID,true);
if (success == false )
    return;
end


set(handles.loadingText,'string','loading file\s...');
drawnow;

set(handles.filePathText,'string',guiFilePathString);

global metaData;
global M;
global M2;
global firstFilePath;

metaData = [];
M = [];
M2 = [];
firstFilePath = '';
%reading metadata and setting global M matrix
[M,metaData,filesRead, firstFilePath] = readFiles(filenames,filepath,numOfLines,handles);



if(metaData.testID == testID.standardTest || metaData.testID == testID.errorMap)
    handles.numOfIterations = numOfLines;
    guidata(hObject, handles);
    set(handles.iterationsText,'string',handles.numOfIterations);
    set(handles.numOfFiles,'string',num2str(filesRead));
end
 %adjust gui
switch metaData.testID
    case testID.standardTest
        disableErrorMap(handles);
        disableLLH(handles);
        setDefaults(handles);
        enableButtons(handles);
    case {testID.fullLLH,testID.partialLLH1}
        disableButtons(handles);
        disableErrorMap(handles);
        %setDefaults(handles);
        setappdata(handles.figure1,'filenames',filenames);
        setappdata(handles.figure1,'filepath',filepath);
        disableLLH(handles);
        enableLLH(handles);
        %support up to 10 files of testID = 3 to be loaded with specific
        %matching part 2
        if(differentSizes || multipleTestID)
            %more then 10 files leads to an error since we cant avg the
            %files
            if(size(M,2) > 10)
                err = sprintf('Error in files Combination. Mixing tests of different testID\nor different sizes is limited to maximum of 10 files.');
                msgbox(err,'Error reading files');
                M = [];
                %metaData = [];
                clearGui(handles);
                return;
            else
               set(handles.multipleSetsCB,'Enable','off');
               set(handles.multipleSetsCB,'value',1); 
            end
        else
            %single testID, all files from the sames size so we can avg
            %them
            if((size(M,2) > 10))
                set(handles.multipleSetsCB,'Enable','off');
                set(handles.multipleSetsCB,'value',0);
            end
        end
        if(metaData.testID == testID.fullLLH && ~multipleTestID)
            %disable part2 button and enable LLH button
            set(handles.LLHbutton,'Enable','on');
            set (handles.button_load2,'Enable','off');
        end
    case testID.errorMap
        disableButtons(handles);
        disableLLH(handles);
        disableAveragesParameters(handles);
        enableErrorMap(handles);
        setErrorMapFilterValues(handles,min(M(:)), max(M(:)));
        
        if size(M,1)==metaData.pagesPerBlock/2
            % Levels was selected:
            set(handles.errorMapCB, 'Enable','off');
            set(handles.errorMapCB, 'Value', 0);    
        end

    otherwise
         return;
end
set(handles.loadingText,'string','');
setMetaDataInfo(handles);





function filePathText_Callback(hObject, eventdata, handles)
% hObject    handle to filePathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filePathText as text
%        str2double(get(hObject,'String')) returns contents of filePathText as a double


% --- Executes during object creation, after setting all properties.
function filePathText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filePathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonBer.
function buttonBer_Callback(hObject, eventdata, handles)
global M;
global metaData;
% hObject    handle to buttonBer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s= get(handles.filePathText, 'string');
if(isempty(s))
    warndlg('bad file name!');
    return;
end
method = get(get(handles.methodsPanel,'selectedObject'),'string');
if (strcmp(method , 'Raw'))
    BER(M,metaData);
else
    headIterations = get(handles.headSlider,'Value');
    middleIterations = get(handles.middleSlider, 'Value');
    headGroupSize = str2num(get(handles.headGroupSize,'string'));
    middleGroupSize = str2num(get(handles.middleGroupSize,'string'));
    tailGroupSize = str2num(get(handles.tailGroupSize,'string'));
    BERAverages(M,metaData,headIterations,headGroupSize,middleIterations, middleGroupSize,tailGroupSize);
end


% --- Executes on button press in buttonZeroOne.
function buttonZeroOne_Callback(hObject, eventdata, handles)
% hObject    handle to buttonZeroOne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global M;
global metaData;
s= get(handles.filePathText, 'string');
if(isempty(s))
    warndlg('bad file name!');
    return;
end
method = get(get(handles.methodsPanel,'selectedObject'),'string');
if (strcmp(method , 'Raw'))
    ZeroOne(M,metaData);
else
    headIterations = get(handles.headSlider,'Value');
    middleIterations = get(handles.middleSlider, 'Value');
    headGroupSize = str2num(get(handles.headGroupSize,'string'));
    middleGroupSize = str2num(get(handles.middleGroupSize,'string'));
    tailGroupSize = str2num(get(handles.tailGroupSize,'string'));
    ZeroOneAverages(M,metaData,headIterations,headGroupSize,middleIterations, middleGroupSize,tailGroupSize);
end


% --- Executes on button press in levelsButton.
function levelsButton_Callback(hObject, eventdata, handles)
% hObject    handle to levelsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global M;
global metaData;
s= get(handles.filePathText, 'string');
if(isempty(s))
    warndlg('bad file name!');
    return;
end
method = get(get(handles.methodsPanel,'selectedObject'),'string');
if (strcmp(method , 'Raw'))
    Levels(M,metaData);
else
    headIterations = get(handles.headSlider,'Value');
    middleIterations = get(handles.middleSlider, 'Value');
    headGroupSize = str2num(get(handles.headGroupSize,'string'));
    middleGroupSize = str2num(get(handles.middleGroupSize,'string'));
    tailGroupSize = str2num(get(handles.tailGroupSize,'string'));
    LevelsAverages(M,metaData,headIterations,headGroupSize,middleIterations, middleGroupSize,tailGroupSize);
end


% --- Executes on button press in bppButton.
function bppButton_Callback(hObject, eventdata, handles)
global M;
global metaData;
global firstFilePath;
% hObject    handle to bppButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s= get(handles.filePathText, 'string');
if(isempty(s))
    warndlg('bad file name!');
    return;
end
method = get(get(handles.methodsPanel,'selectedObject'),'string');
if (strcmp(method , 'Raw'))
    BerPerPage(M,metaData,get(handles.selectivePagesText,'string'),firstFilePath,get(handles.compactGraphCB,'value'));
else
    headIterations = get(handles.headSlider,'Value');
    middleIterations = get(handles.middleSlider, 'Value');
    headGroupSize = str2num(get(handles.headGroupSize,'string'));
    middleGroupSize = str2num(get(handles.middleGroupSize,'string'));
    tailGroupSize = str2num(get(handles.tailGroupSize,'string'));
    BerPerPageAverages(M,metaData,get(handles.selectivePagesText,'string'),firstFilePath,headIterations,headGroupSize,middleIterations, middleGroupSize,tailGroupSize,get(handles.compactGraphCB,'value'));
end

% --- Executes on button press in levelsCheckBox.
function levelsCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to levelsCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of levelsCheckBox



function selectivePagesText_Callback(hObject, eventdata, handles)
% hObject    handle to selectivePagesText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of selectivePagesText as text
%        str2double(get(hObject,'String')) returns contents of selectivePagesText as a double


% --- Executes during object creation, after setting all properties.
function selectivePagesText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectivePagesText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in averagesRadio.
function averagesRadio_Callback(hObject, eventdata, handles)
% hObject    handle to averagesRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of averagesRadio



% --- Executes on button press in rawRadio.
function rawRadio_Callback(hObject, eventdata, handles)
% hObject    handle to rawRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of rawRadio


%rounds the values of heas slider and head iterations text box according to
%the head group size 
function roundHeadSliderAndText(handles);
roundingFactor = double(str2num(get(handles.headGroupSize,'string')));
val = floor(double(get(handles.headSlider,'Value'))/roundingFactor)*roundingFactor;
set(handles.headSlider,'Value', val);
set(handles.headIterations,'string',num2str(val));



function roundMiddleSliderAndText(handles)
roundingFactor = double(str2num(get(handles.middleGroupSize,'string')));
val = floor(double(get(handles.middleSlider,'Value'))/roundingFactor)*roundingFactor;
set(handles.middleSlider,'Value', val);
set(handles.middleIterations,'string',num2str(val));


    

% --- Executes on slider movement.
function headSlider_Callback(hObject, eventdata, handles)
% hObject    handle to headSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
roundHeadSliderAndText(handles);

headValue = get(handles.headSlider,'Value');
middleValue = get(handles.middleSlider,'Value');
iterations = str2num(get(handles.iterationsText,'string'));
if((headValue + middleValue) > iterations)
   set(handles.middleSlider,'Value',iterations-headValue);
    roundMiddleSliderAndText(handles);
end
snapTailGroupSize(handles);


% --- Executes during object creation, after setting all properties.
function headSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to headSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function middleSlider_Callback(hObject, eventdata, handles)
% hObject    handle to middleSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
roundMiddleSliderAndText(handles);
headValue = get(handles.headSlider,'Value');
middleValue = get(handles.middleSlider,'Value');
iterations = str2num(get(handles.iterationsText,'string'));
if(headValue + middleValue > iterations)
    set(handles.headSlider,'Value',iterations-middleValue);
    roundHeadSliderAndText(handles);
end
snapTailGroupSize(handles);




% --- Executes during object creation, after setting all properties.
function middleSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to middleSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function headIterations_Callback(hObject, eventdata, handles)
% hObject    handle to headIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of headIterations as text
%        str2double(get(hObject,'String')) returns contents of headIterations as a double


    


% --- Executes during object creation, after setting all properties.
function headIterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to headIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function middleIterations_Callback(hObject, eventdata, handles)
% hObject    handle to middleIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of middleIterations as text
%        str2double(get(hObject,'String')) returns contents of middleIterations as a double


% --- Executes during object creation, after setting all properties.
function middleIterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to middleIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function headGroupSize_Callback(hObject, eventdata, handles)
% hObject    handle to headGroupSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of headGroupSize as text
%        str2double(get(hObject,'String')) returns contents of headGroupSize as a double
text = get(hObject, 'string');
fixedText = regexp(text,'\d','match');
fixedText = strjoin(fixedText,'');
if(str2num(fixedText) > get(handles.headSlider,'Value'))
    fixedText = get(handles.headIterations,'string');
elseif (str2num(fixedText) == 0)
    fixedText = '1';
end
set(handles.headGroupSize,'string',fixedText);
roundHeadSliderAndText(handles);
headSliderMax = str2num(get(handles.iterationsText,'string'));
set(handles.headSlider,'SliderStep',[str2num(fixedText)/headSliderMax,str2num(fixedText)/headSliderMax]);
snapTailGroupSize(handles);

    



% --- Executes during object creation, after setting all properties.
function headGroupSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to headGroupSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function middleGroupSize_Callback(hObject, eventdata, handles)
% hObject    handle to middleGroupSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of middleGroupSize as text
%        str2double(get(hObject,'String')) returns contents of middleGroupSize as a double
text = get(hObject, 'string');
fixedText = regexp(text,'\d','match');
fixedText = strjoin(fixedText,'');
if(str2num(fixedText) > get(handles.middleSlider,'Value'))
    fixedText = get(handles.middleIterations,'string');
elseif (str2num(fixedText) == 0)
    fixedText = '1';
end
set(handles.middleGroupSize,'string',fixedText);
roundMiddleSliderAndText(handles);
middleSliderMax = str2num(get(handles.iterationsText,'string'));
set(handles.middleSlider,'SliderStep',[str2num(fixedText)/middleSliderMax,str2num(fixedText)/middleSliderMax]);
snapTailGroupSize(handles);


% --- Executes during object creation, after setting all properties.
function middleGroupSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to middleGroupSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function snapTailGroupSize(handles)
tailIterations = handles.numOfIterations-get(handles.headSlider,'Value')-get(handles.middleSlider,'Value');
tailGroupSize = str2num(get(handles.tailGroupSize,'string'));
if(tailIterations == 0 | tailGroupSize == 1 )
    return;
end
%tailGroupSize = str2num(get(handles.tailGroupSize,'string'));
set(handles.tailGroupSize,'string',num2str(closestDivider(tailIterations,tailGroupSize)));

function x = closestDivider(num, referanceValue)
x = closestInArray(allDividers(num),referanceValue);

function tailGroupSize_Callback(hObject, eventdata, handles)
% hObject    handle to tailGroupSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tailGroupSize as text
%        str2double(get(hObject,'String')) returns contents of tailGroupSize as a double
text = get(hObject, 'string');
fixedText = regexp(text,'\d','match');
fixedText = strjoin(fixedText,'');
tailIterations = handles.numOfIterations-get(handles.headSlider,'Value')-get(handles.middleSlider,'Value');
if(tailIterations == 0 )
    ; %dont change its value

elseif (str2num(fixedText) == 0)
fixedText = '1';

else
   fixedText = num2str(closestDivider(tailIterations,str2num(fixedText))); 


end
set(handles.tailGroupSize,'string',fixedText);


% --- Executes during object creation, after setting all properties.
function tailGroupSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tailGroupSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function setDefaults(handles)
% SETDEFAULTS Set default values for the fields in the Gui
% handles    structure with handles and user data (see GUIDATA)

set(handles.headSlider,'min',0);
headSliderMax = str2num(get(handles.iterationsText,'string'));
set(handles.headSlider,'max',headSliderMax);
set(handles.headSlider,'SliderStep',[10/headSliderMax,10/headSliderMax]);
set(handles.headSlider,'Value',0.2*headSliderMax);

set(handles.middleSlider,'min',0);
set(handles.middleSlider,'max',headSliderMax);
set(handles.middleSlider,'SliderStep',[100/headSliderMax,100/headSliderMax]);
set(handles.middleSlider,'Value',0.8*headSliderMax);

set(handles.headIterations,'string',num2str(0.2*headSliderMax));
set(handles.middleIterations,'string',num2str(0.8*headSliderMax));

set(handles.headGroupSize,'string','10');
set(handles.middleGroupSize,'string','100');
set(handles.tailGroupSize,'string','1');




function disableAveragesParameters(handles)
% DISABLEAVERAGESPARAMETERS Disables the Average section in the Gui, not enabled until the user choose to
% handles    structure with handles and user data (see GUIDATA)

set(handles.headText,'Enable','off');
set(handles.middleText,'Enable','off');
set(handles.headSlider,'Enable','off');
set(handles.middleSlider,'Enable','off');
set(handles.headIterations,'Enable','off');
set(handles.middleIterations,'Enable','off');
set(handles.headConnectingText,'Enable','off');
set(handles.middleConnectingText,'Enable','off');
set(handles.tailConnectingText,'Enable','off');
set(handles.headGroupSize,'Enable','off');
set(handles.middleGroupSize,'Enable','off');
set(handles.tailGroupSize,'Enable','off');
set(handles.headFinalText,'Enable','off');
set(handles.middleFinalText,'Enable','off');
set(handles.tailFinalText,'Enable','off');
set(handles.resetButton,'Enable','off');



function enableAveragesParameters(handles)
% DISABLEAVERAGESPARAMETERS enables the Average section in the Gui duo to user preferance
% handles    structure with handles and user data (see GUIDATA)

set(handles.headText,'Enable','on');
set(handles.middleText,'Enable','on');
set(handles.headSlider,'Enable','on');
set(handles.middleSlider,'Enable','on');
set(handles.headIterations,'Enable','on');
set(handles.middleIterations,'Enable','on');
set(handles.headConnectingText,'Enable','on');
set(handles.middleConnectingText,'Enable','on');
set(handles.tailConnectingText,'Enable','on');
set(handles.headGroupSize,'Enable','on');
set(handles.middleGroupSize,'Enable','on');
set(handles.tailGroupSize,'Enable','on');
set(handles.headFinalText,'Enable','on');
set(handles.middleFinalText,'Enable','on');
set(handles.tailFinalText,'Enable','on');
set(handles.resetButton,'Enable','on');

    


% --- Executes when selected object is changed in methodsPanel.
function methodsPanel_SelectionChangedFcn(hObject, eventdata, handles)

% hObject    handle to the selected object in methodsPanel 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = get(get(handles.methodsPanel,'selectedObject'),'string');
switch selection
    case 'Averages'
        enableAveragesParameters(handles);
    case 'Raw'
        disableAveragesParameters(handles);
end
        


% --- Executes during object creation, after setting all properties.
function iterationsText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iterationsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in resetButton.
function resetButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setDefaults(handles);


% --- Executes when uipanel3 is resized.
function uipanel3_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to uipanel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function tidText_Callback(hObject, eventdata, handles)
% hObject    handle to tidText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tidText as text
%        str2double(get(hObject,'String')) returns contents of tidText as a double


% --- Executes during object creation, after setting all properties.
function tidText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tidText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bnText_Callback(hObject, eventdata, handles)
% hObject    handle to bnText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bnText as text
%        str2double(get(hObject,'String')) returns contents of bnText as a double


% --- Executes during object creation, after setting all properties.
function bnText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bnText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cidText_Callback(hObject, eventdata, handles)
% hObject    handle to cidText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cidText as text
%        str2double(get(hObject,'String')) returns contents of cidText as a double


% --- Executes during object creation, after setting all properties.
function cidText_CreateFcn(hObject, eventdata, ~)
% hObject    handle to cidText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pibText_Callback(hObject, eventdata, handles)
% hObject    handle to pibText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pibText as text
%        str2double(get(hObject,'String')) returns contents of pibText as a double


% --- Executes during object creation, after setting all properties.
function pibText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pibText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bppText_Callback(hObject, eventdata, handles)
% hObject    handle to bppText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bppText as text
%        str2double(get(hObject,'String')) returns contents of bppText as a double


% --- Executes during object creation, after setting all properties.
function bppText_CreateFcn(hObject, ~, handles)
% hObject    handle to bppText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function manuText_Callback(hObject, eventdata, handles)
% hObject    handle to manuText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of manuText as text
%        str2double(get(hObject,'String')) returns contents of manuText as a double


% --- Executes during object creation, after setting all properties.
function manuText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to manuText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in compactGraphCB.
function compactGraphCB_Callback(hObject, eventdata, handles)
% hObject    handle to compactGraphCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of compactGraphCB


% --- Executes on button press in errorMapButton.
function errorMapButton_Callback(hObject, eventdata, handles)
% hObject    handle to errorMapButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global M;
global metaData;
min = get(handles.errorMapSliderMin,'value');
max = get(handles.errorMapSlider_Max,'value');
if (max == get(handles.errorMapSlider_Max,'max'))
    max = 0;
end
cb = get(handles.errorMapCB,'value');
markers = get(handles.markersCB,'value');
markers_size = get(handles.errorMapMarkerSize, 'value');

% readErororMap and readErrorMapCalibraterd are prompting for the type of
% graph to display (normal or by levels) and will return M with different
% dimensions in each case.
% if its normal ploting - the number of rows will be pagesPerBlock/6 (tuples
% of 3 pages are summed and the pages are divided to left and right. total
% of 2*3 division.
% if its "levels" plotting, readErrorMap and readErrorMap Calibrates will
% return M with pagesPerBlock/2 rows.
if size(M,1)==metaData.pagesPerBlock/2
    % ploting by levels.
    errorMapLevels(M, metaData, min,max,cb,markers,markers_size);
else
    % ploting by planes
    errorMap(M, metaData, min,max,cb,markers,markers_size);
end

% --- Executes on slider movement.
function errorMapSliderMin_Callback(hObject, eventdata, handles)
% hObject    handle to errorMapSliderMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value = get(hObject,'value');
value = ceil(value);
set(handles.errorMapSliderMin,'value',value);
set(handles.errorMap_Min,'string',num2str(value));
if(get(handles.errorMapSlider_Max,'value') < value)
    set(handles.errorMapSlider_Max,'value',value);
    set(handles.errorMap_Max,'string',num2str(value));
end
set(handles.errorMapSlider_Max,'min',value);
max = get(handles.errorMapSlider_Max,'max');
range = max-value;
if(range == 0)
    range = 1;
end
set(handles.errorMapSlider_Max,'SliderStep',[1/range,1/range]);

% --- Executes during object creation, after setting all properties.
function errorMapSliderMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to errorMapSliderMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function errorMap_Max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to errorMap_Max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function errorMapSlider_Max_Callback(hObject, eventdata, handles)
% hObject    handle to errorMapSlider_Max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value = get(hObject,'value');
value = ceil(value);
set(handles.errorMapSlider_Max,'value',value);
set(handles.errorMap_Max,'string',num2str(value));

% --- Executes during object creation, after setting all properties.
function errorMapSlider_Max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to errorMapSlider_Max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in errorMapCB.
function errorMapCB_Callback(hObject, eventdata, handles)
% hObject    handle to errorMapCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of errorMapCB


% --- Executes on button press in markersCB.
function markersCB_Callback(hObject, eventdata, handles)
% hObject    handle to markersCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of markersCB


% --------------------------------------------------------------------
function uipanel8_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LLHbutton.
function LLHbutton_Callback(hObject, eventdata, handles)
% hObject    handle to LLHbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global M;
global M2;
global metaData;

method = get(get(handles.methodsPanel,'selectedObject'),'string');
if (strcmp(method , 'Raw'))
   LLH(M,M2,getappdata(findobj('Name','testUI'),'graph_names'),get(handles.multipleSetsCB,'value'),metaData);
else
    headIterations = get(handles.headSlider,'Value');
    middleIterations = get(handles.middleSlider, 'Value');
    headGroupSize = str2num(get(handles.headGroupSize,'string'));
    middleGroupSize = str2num(get(handles.middleGroupSize,'string'));
    tailGroupSize = str2num(get(handles.tailGroupSize,'string'));
    LLHAverages(M,metaData,headIterations,headGroupSize,middleIterations, middleGroupSize,tailGroupSize);
end


% --- Executes on button press in multipleSetsCB.
function multipleSetsCB_Callback(hObject, eventdata, handles)
% hObject    handle to multipleSetsCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of multipleSetsCB


% --- Executes on button press in button_load2.
function button_load2_Callback(hObject, eventdata, handles)
% hObject    handle to button_load2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global M;
global M2;
global metaData;
%global differentSizes;
global multipleTestID;
M2 = [];
multipleGraphs = get(handles.multipleSetsCB,'value');
%here we can only have testID 2 or 3 so:
%if(metaData(6) == 2)
%metaData(6)
%multipleTestID
if(multipleTestID)
        expectedTestID = testID.mixSecondPart;
else
    if (metaData.testID == testID.fullLLH)
        expectedTestID = testID.fullLLH;
    else
        expectedTestID = testID.partialLLH2;
    end
end
%expectedTestID
if multipleGraphs
  waitfor(gui2);
  %get return from gui2
  filenames = getappdata(findobj('Name','testUI'),'part2_array');
  filepath = getappdata(findobj('Name','testUI'),'filepath');
  %read the files while asserting cosistency
  [numOfLines,consist, differentSizes,multipleTestID] = checkFilesConsistency(filenames, filepath,expectedTestID,false);
  if(~ consist)
      return;
  end
  %populate M2
else
    %load multiple "part 2".
        %read part 2
    [success, ~, filenames, filepath, numOfLines] = loadFiles(size(M,2),expectedTestID, false);
    if (success == false)
        %clearGui(handles);
        M2 = [];
        return;
    end
    %[M2,trash1,filesRead, trash3] = readFiles(filenames,filepath,numOfLines);
end
%[M2,trash1,filesRead, trash3] = readFiles(filenames,filepath,numOfLines);
[M2,~,filesRead,~] = readFiles(filenames,filepath,numOfLines, handles);

if(size(M2,2) == size(M,2))
    handles.numOfIterations = size(M{1},1) + numOfLines;
    guidata(hObject, handles);
    set(handles.iterationsText,'string',handles.numOfIterations);
    set(handles.numOfFiles,'string',num2str(filesRead)); 
    setDefaults(handles); 
    set(handles.LLHbutton,'Enable','on');
else
    %invalid amount of "type 2" files or any other error in reading files:
    M2 = [];
    return;
end


% --- Executes on slider movement.
function errorMapMarkerSize_Callback(hObject, eventdata, handles)
% hObject    handle to errorMapMarkerSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function errorMapMarkerSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to errorMapMarkerSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
