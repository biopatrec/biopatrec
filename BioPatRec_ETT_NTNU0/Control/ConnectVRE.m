function handles = ConnectVRE(handles, program)
    if ~isfield(handles,'vre_Com')
        open(program);
        handles.vre_Com = tcpip('127.0.0.1',23068,'NetworkRole','server');
        fopen(handles.vre_Com);
    end
    handles = DisableIfExists(handles,'pb_socketConnect');
    handles = DisableIfExists(handles,'pb_socketConnect2');
    handles = EnableIfExists(handles,'pb_socketDisconnect');
    handles = EnableIfExists(handles,'pb_Camera');
    handles = EnableIfExists(handles,'pb_ActivateArm');
end

function handles = EnableIfExists(handles,field)
    if isfield(handles,field)
        set(handles.(field),'Enable','on');
    end
end

function handles = DisableIfExists(handles,field)
    if isfield(handles,field)
        set(handles.(field),'Enable','off');
    end
end