

function osUpdateModelCoordsWithMotData(Model_In, Mot_In, Model_Out)

% DEVELOPMENT - NOT COMPLETE
%
% osUpdateModelCoordsWithMotData - function that takes a model and updates
% the generalized coordinates to the values from a mot file at each time
% step.  This seems to be very slow because of the setValue command and
% needs further thought.  I think I need to use MATLAB's integrator to make
% this work. 

import org.opensim.modeling.*

% Argument checking
error(nargchk(0, 3, nargin));

% If there aren't enough arguments passed in system will ask user to
% manually select file(s)

if nargin < 1
    [Model_In, modelpath] = uigetfile('.osim', 'Please select a model file');
    [Mot_In, motpath] = uigetfile('.mot', 'Please select a motion file');
    fileoutpath = [Model_In(1:end-5),'_Prescribed.osim'];
    modelfilepath = [modelpath Model_In];
    motfilepath = [motpath Mot_In];
elseif nargin < 2
    [Mot_In, motpath] = uigetfile('.mot', 'Please select a motion file');
    fileoutpath = [Model_In(1:end-5),'_Prescribed.osim'];
    motfilepath = [motpath Mot_In];
    modelfilepath = Model_In;
elseif nargin < 3
    fileoutpath = [Model_In(1:end-5),'_Prescribed.osim'];
    modelfilepath = Model_In;
    motfilepath = Mot_In;
else
    modelfilepath = Model_In;
    motfilepath = Mot_In;
    fileoutpath = Model_Out;
end

% Initialize model
osimModel=Model(modelfilepath);

% Create the coordinate storage object from the input .sto file
coordinateSto=Storage(motfilepath);

% Rename the modified Model
osimModel.setName('modelWithPrescribedMotion');

% get coordinate set from model, and count the number of coordinates
modelCoordSet = osimModel.getCoordinateSet();
nCoords = modelCoordSet.getSize();

Time=ArrayDouble();
coordinateSto.getTimeColumn(Time);
% for all coordinates in the model, create a function and prescribe

for i=0:nCoords-1
    % construct ArrayDouble objects for time and coordinate values
    coordvalue{i+1} = ArrayDouble();
    % Get the coordinate set from the model
    currentcoord = modelCoordSet.get(i);
    % Get the Coordinate values  - The coordinate values are held in
    % coordvalue
    coordinateSto.getDataColumn(currentcoord.getName(),coordvalue{i+1});    
    % Check if it is a rotational or translational coordinate
    motion{i+1} = currentcoord.getMotionType();

end


%Get a state to modify
si=osimModel.initSystem(); 

numTimePoints=size(coordvalue{1});

for nt=0:numTimePoints-1 %Loop through the Time points
    for i=0:nCoords-1   %Loop theough the coordinates
        
        %Update the coordinates  (this just does the coordinates, also need
        %to do the speeds
        valueOfCoord=coordvalue{i+1}.get(nt);
       osimModel.getCoordinateSet().get(i).setValue(si,valueOfCoord);
    end
end

aaa=1;