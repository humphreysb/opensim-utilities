function [osimModel]=osSetMuscleDefaultActAndLength(osimModel,stoDb,n)

% Load Library
import org.opensim.modeling.*;

if nargin<3
    n=1;
end

numMuscles=osimModel.getMuscles().getSize();
for i=0:numMuscles-1
    muscle=osimModel.getMuscles.get(i);   %Get the muscle and it's name
    muscleName=char(muscle.getName());
    if isfield(stoDb,muscleName)  %Check make sure that the muscle is in the database
        
        
        if isfield(stoDb.(muscleName),'length')
            switch char(muscle.getConcreteClassName)
                case 'Thelen2003Muscle'
                    m=Thelen2003Muscle.safeDownCast(muscle);
                    m.setDefaultFiberLength(stoDb.(muscleName).length(n));
                otherwise
                    warning(['Muscle: ' muscleName ' default length not being set (unknown muscle type).']);
            end
        else
            warning(['Muscle : ' muscleName ' default length is not being set (length value can not be found).'])
        end
        
        if isfield(stoDb.(muscleName),'activation')
            switch char(muscle.getConcreteClassName)
                case 'Thelen2003Muscle'
                    m=Thelen2003Muscle.safeDownCast(muscle);
                    m.setDefaultActivation(stoDb.(muscleName).activation(n));
                otherwise
                    warning(['Muscle: ' muscleName ' activation not being set (unknown muscle type).']);
            end
        else
            warning(['Muscle : ' muscleName ' default activation is not being set (activation value can not be found).'])
        end
        
    else
        warning(['Muscle: ' muscleName ' was not found in the file; it is being skipped.'])
    end
    
    
    
    
end


numCoords=osimModel.getCoordinateSet().getSize();

for i=0:numCoords-1
    coord=osimModel.getCoordinateSet().get(i);   %Get the muscle and it's name
    coordName=char(coord.getName());
    if isfield(stoDb,coordName)  %Check make sure that the muscle is in the database
        
        
        if isfield(stoDb.(coordName),'q')
            osimModel.getCoordinateSet().get(i).setDefaultValue(stoDb.(coordName).q(n));
        else
            warning(['Coord : ' coordName ' default value is not being set (value can not be found).'])
        end
        if isfield(stoDb.(coordName),'u')
            osimModel.getCoordinateSet().get(i).setDefaultSpeedValue(stoDb.(coordName).u(n));
        else
            warning(['Coord : ' coordName ' default speed is not being set (speed value can not be found).'])
        end
        
        
    else
        warning(['Coord: ' coordName ' was not found in the file; it is being skipped.'])
    end
    
    
end
