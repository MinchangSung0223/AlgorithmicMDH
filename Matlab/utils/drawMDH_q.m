function drawMDH_q(MDH,q)
    N=length(MDH.a);
    thetalist = q;
    [Ti_list,T_tcf]=ForwardKinematicsMDH(MDH,thetalist);
    for i=1:1:length(Ti_list)
        Ti=Ti_list{i};
        drawT(Ti,0.1,3)
    end
    drawT(T_tcf,0.1,3)
    
end