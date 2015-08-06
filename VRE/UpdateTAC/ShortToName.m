function name = ShortToName(name)
if iscell(name)
    name = name{1};
end
    switch name
        case 'CH'
            name = 'Close Hand';
        case 'OH'
            name = 'Open Hand';
        case 'FH'
            name = 'Flex Hand';
        case 'EH'
            name = 'Extend Hand';
        case 'FE'
            name = 'Flex Elbow';
        case 'EE'
            name = 'Extend Elbow';
        case 'P'
            name = 'Pronation';
        case 'S'
            name = 'Supination';
    end
end