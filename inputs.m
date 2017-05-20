%% Advanced Propulsion 2015 | V 2.0
%NAME: RamJet Calculator Main Run Script - user interactive
%GOAL: This is the main script that needs to run in order to start the program it demands the input values and suggests bounds, then calculates required outputs 
%Created by: A.Ranjan | Date: 20.III.2015
%Imperial College London | Aeronautical Engineering | Dr David Birch | AE3-416

%% Inputs
%Receive inputs using the function takeinput, by passing to it the
%description of the variable and the lower and upper ranges
P1=takeinput('Free-Stream Pressure (Bar)',0.025,0.4854);    %--input-->Pa free-stream pressure (from 0km (1 Bar) to 25km (...K)) %--input-->Pa free-stream pressure (from 0km (1 Bar) to 25km (...K))
T1=takeinput('Free-Stream Temperature (K)',216.65,271.65);  %--input-->°K free-stream temperature (from 0km to 25km assuming ground temperature offset of +-50°)
M1(1)=takeinput('Flight Mach Number',1,6);          %--input-->flight Mach number (1<M1<6)
Ms=takeinput('Normal Shock Strength',1,inf);        %--input-->normal shock strength (has to be >1 to prevent inlet unstart and close to 1 to get minimum stagnation pressure loss i.e. a very weak shock)
M2=takeinput('Burner Entry Mach Number',0,1);       %--input-->burner entry Mach number (0> and <1)
Tb=takeinput('Burner Temperature (K)',1500,2000);   %--input-->°K burner temperature limited by the melting point of the combustion chamber lining (1500<Tb<2000)
Thrust=takeinput('Thrust (N)',0,inf);               %--input-->N required thrust (>0)