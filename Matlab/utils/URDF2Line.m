function [x0,z_list,p_list] = URDF2Line(urdf_path)
robot = importrobot(urdf_path)
q_init = homeConfiguration(robot);
z0 = [0,0,1]';
p0 = [0,0,0]';
z_list={z0,z0};
p_list={p0,p0};

x0 = [1;0;0];

for i=1:1:robot.NumBodies
    body = robot.Bodies{i};
    joint = body.Joint;
    joint_type = body.Joint.Type;
    if(strcmp(joint_type,'fixed'))
        continue;
    elseif(strcmp(joint_type,'revolute'))
        T = getTransform(robot,q_init,body.Name,"world");
        R= T(1:3,1:3);
        zhat = R*[0 0 1]';
        p = T(1:3,4);
    
    
    elseif(strcmp(joint_type,'prismatic'))
        T = getTransform(robot,q_init,body.Name,"world");
        R= T(1:3,1:3);
        zhat = R*[0 0 1]';
        p = T(1:3,4);

    end
    z_list{end+1} = zhat;
    p_list{end+1} = p;
    
end
T_tcf = getTransform(robot,q_init,body.Name,"world");
R_tcf= T_tcf(1:3,1:3);
p_tcf = T_tcf(1:3,4);
zhat_tcf = R_tcf*[0,0,1]';
z_list{end+1} = zhat_tcf;
p_list{end+1} = p_tcf;

end