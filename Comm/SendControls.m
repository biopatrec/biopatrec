function SendControls(control,savedControls)

device = digitalio('nidaq', 'Dev1');
addline(device,0:3,'out');


if control(1)
    %for i = 1:length(savedControls)
    switch(savedControls(1))
        case 1
    putvalue(device, [1 1 0 0]);
        case 2
    putvalue(device, [0 0 1 1]);
        case 3
    putvalue(device, [1 0 0 0]);
        case 4
    putvalue(device, [0 1 0 0]); 
    end
    %end

elseif control(2)
    switch(savedControls(2))
        case 1
    putvalue(device, [1 1 0 0]);
        case 2
    putvalue(device, [0 0 1 1]);
        case 3
    putvalue(device, [1 0 0 0]);
        case 4
    putvalue(device, [0 1 0 0]); 
    end
    
elseif control(3)
    switch(savedControls(3))
        case 1
    putvalue(device, [1 1 0 0]);
        case 2
    putvalue(device, [0 0 1 1]);
        case 3
    putvalue(device, [1 0 0 0]);
        case 4
    putvalue(device, [0 1 0 0]); 
    end

elseif control(4)
    switch(savedControls(4))
        case 1
    putvalue(device, [1 1 0 0]);
        case 2
    putvalue(device, [0 0 1 1]);
        case 3
    putvalue(device, [1 0 0 0]);
        case 4
    putvalue(device, [0 1 0 0]); 
    end

else
    putvalue(device, [0 0 0 0]); 
end
end


    