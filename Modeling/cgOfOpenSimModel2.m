function tool=osAnalysisTool(model,options)

%osAnalysisTool - Create an OpenSim Analysis Tool Object
%
%tool=osAnalysisTool(model,options)
%
%       Inputs:
%               model - reference to an opensim model object or the name of
%                   a model file.
%
%               options - tool options to be set in the tool (see below
%                   for examples).  Use methodsview(tool) to see available
%                   options.
%
%       Outputs:
%               tool - An Analysis object.  To run tool use:
%                   tool.run();
%
%Example of calling this function with some options:
%   import org.opensim.modeling.*
%   model='Arnold+50Lower_LumbarUpper_bar4x_SP125.osim';
%   options.setCoordinatesFileName='HULK_S10_SQP_L125_R01_Motion.mot';
%   options.setExcludedForces=ArrayStr('Muscles'); 
%   tool=osInverseDynamics(model,options)
%
%Example Options (note that you normally use options.setStartTime(0);)
%   options.setCoordinatesFileName='MotFileToBeUsed.mot';
%   options.setStartTime=0;
%   options.setFinalTime=1;
%   options.setSolveForEquilibrium=false;
%   options.setName='InverseDynamicsRun';
%   options.setExcludedForces=(ArrayStr('Muscles')); %Turn off all muscles
%   options.setUseVisualizer=false;
%

%---------------------------------------------
%Brad Humphreys 2014-12-15 v1.0
%---------------------------------------------


if ischar(model)  % Either Model Name or xml file is provided
    [pathstr,name,ext]=fileparts(model);
    if strcmp(ext,'.osim')
        osimModel = Model(model);
        tool = AnalysisTool();
        tool.setModel(osimModel);
    elseif strcmp(ext,'.xml')
        tool = AnalysisTool(model);
    else
        error('Error: Input file should be a .osim or .xml')
    end
    
else  %Model is provided
    tool = AnalysisTool();
    tool.setModel(model);
end

%Loop through the options and call the set methods
if nargin>1
    fNames=fieldnames(options);
    for i=1:length(fNames)
        %tool.(fNames{i})=options.(fNames{i});
        eval(['tool.' fNames{i} '(options.(fNames{i}));']);
    end
end


