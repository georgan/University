function buttonFcn( hObject, eventdata, handles )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

h = getappdata(handles.output, 'newfigure');%, ishandle(h), strcmp(get(h,'Type'), 'figure')

if ishandle(h) & strcmp(get(h,'Type'), 'figure')
    figure(h)
%     uicontrol(h);
    beep;
end

end

