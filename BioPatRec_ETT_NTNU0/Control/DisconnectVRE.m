function handles = DisconnectVRE(handles)
    if isfield(handles,'vre_Com')
        fclose(handles.vre_Com);
        handles = rmfield(handles,'vre_Com');
    end
    handles = EnableIfExists(handles,'pb_socketConnect');
    handles = EnableIfExists(handles,'pb_socketConnect2');
    handles = DisableIfExists(handles,'pb_socketDisconnect');
    handles = DisableIfExists(handles,'pb_Camera');
    handles = DisableIfExists(handles,'pb_ActivateArm');
end

function handles = DisableIfExists(handles,field)
    if isfield(handles,field)
        set(handles.(field),'Enable','off');
    end
end

function handles = EnableIfExists(handles,field)
    if isfield(handles,field)
        set(handles.(field),'Enable','on');
    end
end