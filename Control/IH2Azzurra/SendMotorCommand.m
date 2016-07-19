function result = SendMotorCommand(obj, ctrl_type, motor_address, dir, ctrl_val)

    switch ctrl_type
        case 0 %speed control
            % the ctrl_val is mapped to the motor PWM
            PWM = round(ctrl_val*511/100);
            
            % the direction is mapped to the 'S' bit
            if dir == 0%open
                bitS    = '0';
            else
                bitS    = '1';
            end
            
            % check for correct input values
            if PWM > 511 || PWM < 0
                warning('IH2:PWM_OOR',...
                    ['The provided PWM is out of the allowed range (0:511). '...
                    'The closer range limit will be used instead']);
                PWM = min(PWM, 511);
                PWM = max(PWM, 0);
            end

            % build up the command bytes
            PWM_bin = dec2bin(PWM,9);
            MA_bin = dec2bin(str2double(motor_address),4);
            bit8   = PWM_bin(1);
            Byte1  = bin2dec(['1' bitS MA_bin '0' bit8]);
            Byte2  = bin2dec(PWM_bin(2:end));

            % send the command
            fwrite(obj, [Byte1 Byte2]);
            
        case 1 %position control
            
            % the ctrl_val is mapped to the motor position
            Pos = round(ctrl_val*255/100);
           
            if Pos > 255 || Pos < 0
                warning('IH2:POS_OOR', ...
                    ['The provided position is out of the allowed range (0:255).'...
                    'The closer range limit will be used instead']);
                Pos = min(Pos, 255);
                Pos = max(Pos, 0);
            end
            
            % send the command
            fwrite(obj, [68 motor_address Pos]);
    end
    result = 1;
return