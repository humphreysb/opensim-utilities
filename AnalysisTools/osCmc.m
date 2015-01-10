function [tool,model]=osForwardDynamics(model,options)


import org.opensim.modeling.*

toolTemplate='StaticOptimizationTemplate.xml';

if isempty(options)
    error('toolOptions must be provided');
else
    if ~isfield(options,'setDesiredKinematicsFileName')
        error('toolOptions.setDesiredKinematicsFileName must be provided');
    end
    if ~isfield(options,'setTaskSetFileName')
        error('toolOptions.setTaskSetFileName must be provided');
    end
end

tool=CMCTool();

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


%Loop through the options and call the set methods
if nargin>1
    fNames=fieldnames(options);
    for i=1:length(fNames)
        %tool.(fNames{i})=options.(fNames{i});
        eval(['tool.' fNames{i} '(options.(fNames{i}));']);
    end
end