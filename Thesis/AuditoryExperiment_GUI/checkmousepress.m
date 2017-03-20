function checkmousepress( hObject, eventdata, handles )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

set(hObject, 'ButtonDownFcn', {@buttonFcn, handles});
guidata(handles.output, handles);
children = get(hObject, 'Children');

for i = 1:length(children)
    checkmousepress(children(i), eventdata, handles);
end

guidata(handles.output, handles);

end

