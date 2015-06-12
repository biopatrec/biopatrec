function SendKeys(keys,savedKeys)
    import java.awt.*;
    import java.awt.event.*;
    rob=Robot;
    
    %AvailableKeys = {KeyEvent.VK_A,KeyEvent.VK_B,KeyEvent.VK_C,KeyEvent.VK_D,KeyEvent.VK_E,KeyEvent.VK_F,KeyEvent.VK_G,KeyEvent.VK_H,KeyEvent.VK_I,KeyEvent.VK_J,KeyEvent.VK_K,KeyEvent.VK_L,KeyEvent.VK_M,KeyEvent.VK_N,KeyEvent.VK_O,KeyEvent.VK_P,KeyEvent.VK_Q,KeyEvent.VK_R,KeyEvent.VK_S,KeyEvent.VK_T,KeyEvent.VK_U,KeyEvent.VK_V,KeyEvent.VK_W,KeyEvent.VK_X,KeyEvent.VK_Y,KeyEvent.VK_Z};
    
    if(numel(savedKeys) > 0)
        for i = 1:length(savedKeys)
            KeyFunction(savedKeys(i),keys(i),rob);
        end
    else
        if keys(1)
            rob.keyPress(KeyEvent.VK_W);
        else
            rob.keyRelease(KeyEvent.VK_W);
        end
        if keys(2)
            rob.keyPress(KeyEvent.VK_S);
        else
            rob.keyRelease(KeyEvent.VK_S);
        end
        if keys(3)
            rob.keyPress(KeyEvent.VK_A);
        else
            rob.keyRelease(KeyEvent.VK_A);
        end
        if keys(4)
            rob.keyPress(KeyEvent.VK_D);
        else
            rob.keyRelease(KeyEvent.VK_D);
        end    
    end
end

function KeyFunction(key,event,rob)
    import java.awt.*;
    import java.awt.event.*;
    
    switch(key)
        case 1
            if event
                rob.keyPress(KeyEvent.VK_W);
            else
                rob.keyRelease(KeyEvent.VK_W);
            end
        case 2
            if event
                rob.keyPress(KeyEvent.VK_A);
            else
                rob.keyRelease(KeyEvent.VK_A);
            end
        case 3
            if event
                rob.keyPress(KeyEvent.VK_S);
            else
                rob.keyRelease(KeyEvent.VK_S);
            end
        case 4
            if event
                rob.keyPress(KeyEvent.VK_D);
            else
                rob.keyRelease(KeyEvent.VK_D);
            end
    end
end