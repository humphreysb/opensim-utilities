
function [j,m,osimModel,osimState]=getModelData(osimModel,osimState)

%getModelData - Get joint and muscle data from a model and state. Put it
%   in a easy to read structure
%
%
%[j m osimModel,osimState]=getModelData(osimModel,osimState)
%
%       Inputs:
%               osimModel - model to be read
%               osimState - sate to be used
%
%       Outputs:
%               j - joint structure. see field descriptions
%               m - muscle structure. see field descriptions
%               osimModel & state - repeat out
%
%
%Notes:
%	   fiber length is just the contractilce elment (no tendon)
%       muscle length is tendon and muscle


%---------------------------------------------
%Brad Humphreys 2016-2-26 v1.0
%---------------------------------------------


% Load Library
import org.opensim.modeling.*;

nJoints=osimModel.getCoordinateSet().getSize();
nMuscles=osimModel.getMuscles().getSize();

for i=1:nJoints
    j(i).coordName=char(osimModel.getCoordinateSet().get(i-1).getName());
    j(i).coordAccelValue=osimModel.getCoordinateSet().get(i-1).getAccelerationValue(osimState);  %Joint Accelerations
    j(i).coordValue=osimModel.getCoordinateSet().get(i-1).getValue(osimState);  %Joint Angle
    j(i).coordSpeedValue=osimModel.getCoordinateSet().get(i-1).getSpeedValue(osimState);  %Joint Speed  
end

for i=1:nMuscles

    m(i).Name=char(osimModel.getMuscles().get(i-1).getName());
    
    m(i).Activation=osimModel.getMuscles().get(i-1).getActivation(osimState);
    m(i).Control=osimModel.getMuscles().get(i-1).getControl(osimState);
    
    m(i).Force=osimModel.getMuscles().get(i-1).getForce(osimState);   
    m(i).FiberForce=osimModel.getMuscles().get(i-1).getFiberForce(osimState);
    m(i).PassiveFiberForce=osimModel.getMuscles().get(i-1).getPassiveFiberForce(osimState);
    m(i).ActiveFiberForce=osimModel.getMuscles().get(i-1).getActiveFiberForce(osimState);
    m(i).TendonForce=osimModel.getMuscles().get(i-1).getTendonForce(osimState);
    m(i).ActiveFiberForceAlongTendon=osimModel.getMuscles().get(i-1).getActiveFiberForceAlongTendon(osimState);
    m(i).PassiveFiberForceAlongTendon=osimModel.getMuscles().get(i-1).getPassiveFiberForceAlongTendon(osimState);
    
    m(i).Length=osimModel.getMuscles().get(i-1).getLength(osimState);   %Muscle Length (tendon and Muscle Fiber
    m(i).TendonLength=osimModel.getMuscles().get(i-1).getTendonLength(osimState);
    m(i).FiberLengthAlongTendon=osimModel.getMuscles().get(i-1).getFiberLengthAlongTendon(osimState);
    m(i).FiberLength=osimModel.getMuscles().get(i-1).getFiberLength(osimState);
    m(i).PennationAngle=osimModel.getMuscles().get(i-1).getPennationAngle(osimState);
    
    m(i).LengtheningSpeed=osimModel.getMuscles().get(i-1).getLengtheningSpeed(osimState);
    m(i).FiberVelocity=osimModel.getMuscles().get(i-1).getFiberVelocity(osimState);   %Lce Velocity
    m(i).FiberVelocityAlongTendon=osimModel.getMuscles().get(i-1).getFiberVelocityAlongTendon(osimState);   %Lce Velocity
    m(i).TendonVelocity=osimModel.getMuscles().get(i-1).getTendonVelocity(osimState);
    
end