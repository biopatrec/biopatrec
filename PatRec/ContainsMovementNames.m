function contains = ContainsMovementNames(movements,movementNames)
    contains = 0;
    for i = 1:length(movements)
       if strfind(movementNames{1},movements(i).name{1})
           contains = 1;
       end
    end
end