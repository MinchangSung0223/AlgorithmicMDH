function [Ti_list,T_tcf]=ForwardKinematicsMDH(MDH,thetalist)
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
end