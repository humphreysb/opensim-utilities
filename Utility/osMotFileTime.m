function [startTime,stopTime,coordinateSto]=osMotFileTime(filename)

%osMotFileTime - Get the first and last time in an Opensim motion file.
%
%[startTime stopTime coordinateSto]=osMotFileTime(filename)
%
%       Inputs:
%               filename - .mot file to be imported
%
%       Outputs:
%               startTime - First Time in motion file
%               stopTime - Last time in motion file.
%               coordinateSto - reference to the motion file

%---------------------------------------------
%Brad Humphreys 2014-12-23 v1.0
%---------------------------------------------


% Load Library
import org.opensim.modeling.*;

% Create the coordinate storage object from the input .sto file
coordinateSto=Storage(filename);

startTime=coordinateSto.getFirstTime();
stopTime=coordinateSto.getLastTime();

