function printMDH(MDH)
    N=length(MDH.a);
    index_str  =sprintf(" index  \t:");
    alpha_print_str =sprintf(" alpha_i  \t:");
    a_print_str =sprintf(" a_i     \t:");
    d_print_str =sprintf(" d_i0     \t:");
    theta_print_str =sprintf(" theta_i0 \t:");
    for i=1:1:N
        index_str=index_str+sprintf("\t%4d",i);
        alpha_print_str=alpha_print_str+sprintf("\t%.4f",MDH.alpha(i));
        a_print_str=a_print_str+sprintf("\t%.4f",MDH.a(i));
        d_print_str=d_print_str+sprintf("\t%.4f",MDH.d(i));
        theta_print_str=theta_print_str+sprintf("\t%.4f",MDH.theta(i));
    end
    print_str=index_str+sprintf("\n")+alpha_print_str+sprintf("\n")+a_print_str+sprintf("\n")+d_print_str+sprintf("\n")+theta_print_str+sprintf("\n");
    disp(print_str)
end