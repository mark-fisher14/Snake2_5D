function varargout = snake2_5D(varargin)
% SNAKE2_5D MATLAB code for snake2_5D.fig
%      SNAKE2_5D, by itself, creates a new SNAKE2_5D or raises the existing
%      singleton*.
%
%      H = SNAKE2_5D returns the handle to a new SNAKE2_5D or the handle to
%      the existing singleton*.
%
%      SNAKE2_5D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SNAKE2_5D.M with the given input arguments.
%
%      SNAKE2_5D('Property','Value',...) creates a new SNAKE2_5D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before snake2_5D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to snake2_5D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help snake2_5D

% Last Modified by GUIDE v2.5 08-Nov-2017 20:43:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @snake2_5D_OpeningFcn, ...
                   'gui_OutputFcn',  @snake2_5D_OutputFcn, ...
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


% --- Executes just before snake2_5D is made visible.
function snake2_5D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to snake2_5D (see VARARGIN)

% Initialise some variables
handles.studyName = '';
handles.pathname = '';
handles.firstFile = '';
handles.firstSliceNo = 0;
handles.midFile = '';
handles.midSliceNo = 0;
handles.lastFile = '';
handles.lastSliceNo = 0;
handles.filterSpec = '';
handles.maskImage = [];
handles.method = 'edge';
handles.n_iter = 10;
handles.n_obj = 1;
handles.smoothFactor = 0.0;
handles.contractionBias = 0.0;
handles.ROI = [];
handles.V = [];
handles.M = [];




% Choose default command line output for snake2_5D
handles.output = hObject;

% turn axis off (displaying images)
axis off

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes snake2_5D wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = snake2_5D_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1 (Middle Slice).
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Clear Status
clearMsg(handles);

% prompt user for file
filterSpec = handles.filterSpec;
if isempty(filterSpec)
    [filename, pathname] = uigetfile('*.*', 'Select middle slice to be segmented');
else
    [filename, pathname] = uigetfile(filterSpec, 'Select middle slice to be segmented');
end

if filename
  [studyName, midSliceNo, ext] = parseFilename(filename);
  filterSpec = strcat(pathname, '*', ext);
  if isnan(midSliceNo)
    error('error - unable to parse filename'); 
  end
  % Display slice number in textbox    
  text4string = sprintf('%04d', midSliceNo);
  set(handles.text4,'String',text4string);
  % Set slider to reflect slice number
  set(handles.slider2, 'Value', midSliceNo);
  
  % Check for consistent filterSpec
  if ~isempty(handles.filterSpec)
    if ~strcmp(filterSpec, handles.filterSpec)
      error('Error: inconsistent file extension');
    end
  end

  % Check for consistant studyName
  if (~isempty(handles.studyName))
    if (~strcmp(studyName, handles.studyName))
        error('Error - inconsistant study!');
    end
  end

  % Display Study Name in textbox
  set(handles.text6, 'String', studyName);

  % Save number of first slice number
  handles.midSliceNo=midSliceNo;
  % Save filename of first slice
  handles.midFile=strcat(pathname, filename);
  % Save studyName
  handles.studyName=studyName;
  % Save filterSpec
  handles.filterSpec=filterSpec;
  % Save pathname
  handles.pathname=pathname;
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton2 (First Slice).
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Ask user to select first slice for segmentation 

%Clear Status
clearMsg(handles);

filterSpec = handles.filterSpec;
if isempty(filterSpec)
    [filename, pathname] = uigetfile('*.tif', 'Select first slice to be segmented');
else
    [filename, pathname] = uigetfile(filterSpec, 'Select first slice to be segmented');
end

if filename
  [studyName, firstSliceNo, ext] = parseFilename(filename);
  filterSpec = strcat(pathname, '*', ext);
  if isnan(firstSliceNo)
    error('error - unable to parse filename'); 
  end
  % Display slice number in textbox    
  text3string = sprintf('%04d', firstSliceNo);
  set(handles.text3,'String',text3string);
  % Set slider to reflect slice number
  set(handles.slider1, 'Value', firstSliceNo);
  
  % Check for consistent filterSpec
  if ~isempty(handles.filterSpec)
    if ~strcmp(filterSpec, handles.filterSpec)
      error('Error: inconsistent file extension');
    end
  end

  % Check for consistant studyName
  if (~isempty(handles.studyName))
    if (~strcmp(studyName, handles.studyName))
        error('error - inconsistant study!');
    end
  end

  % Display Study Name in textbox
  set(handles.text6, 'String', studyName);

  % Save number of first slice number
  handles.firstSliceNo=firstSliceNo;
  % Save filename of first slice
  handles.firstFile=strcat(pathname, filename);
  % Save studyName
  handles.studyName=studyName;
  % Save filterSpec
  handles.filterSpec=filterSpec;
  % Save pathname
  handles.pathname=pathname;
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on firstFile slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%Clear Status
clearMsg(handles);

% Has user selected a file?
firstFile = handles.firstFile;
if isempty(firstFile)
    % Output Error message
    dispMsg('Error: No File Selected - Load First Slice',handles);
else
    % Clear status window
    clearMsg(handles);
    % Update the slice number
    firstSliceNo = round(get(hObject,'Value'));
    % Display slice number in textbox    
    text3string = sprintf('%04d', firstSliceNo);
    set(handles.text3,'String',text3string);
    % Update filename
    firstFile = buildFullfile(firstFile,firstSliceNo);
    
    % Save number of first slice number
    handles.firstSliceNo=firstSliceNo;
    % Save filename of first slice
    handles.firstFile=firstFile;

    % Update handles structure
    guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on midFile slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%Clear Status
clearMsg(handles);

% Has user selected a file?
midFile = handles.midFile;
if isempty(midFile)
    % Output Error message
    dispMsg('Error: No File Selected - Load Middle Slice',handles);
else
    % Clear status window
    clearMsg(handles);
    % Update the slice number
    midSliceNo = round(get(hObject,'Value'));
    % Display slice number in textbox    
    text4string = sprintf('%04d', midSliceNo);
    set(handles.text4,'String',text4string);
    % Update filename
    midFile = buildFullfile(midFile,midSliceNo);
    
    % Save number of first slice number
    handles.midSliceNo=midSliceNo;
    % Save filename of first slice
    handles.midFile=midFile;

    % Update handles structure
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton3 (Last Slice).
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Ask user to select last slice for segmentation 

%Clear Status
clearMsg(handles);

filterSpec = handles.filterSpec;
if isempty(filterSpec)
    [filename, pathname] = uigetfile('*.tif', 'Select last slice to be segmented');
else
    [filename, pathname] = uigetfile(filterSpec, 'Select last slice to be segmented');
end

if filename
  [studyName, lastSliceNo, ext] = parseFilename(filename);
  filterSpec = strcat(pathname, '*', ext);
  % Throw error if this is not the case
  if isnan(lastSliceNo)
      error('error - unable to parse filename'); 
  end
  % Display slice number in textbox    
  text5string = sprintf('%04d', lastSliceNo);
  set(handles.text5,'String',text5string);
  % Set slider to reflect slice number
  set(handles.slider3, 'Value', lastSliceNo);
  
  % Check for consistent filterSpec
  if ~isempty(handles.filterSpec)
    if ~strcmp(filterSpec, handles.filterSpec)
      error('Error: inconsistent file extension');
    end
  end

  % Check for consistant studyName
  if (~isempty(handles.studyName))
      if (~strcmp(studyName, handles.studyName))
          error('error - inconsistant study!');
      end
  end

  % Display Study Name in textbox
  set(handles.text6, 'String', studyName);

  % Save number of first slice number
  handles.lastSliceNo=lastSliceNo;
  % Save filename of first slice
  handles.lastFile=strcat(pathname, filename);
  % Save studyName
  handles.studyName=studyName;
  % Save filterSpec
  handles.filterSpec=filterSpec;
  % Save pathname
  handles.pathname=pathname;
end

% Update handles structure
guidata(hObject, handles);



% --- Executes on last File slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%Clear Status
clearMsg(handles);

% Has user selected a file?
lastFile = handles.lastFile;
if isempty(lastFile)
    % Output Error message
    set(handles.text7, 'String', 'Error: No File Selected - Load First Slice');
else
    % Update the slice number
    lastSliceNo = round(get(hObject,'Value'));
    % Display slice number in textbox    
    text5string = sprintf('%04d', lastSliceNo);
    set(handles.text5,'String',text5string);
    % Update filename
    lastFile = buildFullfile(lastFile,lastSliceNo);
        
    % Save number of first slice number
    handles.lastSliceNo=lastSliceNo;
    % Save filename of first slice
    handles.lastFile=lastFile;

    % Update handles structure
    guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton4 (First Slice Preview).
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Clear Status
clearMsg(handles);

if (isempty(handles.firstFile))
    % Error message
    dispMsg('Error: No File Selected - Load First Slice',handles);
else
    % Clear status window
    clearMsg(handles);
    set(handles.text7, 'String', '');
    % Display First Slice
    imdisp(imread(handles.firstFile),handles.ROI);
end

% --- Executes on button press in pushbutton5 (Middle Slice Preview).
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (isempty(handles.midFile))
    % Error message
    dispMsg('Error: No File Selected - Load Middle Slice',handles);
else
    % Clear status window
    clearMsg(handles);
    % Display First Slice
    imdisp(imread(handles.midFile),handles.ROI);
end


% --- Executes on button press in pushbutton6 (Last Slice Preview).
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Clear Status
clearMsg(handles);

if (isempty(handles.lastFile))
    % Error message
    dispMsg('Error: No File Selected - Load Last Slice',handles);
else
    % Clear status window
    clearMsg(handles);
    % Display First Slice
    imdisp(imread(handles.lastFile),handles.ROI);
end


% --- Executes on button press in pushbutton7 (Edit Mask).
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%firstFile = handles.firstFile;
midFile = handles.midFile;
%lastFile = handles.lastFile;

% if (isempty(firstFile) || isempty(midFile) || isempty(lastFile))
%     set(handles.text7, 'String', 'Error: Please select first, mid and last slice');
if (isempty(midFile))
    dispMsg('Error: Please select mid slice',handles);
else
    clearMsg(handles);
    temp = imcrop(imread(midFile),handles.ROI);
    imshow(temp);
    [X, Y] = getline(handles.axes1, 'closed');
    
    ROI = double(handles.ROI);
    % make a mask
    handles.maskImage = poly2mask(X,Y,ROI(4),ROI(3));
        
    % display the mask
    %imshow(handles.maskImage);
    imdisp(imread(midFile),handles.ROI);
    patch(handles.axes1, X, Y, [0 1 0], ...
                 'FaceVertexAlphaData', 0.5, ...
                 'FaceAlpha', 'flat') ;
    
        
    % Update handles structure
    guidata(hObject, handles);
         
end
    


% --- Executes on button press in pushbutton8 (Run).
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Clear Status
clearMsg(handles);

% check parameters
if isempty(handles.maskImage)
  dispMsg('Error: Please Set Mask',handles);
  ready = false;
else
  if isempty(handles.firstFile)
    dispMsg('Error: Please Set First Slice',handles);
    ready = false;
  else
    if isempty(handles.midFile)
      dispMsg('Error: Please Set Mid Slice',handles);
      ready = false;
    else
      if isempty(handles.lastFile)
        dispMsg('Error: Please Set Last Slice',handles);
        ready = false;
      else
          ready = true;
      end
    end
  end
end

if ~(handles.firstSliceNo < handles.midSliceNo < handles.lastSliceNo)
  dispMsg('Error: inconsistent slice numbering');
  ready = false;
end

if ready
  % build volume
  handles.V = buildVolume(handles);
  if ~isempty(handles.ROI)
    handles.V = imcrop3(handles);
  end
  % filter volume
  dispMsg('Applying 5x5x5 Median Filter...',handles);
  handles.V = medfilt3(handles.V,[5 5 5]);
  % run segmenter
  handles.M = segmentVolume(handles);
  clearMsg(handles);
end

% Update handles structure
guidata(hObject, handles);



% --- Executes on selection change in popupmenu1 (active contour method).
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

str = get(hObject, 'String');
val = get(hObject, 'Value');

% Set current data to the selected data set.
switch str{val}
    case 'edge' % User selects peaks.
        handles.method = 'edge';
    case 'Chan-Vase' % User selects membrane
        handles.method = 'Chan_Vase';
end

% Save the handles structure.
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text8.
function text8_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function text8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton7.
function pushbutton7_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on pushbutton7 and none of its controls.
function pushbutton7_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% returns contents of edit1 as a double
handles.n_iter = str2double(get(hObject,'String')); 

% Update handles structure
guidata(hObject, handles);

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



function edit2_Callback(hObject, eventdata, handles) % n_obj
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

%returns contents of edit2 as a double
handles.n_obj = str2double(get(hObject,'String')); 

% Update handles structure
guidata(hObject, handles);


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


% --- Executes on button press in pushbutton9. Set ROI
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (isempty(handles.midFile))
    dispMsg('Error: Please select mid slice',handles);
else
    clearMsg(handles);
    I = imread(handles.midFile);
    [~,rect] = imcrop(I);
    handles.ROI = int16(rect);
    imdisp(I,handles.ROI);
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton10. Reset ROI
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (isempty(handles.midFile))
    dispMsg('Error: Please select mid slice',handles);
else
    clearMsg(handles);
    handles.ROI = [];
    imdisp(imread(handles.midFile),handles.ROI);
    handles.maskImage = [];
    dispMsg('Mask has been deleted!',handles);
end

% Update handles structure
guidata(hObject, handles);

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

dispMsg('Enter positive value between 0-5',handles);

%returns contents of edit3 as a double
handles.smoothFactor = str2double(get(hObject,'String')); 

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

dispMsg('Enter small positive value between 0 - 1.0',handles);

%returns contents of edit2 as a double
handles.contractionBias = str2double(get(hObject,'String')); 

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton11. 'View'
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


M = handles.M;
if ~isempty(M)
  dispMsg('Postprocessing volume',handles);
  % pad along dimension 3
  M = padarray(M,[0 0 10]);
  M = imopen(M, strel('sphere',3));
  for i=1:size(M,3)
    [~,num]=bwlabel(M(:,:,i));
    if num > handles.n_obj
      M(:,:,i) = getLargestCc(M(:,:,i),[],1);
    end
  end
  volumeViewer(M);
  handles.M = M;
  clearMsg(handles);
else
  dispMsg('Error: No volume to view!');
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pushbutton12. 'Save'
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.M)
  [pathstr,~,ext] = fileparts(handles.midFile);
  [status, msg]=mkdir(pathstr, 'snake2_5D');

  if status
    for i=1:size(handles.M,3)
      I = handles.M(:,:,i);
      filename = buildFullfile(strcat(pathstr, '/', 'snake2_5D', '/mask0000', ext), handles.firstSliceNo+i-1 );
      imwrite(I,filename,'tif');
      dispMsg(strcat('Writing: ', filename),handles);
    end
  else
    dispMsg(msg,handles);
  end
end
  



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Helper Functions
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imdisp(I,ROI)
% IMDISP 

if isempty(ROI)
  imshow(I);
else
  %xmin=ROI(1); ymin=ROI(2); width=ROI(3); height=ROI(4);
  %imshow(I(ymin:ymin+height,xmin:xmin+width));
  imshow(imcrop(I,ROI));
  drawnow
end

function dispMsg(str,handles)
% dispMsg

set(handles.text7, 'String', str);
drawnow

function clearMsg(handles)
% clearMsg

set(handles.text7, 'String', '');
drawnow

function str = buildFullfile(filename, sliceNo)
% buildFullfile - generates new filename by appending slice no to studyName

% find number of digits used for slice no
[pathname,name,ext] = fileparts(filename) ;
l = size(name,2);
n = l;
while ismember(name(n),'0123456789')
  n = n-1;
end

rootFilename = name(1:n);
format_spec = strcat('%0', num2str(l-n), 'd');
str = fullfile(pathname, strcat(rootFilename, num2str(sliceNo,format_spec), ext));


function [studyName, sliceNo, ext] = parseFilename(filename)
% parseFilename

% recover slice no
[~,name,ext] = fileparts(filename) ;
l = size(name,2);
n = l;
while ismember(name(n),'0123456789')
  n = n-1;
end
sliceNo = str2double(name(n+1:l));
studyName = name(1:n);

function  V = buildVolume(handles)
% buildVolume

dispMsg('Building Volume...', handles);

I = imread(handles.midFile);
% create 3D volume
x = size(I,1); y = size(I,2); z = handles.lastSliceNo - handles.firstSliceNo +1;
V = uint16(zeros(x,y,z));

s = 1;
for slice = handles.firstSliceNo:handles.lastSliceNo
  str = strcat('Building Volume...', num2str(slice));
  dispMsg(str,handles);
  V(:,:,s) = imread(buildFullfile(handles.midFile, slice));
  s = s+1;
end


function Vout = imcrop3(h)
% imcrop3 - crop volume slice-by-slice

ROI = h.ROI;
ROI(3) = ROI(3)-1; ROI(4) = ROI(4)-1;
for s = 1:size(h.V,3)
  Vout(:,:,s) = imcrop(h.V(:,:,s),ROI);
end

function [m, sp ,n] = acm(i,s,m,sp,n,h)
% acm - evolve active contour

% set parameters
cb = h.contractionBias;
sf = h.smoothFactor;

if (n < h.n_iter) 
  mNew = activecontour(s,~m,1,'edge', 'ContractionBias', cb, 'SmoothFactor', sf);
  mNew = ~mNew;
else
  mNew = activecontour(s,m,1,'edge', 'ContractionBias', cb, 'SmoothFactor', sf);
end
mNew = imclearborder(mNew);
mask_diff = m-mNew;
sp = sum(mask_diff(:))/sum(m(:));
[~,num]=bwlabel(mNew);
if num>h.n_obj
  mNew = getLargestCc(mNew,[],1);
end
%imshow(imoverlay(s, bwmorph(mNew, 'remove'), [0 1 0]));
imshow(imoverlay(s, mNew, [0 1 0]));
drawnow
str = sprintf('Slice %d: Speed: %2.2f: iter: %d', i+h.firstSliceNo-1, sp * 100, n); 
dispMsg(str,h);

m=mNew;
n=n+1;
if n == h.n_iter, sp = 10; end % reset speed +ve


function M = segmentVolume(h)
% segmentVolume - run active contours on slices

lo = h.midSliceNo - h.firstSliceNo;
hi = h.lastSliceNo - h.midSliceNo;
offset = max(lo,hi);
% map SliceNos onto V
mid = h.midSliceNo - h.firstSliceNo+1;

% initialise masks
M = false(size(h.V));
upmask = h.maskImage;
dnmask = h.maskImage;

for i = 0:offset
  up = mid+i;
  dn = mid-i;
  % process 'up' slices
  if up>=1 && up<=size(h.V,3)
    slice = h.V(:,:,up); 
    speed = 10; n = 1;
    while (speed > 0) || (n < h.n_iter) 
      [upmask, speed, n] = acm(up,slice,upmask,speed,n,h);
    end % while
    upmask=imfill(upmask,'holes');
    M(:,:,up)=upmask;
  end %if
  % process 'down' slices
  if dn>=1 && dn<=size(h.V,3)
    slice = h.V(:,:,dn); 
    speed = 10; n = 1;
    while (speed > 0) || (n < h.n_iter)
      [dnmask, speed, n] = acm(dn,slice,dnmask,speed,n,h);
    end % while
    dnmask=imfill(dnmask,'holes');
    M(:,:,dn)=dnmask;
  end %if
end %for
  






    
    
