function [tool modelRef]=osAnalysisTool(model,toolOptions,analysesSetOptions)

%osAnalysisTool - Create an OpenSim Analysis Tool Object
%
%tool=osAnalysisTool(model,options)
%
%       Inputs:
%               model - reference to an opensim model object or the name of
%                   a model file.
%
%               toolOptions - tool options to be set in the tool (see below
%                   for examples).  Use methodsview(tool) to see available
%                   options.
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
%Brad Humphreys 2014-12-15 v1.0
%---------------------------------------------

import org.opensim.modeling.*


toolTemplate='AnalysisFileExample.xml';

if ischar(model)  % Either Model Name or xml file is provided
    [pathstr,name,ext]=fileparts(model);
    if strcmp(ext,'.osim')   % Only this option has extensively been tested
        modelRef = Model(model);
        tool = AnalyzeTool(toolTemplate);
        tool.setModel(modelRef);
        
    elseif strcmp(ext,'.xml')
        tool = AnalyzeTool(model);
        modelRef = '';
    else
        error('Error: Input file should be a .osim or .xml')
    end
else  %Model is provided
    tool = AnalyzeTool(toolTemplate);
    tool.setModel(model);
    modelRef = model;
end

%Loop through the options and call the set methods
if ~isempty(toolOptions)
    fNames=fieldnames(toolOptions);
    for i=1:length(fNames)
        %tool.(fNames{i})=options.(fNames{i});
        eval(['tool.' fNames{i} '(toolOptions.(fNames{i}));']);
    end
end

%Assign analysis options parameters
if ~isempty(analysesSetOptions)
    
    % Handle if analysesSetOptions is not a cell array (1 analysis)
    if ~iscell(analysesSetOptions)
        temp=analysesSetOptions;
        clear analysesSetOptions
        analysesSetOptions{1}=temp;
    end
    
    numAnalyses=length(analysesSetOptions);
    for aCnt=0:numAnalyses-1
        options=analysesSetOptions{aCnt+1};
        fNames=fieldnames(options);
        for i=1:length(fNames)
            %tool.getAnalysisSet().get(aCnt).(fNames{i})=options.(fNames{i});
            eval(['tool.getAnalysisSet().get(' num2str(aCnt) ').' fNames{i} '(options.(fNames{i}));']);
        end
    end
end
