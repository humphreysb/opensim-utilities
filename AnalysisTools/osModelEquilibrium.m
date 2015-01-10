function [osimModelFileOut controlsFileName statesFileName]=osModelEquilibrium(osimModelName,taskSetFileName)

% Load Library
import org.opensim.modeling.*;

%osimModelName='OpenSimModels/Arm26WithDelts/Arm28_Optimize.osim';

% Open a Model by name
osimModel = Model(osimModelName);
% Don't use the visualizer (must be done before the call to init system)
osimModel.setUseVisualizer(false);

%Lock coordiantes
[osimModel,defLocked]=osSetCoordLock(osimModel,1);

%Generate motion file and get muscle lengths
%Run a forward analysis
[fTool,osimModel]=osForwardDynamics(osimModel);
fTool.setStartTime(0);
fTool.setFinalTime(1);
fName=['tempFor_' datestr(now,30)];
fTool.setName(fName);
fTool.run();

% Load the results
fixedCoordsFileName=[fName '_states.sto'];
%[data,columnNames,isInDegrees]=osLoadMotFile(fixedCoordsFileName);

% Reopen the orginal model (to revert to model with correct locked coords)
osimModel = Model(osimModelName);
osimModel.setUseVisualizer(false);
options.setTimeWindow=0.5;
options.setDesiredKinematicsFileName=fixedCoordsFileName;
%options.setTaskSetFileName='arm26_ComputedMuscleControl_Tasks.xml';
options.setTaskSetFileName=taskSetFileName;
soName=['tempSo_' datestr(now,30)];
options.setName=soName;

% Run CMC to get control values
[cmcTool]=osCmc(osimModel,options);
cmcTool.run();
[data,columnNames,isInDegrees,stoDb]=osLoadMotFile([soName '_states.sto']);


osimModel = Model(osimModelName);
osimModel.setUseVisualizer(false);
osimModel=osSetMuscleDefaultActAndLength(osimModel,stoDb);


[pathstr,mName,ext]=fileparts(osimModelName);

osimModelFileOut=[mName '_Equib.osim'];
osimModel.print(osimModelFileOut);

%Clean up files
delete([fName '_states.sto']);
delete([fName '_states_degrees.mot']);
delete([fName '_controls.sto']);

delete([soName '_Actuation_force.sto']);
delete([soName '_Actuation_power.sto']);
delete([soName '_Actuation_speed.sto']);
delete([soName '_controls.xml']);
delete([soName '_Kinematics_dudt.sto']);
delete([soName '_Kinematics_q.sto']);
delete([soName '_Kinematics_u.sto']);
delete([soName '_pErr.sto']);

controlsFileName=[soName '_controls.sto'];
statesFileName=[soName '_states.sto'];
