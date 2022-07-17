function hookLoad =TorqueDragSens(params)

DP_type = 'SDP';
%% Initial Inputs
[A,I,E,Ys,Wbp,f1,ro,ri,T_const,MW]=Data_Sheet(DP_type, params);

mu=params.f;                           %friction factor
WBHA=params.WBHA;                      %Weight of BHA (lbf)
TBHA=0;                          %Torque at the bit/BHA
rp=ro/(12);                      %drillpipe outer radius (ft)
Rb=params.Rb;                          %Build-up radius (ft)
Rd=0;                          %Drop-off radius (ft)
V=params.V; %Depth (ft) at which each segment(vertical/build-up/slant/drop-off) ends

%The second row of vector V is a tag which determines whether each segment
%is a vertical section, Build up, tangent or drop off section. Horizontal
%Section is a special case of the tangent section.
%1 ==>Vertical Section
%2 ==>Build up Section
%3 ==>Tangent Section
%4 ==>Drop off Section

%% Some Examples

%mu=0.2; Wbp=20.15; WBHA=20000; TBHA=0; rp=5/(2*12); Rb=558;Rd=558; V=[1100,1539,5831,6270;1,2,3,4]; %Dr.Miska's Book page:544. Example: 8.27 
%mu=0.2; Wbp=15;WBHA=0; TBHA=0; rp=5/(2*12); Rb=1000;V=[3000,1000*(3+pi/2),1000*(3+pi/2)+5000;1,2,3]; %Dr.Miska's Book page:547. Example: 8.28 

%Rb=1000;V=[3000,1000*(3+pi/2),1000*(3+pi/2)+5000;1,2,3];mu=0.3;Wbp=WbpCom;WBHA=0; TBHA=0; rp=OD_Com/(2*12);
%Rb=500;V=[3500,500*(7+pi/2),500*(7+pi/2)+5500;1,2,3];mu=0.3;Wbp=15;WBHA=0; TBHA=0; rp=OD_Com/(2*12);
%Rb=250;V=[3750,250*(15+pi/2.3),250*(15+pi/2.3)+5750;1,2,3];mu=0.3;Wbp=WbpSt;WBHA=0;  TBHA=0; rp=OD_Com/(2*12);
%Rb=1000;Rd=1000;V=[1000,1873,3873,4745,5245;1,2,3,4,3];mu=0.2;Wbp=0.3;WBHA=1000;  TBHA=0; rp=0.0635;
%Rb=170;Rd=170;V=[335,469,1777,1911;1,2,3,4];mu=0.2;Wbp=0.294;WBHA=500;TBHA=0;rp=0.0635;

%% In this section the trajectory along its centerline has been discretized

NS=length(V);%Number of Segments
VV=zeros(1,NS);%Initialization of vector of Segment Length
IntLength=zeros(1,NS);%Initialization - The length of Interval for each segment
num=30*ones(1,NS);%Number of interval length for each segment
for i=1:NS
    if i==1
        VV(i)=V(1,i)-0;%VV vector stores the length of each segment
    else
        VV(i)=V(1,i)-V(1,i-1);
    end
end
TMD=max(V(1,:));%Total Measured Dedth(ft)
N=sum(num)+1;%N is the number of all data points along the drillpipe which is one more than the number of segments
S=zeros(2,N);
ct=0;
while abs(max(S)-TMD)>10^-10
    ct=ct+1;
    for i=1:NS
        IntLength(i)=VV(i)/num(i);
        if ct==1
            for j=1:num(i)+1
                if ct==1
                    S(1,ct)=0;
                    S(2,ct)=1;
                else
                    S(1,ct)=S(1,ct-1)+IntLength(i);
                    S(2,ct)=V(2,i);
                end
                ct=ct+1;
            end
        else
            for j=1:num(i)
                S(1,ct)=S(1,ct-1)+IntLength(i);
                S(2,ct)=V(2,i);
                ct=ct+1;
            end
        end
    end
end
Phi=zeros(1,N);
for ct=1:N
    if S(2,ct)==1
        Phi(1,ct)=0;
    elseif S(2,ct)==2
        Phi(1,ct)=Phi(1,ct-1)+(S(1,ct)-S(1,ct-1))/Rb*(180/pi);
    elseif S(2,ct)==3
        Phi(1,ct)=Phi(1,ct-1);
    elseif S(2,ct)==4
        Phi(1,ct)=Phi(1,ct-1)-(S(1,ct)-S(1,ct-1))/Rd*(180/pi);
    end
end
X=zeros(1,N);
Y=zeros(1,N);
a=0;
for ct=1:N
    if S(2,ct)==1
        
        X(1,ct)=a;
        Y(1,ct)=S(1,ct);
        X1=X(1,ct);
        Y1=Y(1,ct);
    elseif S(2,ct)==2
        X(1,ct)=X1+Rb*(1-cosd(Phi(1,ct)));
        Y(1,ct)=Y1+Rb*sind(Phi(1,ct));
    elseif S(2,ct)==3
        X(1,ct)=X(1,ct-1)+(S(1,ct)-S(1,ct-1))*sind(Phi(1,ct));
        Y(1,ct)=Y(1,ct-1)+(S(1,ct)-S(1,ct-1))*cosd(Phi(1,ct));
    elseif S(2,ct)==4
        X(1,ct)=X(1,ct-1)+Rd*(cosd(Phi(1,ct))-cosd(Phi(1,ct-1)));
        Y(1,ct)=Y(1,ct-1)+Rd*(sind(Phi(1,ct-1))-sind(Phi(1,ct)));
    end
end
% figure
% plot(X(1,:),Y(1,:),'r-O');
% xlabel('X');ylabel('Y');
% ylabel('Y vs X');
% set(gca,'YDir','reverse');
% axis([-100 max(X(1,:))+100 -100 max(Y(1,:))+100]);

% figure
% plot(X(1,:),Phi(1,:),'r-O');
% xlabel('X');ylabel('Inclination Angle');
% title('X vs Phi');
% set(gca,'YDir','reverse');
% axis([-100 max(X(1,:))+100 -10 max(Phi(1,:))+10]);

%%
f=inline('Wbp*R/(1+mu^2)*((1-mu^2)*sind(alpha)-2*k*mu*cosd(alpha))','alpha','R','k','Wbp','mu');

%% Hoisting
Phi=zeros(1,N);
Alpha=zeros(1,N);
DLS=zeros(1,N);
F=zeros(1,N);
Wc=zeros(1,N);
HighLow=zeros(1,N);
BuildCounter=0;
VerticalCounter=0;

for ct=1:N
    if S(2,ct)==1
        Phi(1,ct)=0;
        Alpha(1,ct)=0; %Hoisting - Vertical
    elseif S(2,ct)==2
        Phi(1,ct)=Phi(1,ct-1)+(S(1,ct)-S(1,ct-1))/Rb*(180/pi);
        Alpha(1,ct)=360-Phi(1,ct); %Hoisting - Build up
        DLS(ct)=(1/Rb)*(1/12);      %Dogleg severity (rad/in) along the well trajectory
    elseif S(2,ct)==3
        Phi(1,ct)=Phi(1,ct-1);
        Alpha(1,ct)=Phi(1,ct); %Hoisting - Tangent
    elseif S(2,ct)==4
        Phi(1,ct)=Phi(1,ct-1)-(S(1,ct)-S(1,ct-1))/Rd*(180/pi);
        Alpha(1,ct)=Phi(1,ct); %Hoisting - Drop off
        DLS(ct)=(1/Rd)*(1/12);  %Dogleg severity (rad/in) along the well trajectory
    end
end

for ct=N:-1:1
    if S(2,ct)==1 %Vertical Section
        if ct==N
            F(N)=WBHA;
            Wc(N)=0;
            VerticalCounter=VerticalCounter+1;
        else
            if VerticalCounter==0
                if F(ct+1)+Rb*Wbp*sind(Alpha(ct+1))>0 %It is assumed that we can only have Build up section after vertical section
                    k=1;
                else
                    k=-1;
                end
                F(ct)=f(Alpha(ct),Rb,k,Wbp,mu)+(F(ct+1)-f(Alpha(ct+1),Rb,k,Wbp,mu))*exp(k*mu*(Alpha(ct+1)-Alpha(ct+2))*(pi/180));
                Wc(ct)=0; %Because this point is part of the Vertical Section. We have just calculated the true axial force at this point.
                VerticalCounter=VerticalCounter+1;
            else
                F(ct)=F(ct+1)+Wbp*(S(1,ct+1)-S(1,ct));
                Wc(ct)=0;
                HighLow(ct)=0;
            end
        end
    elseif S(2,ct)==2 %Build up Section
        if ct==N
            F(N)=WBHA; %This number can be positive (i.e. tension at the end) or negative (i.e. compressive force at the end)
            Wc(N)=F(N)/Rb+Wbp*sind(Alpha(N));
            if Wc(N)>0
%                 %disp('High Tension ==> High Side');
                HighLow(N)=1;
                if F(N)>0 % There is a possibility that Wc(N)>0 but still F(N) is nagative.
                    Wc(N)=F(N)/Rb+Wbp*sind(Alpha(N));
                else
                    Wc(N)=-F(N)/Rb+Wbp*sind(Alpha(N));%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                end
            else % When Wc(N) is negative that means F(N) is definitely negative.
                %disp('Compression-or-(High DP weight) ==> Low Side');
                HighLow(N)=-2;
                Wc(N)=-F(N)/Rb+Wbp*sind(Alpha(N));%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            end
            BuildCounter=BuildCounter+1;
        else
            if BuildCounter==0
                if V(2,2+1)==3 % if there is a tangent section after build up
                    F(ct)=F(ct+1)+Wbp*(S(1,ct+1)-S(1,ct))*(mu*sind(Alpha(ct+1))+cosd(Alpha(ct+1)));
                    Wc(ct)=F(ct)/Rb+Wbp*sind(Alpha(ct+1));
                    if Wc(ct)>0
                        HighLow(ct)=1; %High side
                    else
                        HighLow(ct)=1; %Low side
                    end
                    if F(ct)>0
                        Wc(ct)=F(ct)/Rb+Wbp*sind(Alpha(ct));
                    else
                        Wc(ct)=-F(ct)/Rb+Wbp*sind(Alpha(ct));%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                    end
                    BuildCounter=BuildCounter+1;
                elseif V(2,2+1)==4 % if there is a drop-off sectio after build up
                    if F(ct+1)+Rd*Wbp*sind(Alpha(ct+1))>0
                        k=1;
                    else
                        k=-1;
                    end
                    F(ct)=f(Alpha(ct),Rd,k,Wbp,mu)+(F(ct+1)-f(Alpha(ct+1),Rd,k,Wbp,mu))*exp(k*mu*(Alpha(ct+1)-Alpha(ct+2))*(pi/180));
                    Wc(ct)=F(ct)/Rb+Wbp*sind(Alpha(ct+1));%We use Rb because this point is part of the Build up section.
                    if Wc(ct)>0
                        HighLow(ct)=-1; %Tension low side
                    else
                        HighLow(ct)=2; %Compression high side
                    end
                    if F(ct)>0
                        Wc(ct)=F(ct)/Rb+Wbp*sind(Alpha(ct));
                    else
                        Wc(ct)=-F(ct)/Rb+Wbp*sind(Alpha(ct));%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                    end
                    BuildCounter=BuildCounter+1;
                end
            else
                if F(ct+1)+Rb*Wbp*sind(Alpha(ct+1))>0
                    k=1;
                else
                    k=-1;
                end
                F(ct)=f(Alpha(ct),Rb,k,Wbp,mu)+(F(ct+1)-f(Alpha(ct+1),Rb,k,Wbp,mu))*exp(k*mu*(Alpha(ct)-Alpha(ct+1))*(pi/180));
                Wc(ct)=F(ct)/Rb+Wbp*sind(Alpha(ct));
                if Wc(ct)>0
                    HighLow(ct)=1; %Tension high side
                else
                    HighLow(ct)=-2; %Compression-or-high weight DP ==> Low side
                end
                if F(ct)>0
                    Wc(ct)=F(ct)/Rb+Wbp*sind(Alpha(ct));
                else
                    Wc(ct)=-F(ct)/Rb+Wbp*sind(Alpha(ct));%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                end
            end
        end
    elseif S(2,ct)==3 %Tangent Section
        if ct==N
            if abs(Phi(N)-0)<10^-1 %If the tangent section is almost vertical
                F(N)=WBHA;
                Wc(N)=0;
                HighLow(N)=0;
            else
                F(N)=WBHA;
                Wc(N)=Wbp*sind(Alpha(N)); %Wc for hoisting in tangent section is always positive since sind(Alpha(N)) is always positive in the first quadrant.
                HighLow(ct)=-1; %Low side
            end
        else
            if abs(Phi(ct)-0)<10^-1 %If the tangent section is almost vertical
                F(ct)=F(ct+1)+Wbp*(S(1,ct+1)-S(1,ct));
                Wc(ct)=0; % First Quadrant ==> always positive
                HighLow(ct)=0; %Vertical
            else
                F(ct)=F(ct+1)+Wbp*(S(1,ct+1)-S(1,ct))*(mu*sind(Alpha(ct))+cosd(Alpha(ct)));
                Wc(ct)=Wbp*sind(Alpha(ct)); % First Quadrant ==> always positive
                HighLow(ct)=-1; %Low side
            end
        end
    elseif S(2,ct)==4 %Drop off Section
        if ct==N
            F(N)=WBHA;
            Wc(N)=F(N)/Rd+Wbp*sind(Alpha(N));
            if Wc(N)>0
                %disp('High Tension ==> Low Side');
                HighLow(N)=-1;
            else
                %disp('Compression ==> High Side');
                HighLow(N)=2;
            end
            if F(N)>0
                Wc(N)=F(N)/Rd+Wbp*sind(Alpha(N));
            else
                Wc(N)=-F(N)/Rd+Wbp*sind(Alpha(N));%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            end
        else
            if F(ct+1)+Rd*Wbp*sind(Alpha(ct+1))>0
                k=1;
            else
                k=-1;
            end
            F(ct)=f(Alpha(ct),Rd,k,Wbp,mu)+(F(ct+1)-f(Alpha(ct+1),Rd,k,Wbp,mu))*exp(k*mu*(Alpha(ct)-Alpha(ct+1))*(pi/180));
            Wc(ct)=F(ct)/Rd+Wbp*sind(Alpha(ct));
            if Wc(ct)>0
                %disp('High Tension ==> Low Side');
                HighLow(ct)=-1;
            else
                %disp('Compression ==> High Side');
                HighLow(ct)=2;
            end
            if F(ct)>0
                Wc(ct)=F(ct)/Rd+Wbp*sind(Alpha(ct));
            else
                Wc(ct)=-F(ct)/Rd+Wbp*sind(Alpha(ct));%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            end
        end
    end
end
F_hoisting=F;

hookLoad = F(1);
% figure;
% plot(F,S(1,:),'o');
% set(gca,'YDir','Reverse');
% xlabel('Axial Force (lbf) - Tripping-out');ylabel('Measured Depth(ft)');
% 
% figure;
% plot(Wc,S(1,:),'rs');
% set(gca,'YDir','Reverse');
% xlabel('Contact force (lbf/ft) - Tripping-out'); ylabel('Measured Depth(ft)');

% figure;
% plot(HighLow,S(1,:),'ms');
% set(gca,'YDir','Reverse');
% xlabel('Relative position - Tripping-out');ylabel('Measured Depth(ft)');
% axis([-2 2 min(S(1,:)) max(S(1,:))]);

%% Margin of Overpull Calculation
p_in=0.052*MW*Y; %MW(ppg), Y(ft)
p_out=p_in;      % It is assumed there is no fluid flow
[MOOP,Strength]=MarginOfOverpull(ri,ro,A,E,Ys,p_in,p_out,F_hoisting,T_const,DLS);

% figure;
% plot(MOOP,S(1,:),'ms');hold on;
% plot(Strength,S(1,:),'bs');
% set(gca,'YDir','Reverse');
% xlabel('Margin of Overpull (lbf)'); ylabel('Measured Depth(ft)');
% legend('MOP (psi)','Strength (psi)');
%% Slacking off - Method 1

Phi=zeros(1,N);
Alpha=zeros(1,N);
F=zeros(1,N);
T=zeros(1,N);
Wc=zeros(1,N);
HighLow=zeros(1,N);
BuildCounter=0;
VerticalCounter=0;
DropCounter=0;
TangentCounter=0;
for ct=1:N
    if S(2,ct)==1
        Phi(1,ct)=0;
        Alpha(1,ct)=0; %Slacking off - Vertical
    elseif S(2,ct)==2
        Phi(1,ct)=Phi(1,ct-1)+(S(1,ct)-S(1,ct-1))/Rb*(180/pi);
        Alpha(1,ct)=180+Phi(1,ct); %Slacking off - Build up
    elseif S(2,ct)==3
        Phi(1,ct)=Phi(1,ct-1);
        Alpha(1,ct)=180-Phi(1,ct); %Slacking off - Tangent
    elseif S(2,ct)==4
        Phi(1,ct)=Phi(1,ct-1)-(S(1,ct)-S(1,ct-1))/Rd*(180/pi);
        Alpha(1,ct)=180-Phi(1,ct); %Slacking off - Drop off
    end
end
for ct=N:-1:1
    if S(2,ct)==1 %Vertical Section
        if ct==N
            F(N)=WBHA;
            T(N)=TBHA;
            Wc(N)=0;
            HighLow(N)=0;
            VerticalCounter=VerticalCounter+1;
        else
            if VerticalCounter==0
                if F(ct+1)+Rb*Wbp*sind(Alpha(ct+1))>0 %It is assumed that we can only have Build up section after vertical section
                    k=1;
                else
                    k=-1;
                end
                F(ct)=f(Alpha(ct)+180,Rb,k,Wbp,mu)+(F(ct+1)-f(Alpha(ct+1),Rb,k,Wbp,mu))*exp(k*mu*(Alpha(ct+1)-Alpha(ct+2))*(pi/180));% It is assumed that only Build up section can come after vertical section. The sharp change of Alpha(ct) is handled by adding 180 to be able to use the build up section formula.
                T(ct)=T(ct+1)+rp*mu*abs((F(ct)+Wbp*Rb*sind(Alpha(ct+1)-(Alpha(ct+2)-Alpha(ct+1))))*(Alpha(ct+2)-Alpha(ct+1))*pi/180+2*Wbp*Rb*(cosd(Alpha(ct+1))-cosd(Alpha(ct+1)-(Alpha(ct+2)-Alpha(ct+1)))));
                Wc(ct)=0; %Because this point is part of the Vertical Section. We have just calculated the true axial force at this point.
                HighLow(ct)=0;
                VerticalCounter=VerticalCounter+1;
            else
                F(ct)=F(ct+1)+Wbp*(S(1,ct+1)-S(1,ct));
                T(ct)=T(ct+1);
                Wc(ct)=0;
                HighLow(ct)=0;
            end
        end
    elseif S(2,ct)==2 %Build up Section
        if ct==N
            F(N)=WBHA; %This number can be positive (i.e. tension at the end) or negative (i.e. compressive force at the end)
            T(N)=TBHA;
            Wc(N)=F(N)/Rb+Wbp*sind(Alpha(N));
            if Wc(N)>0
                %disp('High Tension ==> High Side');
                HighLow(N)=1; %High side
            else
                %disp('Compression-or-(High DP weight) ==> Low Side');
                HighLow(N)=-2; %Low Side
            end
            if F(N)>0
                Wc(N)=F(N)/Rb+Wbp*sind(Alpha(N));
            else
                Wc(N)=-F(N)/Rb+Wbp*sind(Alpha(N));%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            end
            BuildCounter=BuildCounter+1;
        else
            if BuildCounter==0
                if V(2,2+1)==3 % if there is a tangent section after build up
                    F(ct)=F(ct+1)+Wbp*(S(1,ct+1)-S(1,ct))*(-mu*sind(Alpha(ct+1))+cosd(180-Alpha(ct+1)));
                    T(ct)=T(ct+1)+rp*mu*abs(Wbp*(S(1,ct+1)-S(1,ct))*sind(Alpha(ct+1)));
                    Wc(ct)=F(ct)/Rb+Wbp*sind(Alpha(ct));%First quadrant and Wc here is always positive.
                    %
                    %Here we can add a criterion for drillpipe buckling. In
                    %cas of buckling Wc will not be positive anymore
                    %
                    if Wc(ct)>0
                        HighLow(ct)=1; %High side
                    else %This point is tagged as a build up section not drop-off section.
                        HighLow(ct)=-2; %Low side
                    end
                    if F(ct)>0
                        Wc(ct)=F(ct)/Rb+Wbp*sind(Alpha(ct));
                    else
                        Wc(ct)=-F(ct)/Rb+Wbp*sind(Alpha(ct));%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                    end
                    BuildCounter=BuildCounter+1;
                elseif V(2,2+1)==4 % if there is a drop-off sectio after build up
                    if F(ct+1)+Rd*Wbp*sind(Alpha(ct+1))>0
                        k=1;
                    else
                        k=-1;
                    end
                    F(ct)=f(Alpha(ct),Rd,k,Wbp,mu)+(F(ct+1)-f(Alpha(ct+1),Rd,k,Wbp,mu))*exp(k*mu*(Alpha(ct+1)-Alpha(ct+2))*(pi/180));
                    T(ct)=T(ct+1)+rp*mu*abs((F(ct)+Wbp*Rd*sind(Alpha(ct+1)+(Alpha(ct+1)-Alpha(ct+2))))*(Alpha(ct+2)-Alpha(ct+1))*pi/180-2*Wbp*Rd*(cosd(Alpha(ct+1))-cosd(Alpha(ct+1)+(Alpha(ct+1)-Alpha(ct+2)))));
                    Wc(ct)=F(ct)/R+Wbp*sind(Alpha(ct+1));
                    if Wc(ct)>0
                        HighLow(ct)=1; %Tension high side
                    else %This point is tagged as a build up section not drop-off section.
                        HighLow(ct)=-2; %Compression low side
                    end
                    if F(ct)>0
                        Wc(ct)=F(ct)/Rb+Wbp*sind(Alpha(ct));
                    else
                        Wc(ct)=-F(ct)/Rb+Wbp*sind(Alpha(ct));%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                    end
                    BuildCounter=BuildCounter+1;
                end
            else
                if F(ct+1)+Rb*Wbp*sind(Alpha(ct+1))>0
                    k=1;
                else
                    k=-1;
                end
                F(ct)=f(Alpha(ct),Rb,k,Wbp,mu)+(F(ct+1)-f(Alpha(ct+1),Rb,k,Wbp,mu))*exp(k*mu*(Alpha(ct)-Alpha(ct+1))*(pi/180));
                T(ct)=T(ct+1)+rp*mu*abs((F(ct)+Wbp*Rb*sind(Alpha(ct)))*(Alpha(ct+1)-Alpha(ct))*pi/180+2*Wbp*Rb*(cosd(Alpha(ct+1))-cosd(Alpha(ct))));
                Wc(ct)=F(ct)/Rb+Wbp*sind(Alpha(ct));
                if Wc(ct)>0
                    HighLow(ct)=1; %Tension high side
                else
                    HighLow(ct)=-2; %Compression-or-high weight DP ==> Low side
                end
                if F(ct)>0
                    Wc(ct)=F(ct)/Rb+Wbp*sind(Alpha(ct));
                else
                    Wc(ct)=-F(ct)/Rb+Wbp*sind(Alpha(ct));%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                end
            end
        end
    elseif S(2,ct)==3 %Tangent Section
        if ct==N
            if abs(Phi(N)-0)<10^-1
                F(N)=WBHA;
                T(N)=TBHA;
                Wc(N)=0;
                HighLow(N)=0;
                TangentCounter=TangentCounter+1;
            else
                F(N)=WBHA;
                T(N)=TBHA;
                Wc(N)=Wbp*sind(Alpha(N)); %Wc for hoisting in tangent section is always positive since sind(Alpha(N)) is always positive in the first quadrant.
                HighLow(N)=-1; %Low side
                TangentCounter=TangentCounter+1;
            end
        else
            if abs(Phi(ct)-0)<10^-1
                F(ct)=F(ct+1)+Wbp*(S(1,ct+1)-S(1,ct))*(-mu*sind(Alpha(ct))+cosd(180-Alpha(ct)));
                T(ct)=T(ct+1);
                Wc(ct)=0; % First Quadrant ==> always positive
                %
                %Here we can also put a criterion for Vertical pipe
                %buckling. In case of buckling contact force will not be
                %zero anymore
                %
                HighLow(ct)=0; %Vertical
            else
                F(ct)=F(ct+1)+Wbp*(S(1,ct+1)-S(1,ct))*(-mu*sind(Alpha(ct))+cosd(180-Alpha(ct)));
                if TangentCounter==0
                    if length(V)>3
                        if V(2,3+1)==4%if there is a drop off after tangent section
                            T(ct)=T(ct+1)+rp*mu*abs((F(ct)+Wbp*Rd*sind(Alpha(ct+1)+(Alpha(ct+1)-Alpha(ct+2))))*(Alpha(ct+1)-(Alpha(ct+1)+(Alpha(ct+1)-Alpha(ct+2))))*pi/180-2*Wbp*Rd*(cosd(Alpha(ct+1))-cosd(Alpha(ct+1)+(Alpha(ct+1)-Alpha(ct+2)))));
                        elseif V(2,3+1)==2%if there is a build up section after tangent section
                            T(ct)=T(ct+1)+rp*mu*abs((F(ct)+Wbp*Rb*sind(Alpha(ct+1)-(Alpha(ct+2)-Alpha(ct+1))))*(Alpha(ct+2)-Alpha(ct+1))*pi/180+2*Wbp*Rb*(cosd(Alpha(ct+1))-cosd(Alpha(ct+1)-(Alpha(ct+2)-Alpha(ct+1)))));
                        end
                    end
                    TangentCounter=TangentCounter+1;
                else
                    T(ct)=T(ct+1)+rp*mu*abs(Wbp*(S(1,ct+1)-S(1,ct))*sind(Alpha(ct)));
                end
                Wc(ct)=Wbp*sind(Alpha(ct)); % First Quadrant ==> always positive
                %
                %Here we can also put a criterion for buckling of DP
                %
                HighLow(ct)=-1; %Low side
            end
        end
    elseif S(2,ct)==4 %Drop off Section
        if ct==N
            F(N)=WBHA;
            T(N)=TBHA;
            Wc(N)=F(N)/Rd+Wbp*sind(Alpha(N));
            if Wc(N)>0
                %disp('High Tension ==> Low Side');
                HighLow(N)=-1;
            else
                %disp('Compression ==> High Side');
                HighLow(N)=2;
            end
            if F(ct)>0
                Wc(ct)=F(ct)/Rb+Wbp*sind(Alpha(ct));
            else
                Wc(ct)=-F(ct)/Rb+Wbp*sind(Alpha(ct));%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            end
            DropCounter=DropCounter+1;
        else
            if F(ct+1)+Rb*Wbp*sind(Alpha(ct+1))>0
                k=1;
            else
                k=-1;
            end
            if DropCounter==0
                if length(V)>4
                    if V(2,4+1)==3 %If there was a tangent/vertical section after drop-off section
                        F(ct)=F(ct+1)+Wbp*(S(1,ct+1)-S(1,ct))*(-mu*sind(Alpha(ct+1))+cosd(180-Alpha(ct+1)));
                        T(ct)=T(ct+1)+rp*mu*abs(Wbp*(S(1,ct+1)-S(1,ct))*sind(Alpha(ct)));
                        Wc(ct)=F(ct)/Rd+Wbp*sind(Alpha(ct));
                        if Wc(ct)>0
                            %disp('High Tension ==> Low Side');
                            HighLow(ct)=-1;
                        else
                            %disp('Compression ==> High Side');
                            HighLow(ct)=2;
                        end
                        if F(ct)>0
                            Wc(ct)=F(ct)/Rb+Wbp*sind(Alpha(ct));
                        else
                            Wc(ct)=-F(ct)/Rb+Wbp*sind(Alpha(ct));%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                        end
                        DropCounter=DropCounter+1;
                    end
                end
            else
                F(ct)=f(Alpha(ct),Rd,k,Wbp,mu)+(F(ct+1)-f(Alpha(ct+1),Rd,k,Wbp,mu))*exp(k*mu*(Alpha(ct)-Alpha(ct+1))*(pi/180));
                T(ct)=T(ct+1)+rp*mu*abs((F(ct)+Wbp*Rd*sind(Alpha(ct)))*(Alpha(ct+1)-Alpha(ct))*pi/180-2*Wbp*Rd*(cosd(Alpha(ct+1))-cosd(Alpha(ct))));
                Wc(ct)=F(ct)/Rd+Wbp*sind(Alpha(ct));
                if Wc(ct)>0
                    %disp('High Tension ==> Low Side');
                    HighLow(ct)=-1;
                else
                    %disp('Compression ==> High Side');
                    HighLow(ct)=2;
                end
                if F(ct)>0
                    Wc(ct)=F(ct)/Rb+Wbp*sind(Alpha(ct));
                else
                    Wc(ct)=-F(ct)/Rb+Wbp*sind(Alpha(ct));%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                end
            end
        end
    end
end

% figure;
% plot(F,S(1,:),'o');
% set(gca,'YDir','Reverse');
% xlabel('Axial Force(lbf) - Tripping-in');ylabel('Measured Depth(ft)');
% 
% figure;
% plot(Wc,S(1,:),'gs');
% set(gca,'YDir','Reverse');
% xlabel('Contact Force(lbf/ft) - Tripping-in');ylabel('Measured Depth(ft)');

% figure;
% plot(HighLow,S(1,:),'gs');
% set(gca,'YDir','Reverse');
% xlabel('Relative position - Tripping-in');ylabel('Measured Depth(ft)');
% axis([-2 2 min(S(1,:)) max(S(1,:))]);

% figure;
% plot(T,S(1,:),'o')
% set(gca,'YDir','Reverse');
% xlabel('Torque');ylabel('Measured Depth(ft)');

%% Slacking off - Method 2

Phi=zeros(1,N);
Alpha=zeros(1,N);
F=zeros(1,N);
BuildCounter=0;
for ct=1:N
    if S(2,ct)==1
        Phi(1,ct)=0;
        Alpha(1,ct)=0; %Slacking off - Vertical
    elseif S(2,ct)==2
        Phi(1,ct)=Phi(1,ct-1)+(S(1,ct)-S(1,ct-1))/Rb*(180/pi);
        Alpha(1,ct)=180+Phi(1,ct); %Slacking off - Build up
    elseif S(2,ct)==3
        Phi(1,ct)=Phi(1,ct-1);
        Alpha(1,ct)=180-Phi(1,ct); %Slacking off - Tangent
    elseif S(2,ct)==4
        Phi(1,ct)=Phi(1,ct-1)-(S(1,ct)-S(1,ct-1))/Rd*(180/pi);
        Alpha(1,ct)=180-Phi(1,ct); %Slacking off - Drop off
    end
end

for ct=N:-1:1
    if S(2,ct)==1
        if ct==N
            F(N)=WBHA;
        else
            F(ct)=F(ct+1)+Wbp*(S(1,ct+1)-S(1,ct));
        end
    elseif S(2,ct)==2
        
        if ct==N
            F(N)=WBHA; %This number can be positive (i.e. tension at the end) or negative (i.e. compressive force at the end)
            BuildCounter=BuildCounter+1;
        else
            if F(ct+1)+Rb*Wbp*sind(Alpha(ct+1))>0
                k=1;
            else
                k=-1;
            end
            if BuildCounter==0
                if V(2,2+1)==3 % if there is a tangent section after build up
                    F(ct)=F(ct+1)+Wbp*(S(1,ct+1)-S(1,ct))*(-mu*sind(Alpha(ct+1))+cosd(180-Alpha(ct+1)));
                    BuildCounter=BuildCounter+1;
                elseif V(2,2+1)==4 % if there is a drop-off sectio after build up
                    F(ct)=f(Alpha(ct),Rd,k,Wbp,mu)+(F(ct+1)-f(Alpha(ct+1),Rd,k,Wbp,mu))*exp(k*mu*(Alpha(ct+1)-Alpha(ct+2))*(pi/180));
                    BuildCounter=BuildCounter+1;
                end
            else
                F(ct)=f(Alpha(ct),Rb,k,Wbp,mu)+(F(ct+1)-f(Alpha(ct+1),Rb,k,Wbp,mu))*exp(k*mu*(Alpha(ct)-Alpha(ct+1))*(pi/180));
            end
        end
    elseif S(2,ct)==3
        if ct==N
            F(N)=WBHA;
        else
            F(ct)=F(ct+1)+Wbp*(S(1,ct+1)-S(1,ct))*(-mu*sind(Alpha(ct))+cosd(180-Alpha(ct)));
        end
    elseif S(2,ct)==4
        if ct==N
            F(N)=WBHA;
        else
            if F(ct+1)+Rb*Wbp*sind(Alpha(ct+1))>0
                k=1;
            else
                k=-1;
            end
            F(ct)=f(Alpha(ct),Rd,k,Wbp,mu)+(F(ct+1)-f(Alpha(ct+1),Rd,k,Wbp,mu))*exp(k*mu*(Alpha(ct)-Alpha(ct+1))*(pi/180));
        end
    end
end
% figure;
% plot(F,S(1,:),'.');
% set(gca,'YDir','Reverse');
% xlabel('Axial Force(lbf) - Tripping-in');ylabel('Measured Depth(ft)');








