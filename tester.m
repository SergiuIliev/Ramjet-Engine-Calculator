%% Advanced Propulsion 2015 | V 2.0
%NAME: RamJet Calculator Tester
%GOAL: This script uses given reference inputs (from lecture 3) and varies the other parameters to plot the required graphs
%Created by: S.P.Iliev; A.Hirjanu | Date: 20.III.2015
%Imperial College London | Aeronautical Engineering | Dr David Birch | AE3-416

%% clean workspace
 clc                 %clear the window 
 clear               %clear variables
 close all           %close open figures
 
%% Reference Model 
P1=70000;           %--input-->Pa free-stream pressure (from 0km (1 Bar) to 25km (...K))
T1=210;             %--input-->°K free-stream temperature (from 0km (...K) to 86km (...K))
M1(1)=2.8;          %--input-->flight Mach number (1<M1<6)
Ms=1.1;             %--input-->normal shock strength (has to be >1 to prevent inlet unstart and close to 1 to get minimum stagnation pressure loss i.e. a very weak shock)
M2=0.2;             %--input-->burner entry Mach number (0> and <1)
Tb=1700;            %--input-->°K burner temperature limited by the melting point of the combustion chamber lining (1500<Tb<2000)
Thrust=50000;       %--input-->N required thrust (>0)

%Initialise all other parameters for the loop
A1=zeros;
A2=zeros;
AC2=zeros;
A4=zeros;
eta_thermal_cycle_real=zeros;
eta_propulsive = zeros;

%Call the main ramjet code to determine the first step and display all these values
[A1,AC1,A2,AC2,A4,eta_thermal_cycle_real,eta_propulsive] = ramjet (P1,T1,M1,Ms,M2,Tb,Thrust)

%% Creating the Plots
% This part varies the Mach number from 1 to 5.5 while keeping parameters constant as the reference
for i=1:450
    M1(i)=(100+i)/100;
    [A1(i),AC1(i),A2(i),AC2(i),A4(i),eta_thermal_cycle_real(i),eta_propulsive(i)] = ramjet (70000,210,M1(i),1.1,0.2,1700,50000);
end
 figure(1);
 hold all; grid on
 set(gca,'xtick',(0:1:6))  %define the spacing of the horizontal axis values to be displayed
 set(gca,'ytick',(0:0.1:1))%define the spacing of the vertical axis values to be displayed
 axis([1 7 0 1])           %format the axis range
 plot(M1,eta_propulsive,'b')
 plot(M1,eta_thermal_cycle_real,'r'); %plot the initial distribution in red
 ylabel('Efficiency'); xlabel('Flight Mach number, M1');%label the axis
 legend('Propulsive Efficiency', 'Thermal Cycle Efficiency')
 
 % This part is varying the atmosperic pressure between 0 and 1 bar. All the parameters are kept constant as the reference model
 for i=1:100000
     P1(i)=i;
     [A1(i),AC1(i),A2(i),AC2(i),A4(i),eta_thermal_cycle_real(i),eta_propulsive(i)] = ramjet (P1(i),210,2.8,1.1,0.2,1700,50000);
 end
figure(2)
hold all
plot(P1,eta_propulsive,'b')
plot(P1,eta_thermal_cycle_real,'r')
ylabel('Efficiency'); xlabel('Free-stream Pressure, P1 (Pa)');%label the axis
legend('Propulsive Efficiency', 'Thermal Cycle Efficiency')

% This part of the code free-stream temperature, T1 while keeping parameters constant as the reference
clear
k=0;
for i=201:289
    k=i-200; 
    T1(k)=i;
    [A1(k),AC1(k),A2(k),AC2(k),A4(k),eta_thermal_cycle_real(k),eta_propulsive(k)] = ramjet (70000,T1(k),2.8,1.1,0.2,1700,50000);
 end
figure(3)
hold all
plot(T1,eta_propulsive,'b')
plot(T1,eta_thermal_cycle_real,'r')
ylabel('Efficiency'); xlabel('Free-stream temperature, T1 (°K) ');%label the axis
legend('Propulsive Efficiency', 'Thermal Cycle Efficiency')

% This part of the code varies normal shock strength while keeping parameters constant as the reference
clear
k=0;
for i=1:0.001:1.8
    k=k+1; 
    Ms(k)=i;
    [A1(k),AC1(k),A2(k),AC2(k),A4(k),eta_thermal_cycle_real(k),eta_propulsive(k)] = ramjet (70000,210,2.8,Ms(k),0.2,1700,50000);
 end
figure(4)
hold all
plot(Ms,eta_propulsive,'b')
plot(Ms,eta_thermal_cycle_real,'r')
ylabel('Efficiency'); xlabel('Normal shock strength, Ms');%label the axis
legend('Propulsive Efficiency', 'Thermal Cycle Efficiency')

% This part of the code varies burner entry each number while keeping other parameters constant
clear
k=0;
for i=0:0.001:1
    k=k+1;
    M2(k)=i;
    [A1(k),AC1(k),A2(k),AC2(k),A4(k),eta_thermal_cycle_real(k),eta_propulsive(k)] = ramjet (70000,210,2.8,1.1,M2(k),1700,50000);
 end
figure(5)
hold all
ylabel('Efficiency'); xlabel('M2');%label the axis
plot(M2,eta_propulsive,'b')
plot(M2,eta_thermal_cycle_real,'r')
ylabel('Efficiency'); xlabel('Burner entry Mach number, M2');%label the axis
legend('Propulsive Efficiency', 'Thermal Cycle Efficiency')

% This part of the code varies burner temperature while keeping other parameters constant
clear
k=0;
for i=1500:2000
    k=i-1499;
    Tb(k)=i;
    [A1(k),AC1(k),A2(k),AC2(k),A4(k),eta_thermal_cycle_real(k),eta_propulsive(k)] = ramjet (70000,210,2.8,1.1,0.2,Tb(k),50000);
 end
figure(6)
hold all
ylabel('Efficiency'); xlabel('Tb');%label the axis
plot(Tb,eta_propulsive,'b')
plot(Tb,eta_thermal_cycle_real,'r')
ylabel('Efficiency'); xlabel('Burner Temperature, Tb (°K)');%label the axis
legend('Propulsive Efficiency', 'Thermal Cycle Efficiency')

% This part of the code varies required thrust while keeping other parameters constant
clear
k=0;
for i=0:100000
    k=k+1;
    Thrust(k)=i;
    [A1(k),AC1(k),A2(k),AC2(k),A4(k),eta_thermal_cycle_real(k),eta_propulsive(k)] = ramjet (70000,210,2.8,1.1,0.2,1700,Thrust(k));
 end
figure(7)
hold all
ylabel('Efficiency'); xlabel('Thrust');%label the axis
plot(Thrust,eta_propulsive,'b')
plot(Thrust,eta_thermal_cycle_real,'r')
ylabel('Efficiency'); xlabel('Thrust (N)');%label the axis
legend('Propulsive Efficiency', 'Thermal Cycle Efficiency')