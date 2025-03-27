restoredefaultpath
addpath("../")
addpath("../utils")
load indy7.mat % you can get line parameters using "utils/URDF2Line.py" file
epsilon = 0.0000001;
ret=AlgorithmicMDH(z_list,p_list,x0,epsilon);
printMDH(ret.MDH)
figure;
show(importrobot("../urdf/indy7/indy7.urdf"),'Frames','off');hold on;
drawMDH(ret.MDH)