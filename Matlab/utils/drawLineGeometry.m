function drawLineGeometry(LG)
   drawLine(LG.L1,"$L_1$");hold on;
   drawLine(LG.L2,"$L_2$");

   grid on;
   ax=gca;

   if LG.type==1
       title("COLLINEAR");
   elseif LG.type==2
       title("DISTANT");
   elseif LG.type==3
       title("INTERSECTED");
   elseif LG.type==4
       title("SKEWED")    ;
   end
   plot3(LG.t1(1),LG.t1(2),LG.t1(3),'r*')
   text(LG.t1(1),LG.t1(2),LG.t1(3),'$t_1$','Color','red','Interpreter','latex')
   
   plot3(LG.t2(1),LG.t2(2),LG.t2(3),'b.')
   text(LG.t2(1),LG.t2(2),LG.t2(3),'$t_2$','Color','blue','Interpreter','latex')
   plot3([LG.t2(1),LG.t1(1)],[LG.t2(2),LG.t1(2)],[LG.t2(3),LG.t1(3)],'k:')
   
   quiver3([LG.t1(1)],[LG.t1(2)],[LG.t1(3)],LG.n_hat(1),LG.n_hat(2),LG.n_hat(3),'Color','red')
   text([LG.t1(1)+LG.n_hat(1)],[LG.t1(2)+LG.n_hat(2)],[LG.t1(3)+LG.n_hat(3)],'$\hat{n}$','Interpreter','latex')
   axis auto padded equal;
   
   x_limit = abs(ax.XLim(2)-ax.XLim(1));
   y_limit = abs(ax.YLim(2)-ax.YLim(1));
   if x_limit>y_limit
       ax.XLim=[-ax.XLim(2)-ax.XLim(2)/10.0,ax.XLim(2)+ax.XLim(2)/10.0];
       ax.YLim=ax.XLim;
   else
       ax.YLim=[-ax.YLim(2)+ax.YLim(2)/10.0,ax.YLim(2)+ax.YLim(2)/10.0];
       ax.XLim=ax.YLim;
   end   
   daspect([1,1,1]);
   hold off;
   
end


function drawLine(L1,line_name)
    quiver3([L1.p(1)],[L1.p(2)],[L1.p(3)],[L1.z_hat(1)],[L1.z_hat(2)],[L1.z_hat(3)],'Color','blue') ;hold on;
    line([L1.p(1)-L1.z_hat(1),L1.p(1)+L1.z_hat(1)],[L1.p(2)-L1.z_hat(2),L1.p(2)+L1.z_hat(2)],[L1.p(3)-L1.z_hat(3),L1.p(3)+L1.z_hat(3)],"LineStyle",':');
    plot3(L1.p(1),L1.p(2),L1.p(3),'k.');
    text(L1.p(1)+L1.z_hat(1),L1.p(2)+L1.z_hat(2),L1.p(3)+L1.z_hat(3),line_name,'Interpreter','latex')
end