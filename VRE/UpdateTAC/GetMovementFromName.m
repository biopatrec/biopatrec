function movement = GetMovementFromName(name,movements)
    
    movement = movements(1);
    name = ShortToName(name);
    
    for i = 1:length(movements)
        if strcmp(movements(i).name,name)
            movement = movements(i);
        end
    end
end