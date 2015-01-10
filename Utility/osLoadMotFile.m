function [data,columnNames,isInDegrees,stoDb]=osLoadMotFile(filename)

%osLoadMotFile - Load an Opensim motion file via the OpenSim API.
%   This function does not parse the text file, but uses OpenSim to open
%   and parse the file.
%
%
%[data,columnNames,isInDegrees]=osLoadMotFile(filename)
%
%       Inputs:
%               filename - .mot file to be imported
%
%       Outputs:
%               data - array with motion data
%               columnNames - cell array with labels for each column
%               inInDegrees - 1 if angular measurements in degrees
%
%   See also osLoadMotFile

%---------------------------------------------
%Brad Humphreys 2014-12-10 v1.0
%---------------------------------------------

% Load Library
import org.opensim.modeling.*;


% Create the coordinate storage object from the input .sto file
coordinateSto=Storage(filename);

columnLabels=coordinateSto.getColumnLabels;
numCol=size(columnLabels);

isInDegrees=coordinateSto.isInDegrees;

% for all coordinates in the model, create a function and prescribe
for i=0:numCol-1
    
    columnNames{i+1}=char(columnLabels.get(i));
    coordvalue = ArrayDouble();
    
    
    if strcmp(columnNames{i+1},'time')  % have to use getTimeColumn or
        % you get the wrong values
        coordinateSto.getTimeColumn(coordvalue);
    else  %For all others, use getDataColumn
        coordinateSto.getDataColumn(columnLabels.get(i),coordvalue);
    end
    
    % Loop through and write to MATLAB array (need to find a better way to
    % do this.  also, should probably preallocate data, but array is small
    for j=0:size(coordvalue)-1
        data(j+1,i+1)=coordvalue.get(j);
    end
    
end

if nargout>3
    for i=1:length(columnNames)
        if strendswith(columnNames{i},'.fiber_length')
            fieldName=strrep(columnNames{i},'.fiber_length','');
            stoDb.(fieldName).length=data(:,i);
        elseif strendswith(columnNames{i},'.activation')
            fieldName=strrep(columnNames{i},'.activation','');
            stoDb.(fieldName).activation=data(:,i);
        elseif strendswith(columnNames{i},'_u')
            fieldName=strrep(columnNames{i},'_u','');
            stoDb.(fieldName).u=data(:,i);
        elseif strendswith(columnNames{i},'time')
            stoDb.time=data(:,i);
        else
            fieldName=columnNames{i};
            stoDb.(fieldName).q=data(:,i);
        end
    end
end