%****************************************DATA SHEET*********************%
function [A,I,E,Ys,Wbp,f1,ro,ri,T_const,MW]=Data_Sheet(option, params)

MW=params.MW;         %MudWeight (lb/gal)
f1=params.f;         %axial friction factor
T_const=6000;    %constant torque (lbf-ft) along the pipe (for margin of overpull calculation it is assumed the torque along the pipe is constant)
%%
switch option
    case 'SDP'
        OD_St=params.OD_St;%in
        ID_St=params.ID_St;%in
        E_St=30*10^6;%psi
        Ys_St=135000;%psi
        RhoSt=65.5; %lb/gal; 7.85 g/cm3; 0.283 lb/in3; 65.5 lb/gal; 490 lb/ft3;
        AirWbSt=params.AirWbSt; %lbf/ft of a typical SDP in Air  24.76
        WbpSt=AirWbSt*(1-MW/RhoSt);
        OD=OD_St;
        ID=ID_St;
        E=E_St;               %psi
        Ys=Ys_St;
        Wbp=WbpSt;            %lbf/ft;
    case 'TDP'
        OD_Ti=5.875;
        ID_Ti=5.153;
        E_Ti=16.5*10^6;%psi
        Ys_Ti=120000;
        RhoTi=37; %lb/gal; 4.429 g/cm3; 0.160 lb/in3; 37 lb/gal; 276.5; %lb/ft3;
        AirWbTi=16.025; %lbf/ft of a typical TDP in Air
        WbpTi=AirWbTi*(1-MW/RhoTi);
        OD=OD_Ti;
        ID=ID_Ti;
        E=E_Ti;               %psi
        Ys=Ys_Ti;
        Wbp=WbpTi;            %lbf/ft;
    case 'ADP'
        OD_Al=5.787;
        ID_Al=4.764;
        E_Al=10.1*10^6;%psi
        Ys_Al=69618;
        RhoAl=23.2; %lb/gal; 2.78 g/cm3; 0.100 lb/in3; 23.2 lb/gal; 173.5;%lb/ft3;
        AirWbAl=15.506; %lbf/ft of a typical ADP in Air
        WbpAl=AirWbAl*(1-MW/RhoAl);
        OD=OD_Al;
        ID=ID_Al;
        E=E_Al;               %psi
        Ys=Ys_Al;
        Wbp=WbpAl;            %lbf/ft;
    case 'CDP'
        OD_Com=6;
        ID_Com=5;
        E_Com=5.5*10^6; %psi
        Ys_Com=52087;   %psi
        RhoCom=21; % lb/gal; 2.52 g/cm3; 0.091 lb/in3; 21 lb/gal; 157 lb/ft3;
        AirWbCom=12.5; %lbf/ft of a typical CDP in Air
        WbpCom=AirWbCom*(1-MW/RhoCom);
        OD=OD_Com;
        ID=ID_Com;
        E=E_Com;               %psi
        Ys=Ys_Com;
        Wbp=WbpCom;            %lbf/ft;
    case 'Example1'
        %some new data can be entered in this section
    case 'Example2'
        %Another example....
    otherwise
        disp('Please enter the valid type!');
end
%%
A=pi/4*(OD^2-ID^2);   %Cross sectional area of pipe (in2)
I=pi/64*(OD^4-ID^4);  %Moment of Inertia            (in4)
ro=OD/2;              %Outer diameter of drillpipe  (in)
ri=ID/2;
end