

ID = 'A3-02';
SF = '150%';

mainDir = pwd;

cd (ID)
cd (SF)

evalc(['load ','''',ID,'_SF',SF,'.mat','''']);

Time = Data.Time;
Acc_Carriage = Data.Acc_Carriage;
Disp_Carriage = Data.Disp_Carriage;
Acc_Table = Data.Acc_Carriage;
Disp_Table = Data.Disp_Carriage;
Fuse_Response = Data.System_Response;
Fuse_Strain = Data.Strain;
Specimen_Info=Data.Specimen_Info;

writematrix(Time,'Time.txt');
writematrix(Acc_Carriage,'Acc_Carriage.txt');
writematrix(Disp_Carriage,'Disp_Carriage.txt');
writematrix(Acc_Table,'Acc_Table.txt');
writematrix(Disp_Table,'Disp_Table.txt');
writematrix(Fuse_Response,'Fuse_Response.txt');
writematrix(Fuse_Strain,'Fuse_Strain.txt');
save ('Test_info',"Specimen_Info");

cd (mainDir)