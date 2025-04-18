restoredefaultpath
addpath("../")
addpath("../utils")
close all;

load scara.mat % you can get line parameters using "utils/URDF2Line.py" file

epsilon = 1e-16;
urdf_path = "../urdf/scara/scara_noisy.urdf"

[x0,z_list,p_list] = URDF2Line(urdf_path);
ret=AlgorithmicMDH(z_list,p_list,x0,epsilon);
printMDH(ret.MDH)
robot = importrobot(urdf_path);
robot.DataFormat='column';
q = homeConfiguration(robot);
ax=show(robot,q,'Frames','off');hold on;
q = randomConfiguration(robot);

drawMDH_q(ret.MDH,[0;q;0])
axis tight;
T = getTransform(robot,q,"tcp","world");
T_n_tcf(1:3,1:3) = eul2rotm([-2.3561, 0 ,0]);
drawT(T*T_n_tcf,1,1)

[Ti_list,T_tcf]=ForwardKinematicsMDH(ret.MDH,[0;q;0],[1,1,1,1,2,1]);

for i = 1:length(ax.Children)
    if isprop(ax.Children(i), 'FaceAlpha')
        ax.Children(i).FaceAlpha = 0.3; 
    end
end

