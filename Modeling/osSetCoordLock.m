function [osimModel,defLocked]=osSetCoordLock(osimModel,lock)

% Load Library
import org.opensim.modeling.*;

%Get the number of coordiantes in model
numCoords=osimModel.getCoordinateSet().getSize();

%If lock is a scaler set all of the coordiante locks to lock value
if numCoords~=length(lock)
    if length(lock)==1
        lock(1:numCoords)=lock;
    else
        error('The number of coordinates and the number of lock settings are not equal.')
    end
end

%Loop through the coords and set lock value
for c=0:numCoords-1
    coord=osimModel.getCoordinateSet().get(c);
    defLocked(c+1)=coord.getDefaultLocked();
    coord.setDefaultLocked(lock(c+1));
end


