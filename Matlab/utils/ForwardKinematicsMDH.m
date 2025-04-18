function [Ti_list,T_tcf]=ForwardKinematicsMDH(MDH,thetalist,joint_type)
    if nargin<=2
        Ti = eye(4);
        Ti_list={Ti};
        for i=1:1:length(MDH.a)
            T = [cos(thetalist(i)+MDH.theta(i)) -sin(thetalist(i)+MDH.theta(i)) 0 MDH.a(i);...
                 sin(thetalist(i)+MDH.theta(i))*cos(MDH.alpha(i)) cos(thetalist(i)+MDH.theta(i))*cos(MDH.alpha(i)) -sin(MDH.alpha(i)) -MDH.d(i)*sin(MDH.alpha(i));...
                 sin(thetalist(i)+MDH.theta(i))*sin(MDH.alpha(i)) cos(thetalist(i)+MDH.theta(i))*sin(MDH.alpha(i)) cos(MDH.alpha(i)) MDH.d(i)*cos(MDH.alpha(i));...
                 0 0 0 1];
            Ti = Ti*T;
            Ti_list{end+1} = Ti;
        end
        T_tcf=Ti;
    else
        Ti = eye(4);
        Ti_list={Ti};
        for i=1:1:length(MDH.a)
            if joint_type(i) ==1
                T = [cos(thetalist(i)+MDH.theta(i)) -sin(thetalist(i)+MDH.theta(i)) 0 MDH.a(i);...
                 sin(thetalist(i)+MDH.theta(i))*cos(MDH.alpha(i)) cos(thetalist(i)+MDH.theta(i))*cos(MDH.alpha(i)) -sin(MDH.alpha(i)) -MDH.d(i)*sin(MDH.alpha(i));...
                 sin(thetalist(i)+MDH.theta(i))*sin(MDH.alpha(i)) cos(thetalist(i)+MDH.theta(i))*sin(MDH.alpha(i)) cos(MDH.alpha(i)) MDH.d(i)*cos(MDH.alpha(i));...
                 0 0 0 1];
            elseif joint_type(i) ==2
                T = [cos(MDH.theta(i)) -sin(MDH.theta(i)) 0 MDH.a(i);...
                 sin(MDH.theta(i))*cos(MDH.alpha(i)) cos(MDH.theta(i))*cos(MDH.alpha(i)) -sin(MDH.alpha(i)) -(-thetalist(i)+MDH.d(i))*sin(MDH.alpha(i));...
                 sin(MDH.theta(i))*sin(MDH.alpha(i)) cos(MDH.theta(i))*sin(MDH.alpha(i)) cos(MDH.alpha(i)) (-thetalist(i)+MDH.d(i))*cos(MDH.alpha(i));...
                 0 0 0 1];
            end
            
            Ti = Ti*T;
            Ti_list{end+1} = Ti;
        end
        T_tcf=Ti;
    end
    
end