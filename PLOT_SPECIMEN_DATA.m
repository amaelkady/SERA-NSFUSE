close all; clc; clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script automatically plots the data for the tested fuse specimens
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Specimen = 'A3-01'; % Specify specimen name
SF       = '150%';  % Specify scale factor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Get Specimen Data
MainDir=pwd;

g             = 9.81;         % Gravity acceleration [m/sec2]
E             = 200000;       % Modulus of Elasticity [MPa] --> expected
fy            = 345;          % Yield Stress [MPa] --> nominal 

%% Load Specimen Info
cd ('Specimen Data')
cd (Specimen)
cd (SF)
load Test_info.mat
Time=importdata('Time.txt');
Acc_Table=importdata('Acc_Table.txt');
Acc_Carriage=importdata('Acc_Carriage.txt');
Disp_Table=importdata('Disp_Table.txt');
Disp_Carriage=importdata('Disp_Carriage.txt');
data=importdata('Fuse_Response.txt');
RelDisp=data(:,1);
Force=data(:,2);
cd (MainDir);

indx1=regexp(Specimen_Info(1),':');
Fuse_ID = Specimen_Info{1}(indx1{1}+1:end);

indx1=regexp(Specimen_Info(3),':');
GM_ID = Specimen_Info{3}(indx1{1}+1:end);

indx1=regexp(Specimen_Info(4),':');
SF = Specimen_Info{4}(indx1{1}+1:end);

indx1=regexp(Specimen_Info(5),':');
indx2=regexp(Specimen_Info(5),'x');
hFuse = str2double(Specimen_Info{5}(indx1{1}+1:indx2{1}(1)-1));
bFuse = str2double(Specimen_Info{5}(indx2{1}(1)+1:indx2{1}(2)-1));
tFuse = str2double(Specimen_Info{5}(indx2{1}(2)+1:end));
F_pe  = (bFuse * tFuse^2 / 6) * fy * 1.15 / (hFuse+160) / 10^3; % Expected plastic force for one fuse --> effective height taken as h+160mm 

indx1=regexp(Specimen_Info(6),':');
indx2=regexp(Specimen_Info(6),'k');
Mass_Carriage = str2double(Specimen_Info{6}(indx1{1}+1:indx2{1}-1));

indx1=regexp(Specimen_Info(7),':');
indx2=regexp(Specimen_Info(7),'%');
C_Damping = str2double(Specimen_Info{7}(indx1{1}+1:indx2{1}-1))/100;

indx1=regexp(Specimen_Info(8),':');
indx2=regexp(Specimen_Info(8),'sec');
T_measured = str2double(Specimen_Info{8}(indx1{1}+1:indx2{1}-1));

%% Specimen Info
figure('position',[100 100 300 250],'color','white');
xlim([0 1]);
ylim([0 1]);
set(gca, 'XTick', [], 'XTickLabel', []);
set(gca, 'YTick', [], 'YTickLabel', []);
set(get(gca, 'XAxis'), 'Visible', 'off');
set(get(gca, 'YAxis'), 'Visible', 'off');
text(0.1,0.5,Specimen_Info,'fontname','times','fontsize',12);
title('Specimen info');

%% Acceleration plots
h1=figure('position',[100 100 450 350],'color','white');

subplot(2,1,1)
hold on; grid on; box on;
xlabel('Time [sec]')
ylabel('Acc. [g]')
plot(Time,Acc_Table,'-k','linewidth',0.75);
set(gca,'fontsize',10,'fontname','times');
title('Shake Table Acceleration','FontSize', 10);
set(gca,'YLim',[-1.2*max(abs(Acc_Table)) 1.2*max(abs(Acc_Table))])
MaxAccX=round(max(abs(Acc_Table))*100)/100;
text(0.3*max(Time),0.8*min(Acc_Table),['maxX=',num2str(MaxAccX),'g '],'fontname','times','fontsize',10)

subplot(2,1,2)
hold on; grid on; box on;
xlabel('Time [sec]')
ylabel('Acc. [g]')
plot(Time,Acc_Carriage,'-k','linewidth',0.75);
set(gca,'fontsize',10,'fontname','times');
title('Carriage Absolute Acceleration','FontSize', 10);
set(gca,'YLim',[-1.2*max(abs(Acc_Carriage)) 1.2*max(abs(Acc_Carriage))])
MaxAccX=round(max(abs(Acc_Carriage))*100)/100;
text(0.3*max(Time),0.8*min(Acc_Carriage),['maxX=',num2str(MaxAccX),'g '],'fontname','times','fontsize',10)

%% Displacement plots
h2=figure('position',[100 100 450 350],'color','white');

subplot(2,1,1)
hold on; grid on; box on;
xlabel('Time [sec]')
ylabel('Disp. [mm]')
plot(Time,Disp_Table,'-k','linewidth',0.75);
set(gca,'fontsize',10,'fontname','times');
set(gca,'YLim',[-1.2*max(abs(Disp_Table)) 1.2*max(abs(Disp_Table))])
title('Shake Table Displacement','FontSize', 10);

subplot(2,1,2)
hold on; grid on; box on;
xlabel('Time [sec]')
ylabel('Disp. [mm]')
plot(Time,Disp_Carriage,'-k','linewidth',0.75);
set(gca,'fontsize',10,'fontname','times');
set(gca,'YLim',[-1.2*max(abs(Disp_Carriage)) 1.2*max(abs(Disp_Carriage))])
title('Carriage Absolute Displacement','FontSize', 10);


%% Spectral Response plot

% Evaluate the acceleration response spectum of a linear elastic system
Period_range  = 0:0.01:3;
GMdt          = Time(2)-Time(1);
[Spectral_Sa] = Get_Spectrum_linearSDF(Period_range,C_Damping,Acc_Table,GMdt);

alpha_p=max(abs(Acc_Carriage))/max(abs(Acc_Table));
alpha_p=round(alpha_p*100)/100;

h5=figure('position',[100 100 350 300],'color','white');
hold on; grid on; box on;
plot(Period_range, Spectral_Sa,'-r','linewidth',1.0);
set(gca,'fontsize',12,'fontname','times');
xlabel('Period [sec]')
ylabel('Spectral acceleration [g]')
Sa_T_measured=interp1(Period_range,Spectral_Sa,T_measured);
plot([0 3],[max(abs(Acc_Carriage)) max(abs(Acc_Carriage))], '--b','linewidth',1.0);
plot([T_measured T_measured], [0 Sa_T_measured],'--k','linewidth',1.0);
plot(T_measured, Sa_T_measured,'-ok','Markerfacecolor','g');
text(2,0.7*max(Spectral_Sa),['\alpha_p =',num2str(alpha_p)],'fontname','times','fontsize',10)
text(T_measured+0.05,0.05*max(Spectral_Sa),['T=',num2str(T_measured),'sec'],'fontname','times','fontsize',10)
legend(['Acc. spectrum (linear ',num2str(round(C_Damping*100*100)/100),'% damped)'],'Measured carraige acc.');


%% Force-Disp plot
h3=figure('position',[100 100 300 250],'color','white');
hold on; grid on; box on;
plot([-1.5*max(abs(RelDisp)) 1.5*max(abs(RelDisp))], [0 0],'-k','linewidth',0.5);
plot([0 0], [-1.5*max(max(abs(Force))) 1.5*max(max(abs(Force)))],'-k','linewidth',0.5);
plot(RelDisp, -Force,'-k','linewidth',0.75);
set(gca,'fontsize',12,'fontname','times');
xlabel('Rel. displacement [mm]')
ylabel('Inertia force [kN]')
yline(2*F_pe,'--b','DisplayName','Expected fuse plastic force')
yline(-2*F_pe,'--b')
set(gca,'XLim',[-1.2*max(abs(RelDisp)) 1.2*max(abs(RelDisp))])
set(gca,'YLim',[-1.25*max(abs(Force)) 1.25*max(abs(Force))])
