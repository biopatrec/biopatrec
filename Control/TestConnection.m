function result = TestConnection(com)

	% Open connection
    if ~strcmp(com.status,'open')
    	fopen(com);
    end 
    % Send test message
    fwrite(com,'A','char');
    fwrite(com,'C','char');
    replay = char(fread(com,1,'char'));
    if strcmp(replay,'C');
        result = 1;
    else
        result = 0;      
    end

end