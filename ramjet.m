function [A1,AC1,A2,AC2,A4,eta_thermal_cycle_real,eta_propulsive] = ramjet (P1,T1,M1,Ms,M2,Tb,Thrust)
%% Advanced Propulsion 2015 | V 2.2
%NAME: RamJet Calculator
%GOAL: Analyses the variation of propulsive and termodynamic efficiency with various input parameters
%Created by: S.P.Iliev; A.Hirjanu | Date: 20.III.2015
%Imperial College London | Aeronautical Engineering | Dr David Birch | AE3-416

%% Initialize global parameters
R=287;     %m^2/s^2*K universal gass constant
gamma=1.4; %assuming pure fuel-air mixture %assuming this is constant thoughout, which is not, really, as it varies as the fuel is burned and temperature increases
a1=sqrt(gamma*R*T1);%local speed of sound of incoming flow
U1=M1*a1;           %flight speed


%% Chosing the combustion fuel as H2
%OBS Transit through the engine is too fast for heat transfer so the thermodynamic cycle can be assumed adiabatic
%Due to its high heat of reaction and because it we assume there is no heat transfer to the wall (due to the high mass flow rate). It is worth mentioning that using H2 will require pressurised or cryogenic fuel tanks.
%OBS H2 can be either circulated to ensure sufficient cooling to prevent the engine from melting, or it can be used for pre-cooling to decrease burner intake temperature and increase thermal efficiency
q=119954;           %kJ/kg_fuel heat of reaction
f_FA=2.91/100;      %Stoichiometric fuel/air r atio = m_dot_f/m_dot_a
C=14.32;            %kJ/kg K assuming pure fuel and assuming it is constant throughout


%% Ramjet intake
A1_over_AC1star=(1/M1)*((2/(gamma+1))*(1+M1^2*(gamma-1)/2))^((gamma+1)/(2*(gamma-1)));  %inlet area ratio to choke - needed to relate the area ratio between inlet and ct area burner
T1_over_T0x=1/(1+((gamma-1)/2)*M1^2);                                                   %intake flow static to total temperature ratio, for M1 - needed to relate the temperature ratio between inlet and ct area burner


%% Determining combustion chamber parameters
%Normal shock relations for finding the conditions after the inlet shock
My=sqrt(((gamma-1)*Ms^2+2)/(2*gamma*Ms^2-(gamma-1)));                                   %Mach number after the shock, at station y
Ty_over_Tx=((2*gamma*Ms^2-(gamma-1))*(2+(gamma-1)*Ms^2))/((gamma+1)^2*Ms^2);            %ratio of static temperatures before and after the shock
Ty_over_T0y=1/(1+((gamma-1)/2)*My^2);                                                   %static to total temperature ratio for My
Ax_over_Aystar=(1/My)*((2/(gamma+1))*(1+My^2*(gamma-1)/2))^((gamma+1)/(2*(gamma-1)));   %area ratio to choke before shock, for My
Tx_over_T0x=1/(1+((gamma-1)/2)*Ms^2);                                                   %static to total temperature ratio for Ms
Ax_over_AC1star=(1/Ms)*((2/(gamma+1))*(1+Ms^2*(gamma-1)/2))^((gamma+1)/(2*(gamma-1)));  %area ratio to choke before shock, for Ms
%Note that T0x=T0s=T01 (static temperature remains constant before the shock as there is no heat addition)
%Note that Ax=Ay (the shock width is assumed infinitesimally small)

%Assuming isentropic flow from after the shock to 2, where the constant-area compressor starts
A2_over_Aystar=(1/M2)*((2/(gamma+1))*(1+M2^2*(gamma-1)/2))^((gamma+1)/(2*(gamma-1)));   %area ratio to choke after shock, for M2 (it is important to note this changes)
T2_over_T0y=1/(1+((gamma-1)/2)*M2^2);                                                   %static to total temperature ratio, for M2
P2_over_P02=(1+((gamma-1)/2)*M2^2)^-(gamma/(gamma-1));                                  %static to total pressure ratio, for M2
A2_over_A1=A2_over_Aystar/Ax_over_Aystar*Ax_over_AC1star/A1_over_AC1star;               %relating inlet area (1) to ct area burner (2)
T2_over_T1=T2_over_T0y/Ty_over_T0y*Ty_over_Tx*Tx_over_T0x/T1_over_T0x;                  %relating inlet temperature (1) to ct area burner entry temperature (2)
T2=T1*T2_over_T1;                                                                       %K temperature at the start of the ct area burner, just before the flameholders

%Finding the pressure at b
P1_over_P0x=(1+((gamma-1)/2)*M1^2)^((-gamma)/(gamma-1));                                %isentropic relationship
P0y_over_P0x=((2*gamma*Ms^2-(gamma-1))/(gamma+1))^(-1/(gamma-1))*(((gamma+1)*Ms^2)/(2+(gamma-1)*Ms^2))^(gamma/(gamma-1));    %normal shock relationship
P2_over_P0y=(1+((gamma-1)/2)*M2^2)^((-gamma)/(gamma-1));                                %isentropic relationship
P2_over_P1=P2_over_P0y*P0y_over_P0x/P1_over_P0x;
Pb=P1*P2_over_P1;                                                                       %Pa - burner pressure

Mb=M2*sqrt(Tb/T2);
Ab_over_AC2=(1/Mb)*((2/(gamma+1))*(1+Mb^2*(gamma-1)/2))^((gamma+1)/(2*(gamma-1)));      %area ratio to choke after combustion
Tb_over_T0b=1/(1+((gamma-1)/2)*Mb^2);                                                   %static to total temperature ratio for Mb
AC2_over_A1=A2_over_A1/Ab_over_AC2;                                                     %area relation between intake (1) and nozzle inlet (C2)

%% Ramjet exhaust
Pb_over_Pob=(1+((gamma-1)/2)*Mb^2)^((-gamma)/(gamma-1));                                %static to total pressure ratio, for Mb
P4_over_Pob=(P2_over_P1^-1)*Pb_over_Pob;
T4_over_Tob=P4_over_Pob^((gamma-1)/gamma);
T0b_over_Tb=(1+((gamma-1)/2)*Mb);
T4_over_Tb=T4_over_Tob*T0b_over_Tb;
M4=sqrt((T4_over_Tob^(-1)-1)*2/(gamma-1));
A4_over_AC2=((1 + M4^2 * (gamma-1)/2)^((gamma+1)/(gamma-1)/2))*(((gamma+1)/2)^-((gamma+1)/(gamma-1)/2)) / M4 ;
U4=M4*sqrt(gamma*R*T4_over_Tb*Tb);                                                      %This is where we find the exhaust velocity
A4_over_A1=A4_over_AC2*AC2_over_A1;                                                     %From this relationship we find the exhaust Area
A1=Thrust*(P1*gamma*M1^2*((M4^2/M1^2)*A4_over_A1 - 1))^-1; 
A2=A2_over_A1*A1;

%% In order to calculate the real efficiency, we need to recalculate Mb after finding A2
%Assuming all heat q is added instantaneously at b and temperature instantaneusly increases from T2 (obtained above) to Tb (input)
mf=C*(Tb-T2)/q;       %kg fuel added to raise the temperature
rho_f=mf/A2;        %fuel density/unit length - can find this only when I know an Area A1 that can be related with the ratio above A2=Ab=Ac
%OBS Conservation of mass can relate any two stations in the engine; here we assume the flameholders do not have a significant cross-section, this is a reasonable assumption, at this point the type of burner that is going to be used is unknown, thus its sectional area contribution cannot be quantified at this point.

%Assuming that pressure remains the same throughout the burner in order tobe able to use the Brayton cycle i.e. Pb=P2
Mb=M2*sqrt(Tb/(T2+rho_f/(R*Pb)));   %assuming mass of fuel addition does not vary with time (steady flow combustion) and that the area is constant i.e. A2=Ab=Ac
%OBS Due to real effects i.e. boundary layer growth, the constant area section should appear to the flow as a mildly convergent duct - this could be accounted for in the code
Ab_over_AC2=(1/Mb)*((2/(gamma+1))*(1+Mb^2*(gamma-1)/2))^((gamma+1)/(2*(gamma-1)));      %area ratio to choke after combustion
Tb_over_T0b=1/(1+((gamma-1)/2)*Mb^2);                                                   %static to total temperature ratio for Mb
AC2_over_A1=A2_over_A1/Ab_over_AC2;                                                     %area relation between intake (1) and nozzle inlet (C2)
Pb_over_Pob=(1+((gamma-1)/2)*Mb^2)^((-gamma)/(gamma-1));
P4_over_Pob=(P2_over_P1^-1)*Pb_over_Pob;
T4_over_Tob=P4_over_Pob^((gamma-1)/gamma);
T0b_over_Tb=(1+((gamma-1)/2)*Mb);
T4_over_Tb=T4_over_Tob*T0b_over_Tb;
M4=sqrt((T4_over_Tob^(-1)-1)*2/(gamma-1));
A4_over_AC2=((1 + M4^2 * (gamma-1)/2)^((gamma+1)/(gamma-1)/2))*(((gamma+1)/2)^-((gamma+1)/(gamma-1)/2)) / M4 ;
U4=M4*sqrt(gamma*R*T4_over_Tb*Tb);                                                      %This is where we find the exhaust velocity
A4_over_A1=A4_over_AC2*AC2_over_A1;                                                     %From this relationship we find the exhaust Area

%% Outputs
% To find the area I need to know the nozzle parameters that stem from the thrust requirements
% Since Thrust and atmospheric pressure are known, Inlet area A1 can be found
A1=Thrust*(P1*gamma*M1^2*((M4^2/M1^2)*A4_over_A1 - 1))^-1; 
AC1=(A1_over_AC1star)^-1*A1;
A2=A2_over_A1*A1;
AC2=A1*AC2_over_A1;
A4=A4_over_A1*A1;
AC1=(A1_over_AC1star)^-1*A1;
%end of the recalculation

%% Calculation of the efficiencies
%Propulsive efficiency
eta_propulsive=(Thrust/(P1*A1))*(2*R*T1/(U4^2-U1^2));
eta_propulsive1=(gamma*M1^2*((M4^2/M1^2)*A4_over_A1-1)-A4_over_A1-1)*(2*R*T1/(U4^2-U1^2));

%Thermodynamic cycle efficiency
eta_thermal_cycle=1-(1/T2_over_T1); %Assuming the compression and expansions are perfectly isentropic, in reality there will be some losses associated with these processes
T_A=T2*(P2_over_P1)^((1-gamma)/gamma);
T_B=Tb*(Pb/P1)^((1-gamma)/gamma);
eta_c=(T2-T_A)/(T2-T1);             %compression efficiency
T4=T4_over_Tb*Tb;
eta_e=(Tb-T4)/(Tb-T_B);             %expansion efficiency
eta_thermal_cycle_real=(C*T1)/(f_FA*q)*(T2/T1-1)*(eta_c*eta_e*(1+(T1/T2)*((f_FA*q)/(C*T1)))-1); %Without assuming perfect commpresion and expansion

%Total efficiency
eta_total=eta_thermal_cycle_real*eta_propulsive;