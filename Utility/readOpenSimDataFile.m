function data=readOpenSimDataFile(fileName)

%readOpenSimDataFile - read a results file from OpenSim. This function
%automatically adjusts for the variable header in OpenSim files.
%
%
%data=readOpenSimDataFile(fileName)
%
%       Inputs:
%               fileName - File name of OpenSim results
%
%       Outputs:
%               data  - structure with data from file
%

%---------------------------------------------
%Brad Humphreys 2013-4-11 v1.0
%---------------------------------------------

fid=fopen(fileName);

fline=fgetl(fid);
data.header.ftype=fline;

fline=fgetl(fid);
data.header.version=pVal(fline);

fline=fgetl(fid);
data.header.rows=pVal(fline);

fline=fgetl(fid);
data.header.cols=pVal(fline);

fline=fgetl(fid);
data.header.inDegrees=pVal(fline);

lCnt=6;

while ~strcmp(fline,'endheader')
    fline=fgetl(fid);
    lCnt=lCnt+1;
end



varNames=fgetl(fid);
varNames=strsplit(varNames);

lCnt=lCnt+1;

fclose(fid);

d=importdata(fileName,' ',lCnt);
d=d.data;

for i=1:size(d,2)
    vName=strrep(varNames{i},'.','_');
    vName=strrep(varNames{i},'_','');
    data.(vName)=d(:,i);
end



function val=pVal(fline)
i=strfind(fline,'=');
if max(size(i)>1) | max(size(i)<1)
    error(['Expected format: propName=0.  Got:  ' fline]);
end

val=fline(i+1:end);
val=str2num(val);


