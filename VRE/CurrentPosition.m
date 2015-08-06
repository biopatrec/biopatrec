function obj = CurrentPosition(varargin)
    
    persistent target allowance positions distance movements classifier tempdistance

    if(length(varargin) < 1)
        return
    end
    obj = [];
    if ischar(varargin{1})
       switch(varargin{1})
           case 'init'
               classifier = varargin{2};
               allowance =  varargin{3};
               movements =  varargin{4};
               
               max = 0;
               for i = 1:length(movements)
                   if movements(i).idVRE > max
                       max = movements(i).idVRE;
                   end                       
               end
               
               positions = zeros(1,max); 
           case 'target'
               
               distance = 0;
               tempdistance = 0;
               
               index =  varargin{2};
               dist =   varargin{3};
               
               movement = movements(index);
               target = zeros(1,length(positions));
               
               for i = 1:length(movement)
                   if movement(i).vreDir == 0
                    target(movement(i).idVRE) = -1 * dist;
                   else
                    target(movement(i).idVRE) = dist;
                   end
               end
               
               positions = zeros(1,length(positions));
               
           case 'move'
               %Make sure within limit and Check if inside, if not, move it.
               newPos = positions;
               
               index = varargin{2};
               speeds = varargin{3};
               
               movement = movements(index);
               
               for i = 1:length(movement)
                   id = movement(i).idVRE;
                   if id > 0
                     if movement(i).vreDir == 0
                        newPos(id) = newPos(id) - speeds(index(i));
                     else
                        newPos(id) = newPos(id) + speeds(index(i));
                     end
                   end
               end
               
               movedDistance = abs(EuclidDist(newPos,positions));
               
               if abs(EuclidDist(newPos,target)) < allowance
                   tempdistance = tempdistance + movedDistance;
               else
                   distance = distance + movedDistance + tempdistance;
                   tempdistance = 0;
               end
               positions = newPos;
               
           case 'get'
               start = zeros(1,length(target));
               
               dofs = length(nonzeros(target));
               
               l = sqrt((5^2)/dofs);
               
               finish = abs(target) - (target~=0)*l; %Get shortest distance moving from start.
               %Perfect, incl Allowance.
               perfect = EuclidDist(finish,start);
               obj = perfect/distance;
       end 
    end
end