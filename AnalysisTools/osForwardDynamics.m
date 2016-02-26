function [tool,model]=osForwardDynamics(model,options)


%osForwardDynamics - Create an OpenSim Forward Dynamics Tool Object
%
%tool=osForwardDynamics(model,options)
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
%               tool - A Forward Dynamics object.  To run tool use:
%                   tool.run();
%
%               model - a reference to the model.  Needed if the model
%                   is opened from a file.  THIS OUTPUT SHOULD BE RETURNED.
%
%       If tool.run() crashes, it is probably because you did not return
%           model as an output argument from this function.  you should
%           always return it.
%
%Example of calling this function with some options:
%   import org.opensim.modeling.*
%   model='pendulumWithController.osim';
%   options.setControlsFileName='TonPendtrols.sto';
%   options.setFinalTime=tStop;
%   options.setInitialTime=0;
%   options.setName='RunWithPendTorques'
%
%  to get available Options fo the following:
%     On MATLAB cmd line:
%           import org.opensim.modeling.*
%           tool=ForwardTool();
%       Then use tab completeion: tool.
%
%
%Comments on the Forward Tool:
%   1) FD internally calls initSystem(). So to specify a starting to state,
%   you need to either set the default values or use an initialStatesFile


%---------------------------------------------
%Brad Humphreys 2014-12-26 v1.0
%---------------------------------------------

%---------------------------------------------
%Brad Humphreys 2015-9-11 v1.0
% works with OpenSim 3.3
%---------------------------------------------



import org.opensim.modeling.*


if ischar(model)  % Either Model Name or xml file is provided
    [pathstr,name,ext]=fileparts(model);
    if strcmp(ext,'.osim')
        model = Model(model);
        tool = ForwardTool();
        tool.setModel(model);
    elseif strcmp(ext,'.xml')
        tool = ForwardDynamicsTool(model);
    else
        error('Error: Input file should be a .osim or .xml')
    end
    
else  %Model is provided
    tool = ForwardTool();
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


aaaa=1;
