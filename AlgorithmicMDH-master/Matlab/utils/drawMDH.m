function drawMDH(MDH)
    N=length(MDH.a);
    thetalist = zeros(N,1);
    [Ti_list,T_tcf]=ForwardKinematicsMDH(MDH,thetalist);
    for i=1:1:length(Ti_list)
        Ti=Ti_list{i};
        drawT(Ti,0.1,1)
    end
    drawT(T_tcf,0.1,1)
    
end