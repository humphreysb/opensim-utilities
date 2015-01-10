function outPutFileNames=osCgOfModel(modelFile,motFile)


import org.opensim.modeling.*
% modelFile='Arnold+50Lower_LumbarUpper_bar4x_SP125.osim';
% motFile='HULK_S10_SQP_L125_R01_Motion.mot';

[pathstr,modelFilename,ext]=fileparts(modelFile);
[pathstr,motFilename,ext]=fileparts(motFile);

% Initialize model
osimModel=Model(modelFile);

[startTime,stopTime]=osMotFileTime(motFile);

nameOfModel=[modelFilename '_' motFilename];

toolOptions.setName=nameOfModel;
%toolOptions.setCoordinatesFileName='HULK_S10_SQP_L125_R01_Motion.mot';
toolOptions.setCoordinatesFileName=motFile;
toolOptions.setStartTime=startTime;
toolOptions.setFinalTime=stopTime;

analysesSetOptions.setName='BodyKinematics';
analysesSetOptions.setInDegrees=1;
analysesSetOptions.setStartTime=startTime;
analysesSetOptions.setEndTime=stopTime;

[tool,osimModel]=osAnalysisTool(osimModel,toolOptions,analysesSetOptions);
tool.run();

outPutFileNames{1}=[nameOfModel '_BodyKinematics_pos_global.sto'];
outPutFileNames{2}=[nameOfModel '_BodyKinematics_vel_global.sto'];
outPutFileNames{3}=[nameOfModel '_BodyKinematics_acc_global.sto'];

%[data,columnNames,isInDegrees]=osLoadMotFile(outPutFileNames{1});
si=osimModel.initSystem();
totalMass=osimModel.getTotalMass(si);