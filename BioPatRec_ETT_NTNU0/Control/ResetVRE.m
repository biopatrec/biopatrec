function ResetVRE(obj,handToReset, returningValue)
    fwrite(obj,sprintf('%c%c%c%c%c','r',char(handToReset),char(0),char(0),char(0)));
    if returningValue
        fread(obj,1);
    end
end

