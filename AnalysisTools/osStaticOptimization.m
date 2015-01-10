function [tool modelRef]=osStaticOptimization(model,toolOptions,analysesSetOptions)

%osStaticOptimization - Create an OpenSim Static Optimization Tool Object
%
%  Static Optimization is performed using the analysis tool.
%
%[tool modelRef]=osStaticOptimization(model,toolOptions,analysesSetOptions)
%
%       Inputs:
%               model - reference to an opensim model object or the name of
%                   a model file.
%
%               toolOptions - tool options to be set in the tool (see below
%                   for examples).  Use methodsview(tool) to see available
%                   options.  toolOptions.setCoordinatesFileName MUST be
%                   provided.
%
%               analysesSetOptions - analysis set options.  Can be a
%                   structure or an array of structures (1 entry per analysis
%                   in the analysis set.
%
%       Outputs:
%               tool - An Analysis object.  To run tool use:
%                   tool.run();
%
%               modelRef - a reference to the model.  needed if the model
%                   is opened from a file (if it is not returned to where
%                   tool.run() is executed, MATLAB will crash.
%
%Example of calling this function with some options:
%   import org.opensim.modeling.*
%   model='Arnold+50Lower_LumbarUpper_bar4x_SP125.osim';
%   toolOptions.setCoordinatesFileName='HULK_S10_SQP_L125_R01_Motion.mot';
%   toolOptions.setExcludedForces=ArrayStr('Muscles');
%   tool=osAnalysisTool(model,toolOptions,analysesSetOptions);
%
%Example Options (note that you normally use options.setStartTime(0);)
%   toolOptions.setCoordinatesFileName='MotFileToBeUsed.mot';
%   toolOptions.setStartTime=0;
%   toolOptions.setFinalTime=1;
%   toolOptions.setSolveForEquilibrium=false;
%   toolOptions.setName='AnalysisRun';
%   toolOptions.setExcludedForces=(ArrayStr('Muscles')); %Turn off all muscles
%   toolOptions.setUseVisualizer=false;
%
%   analysesSetOptions.setStartTime=0.3;
%   analysesSetOptions.setEndTime=1;
%
% To get a list of toolOptions:
%       import org.opensim.modeling.*
%       tool = AnalyzeTool('AnalysisFileExample.xml');
%       methodsview(tool)
%   To get a list of analysesSetOptions:
%       methodsview(tool.getAnalysisSet().get(0))

%---------------------------------------------
%Brad Humphreys 2014-12-26 v1.0
%---------------------------------------------



import org.opensim.modeling.*

toolTemplate='StaticOptimizationTemplate.xml';

if isempty(toolOptions)
    error('toolOptions must be provided');
else
    if ~isfield(toolOptions,'setCoordinatesFileName')
        error('toolOptions.setCoordinatesFileName must be provided');
    end
end


tool=osAnalysisTool(toolTemplate,toolOptions,analysesSetOptions);


%Add Model to the Tool
if ischar(model)  % Either Model Name or xml file is provided
    [pathstr,name,ext]=fileparts(model,[],[]);
    if strcmp(ext,'.osim')   % Only this option has extensively been tested
        modelRef = Model(model);
        tool.setModel(modelRef); 
    else
        error('Error: Input file should be a .osim or .xml')
    end
else  %Model is provided
    tool.setModel(model);
    modelRef = model;
end

analysis=tool.getAnalysisSet().get(0);

statOp=StaticOptimization();

s=statOp.safeDownCast(analysis);
s.setUseMusclePhysiology(1);


