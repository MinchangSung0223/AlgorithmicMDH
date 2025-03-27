
import numpy as np
from Line import Line
from LineGeometry import LineGeometry
from MDH import MDH
from numpy import cross,dot,sin,cos,arctan2,isnan
from numpy.linalg import norm
np.set_printoptions(precision=4)
class AlgorithmicMDH:
    # This class is Algorithmic MDH, you can get MDH parameters by entering line parameters z_list and p_list.
    # Author: Minchang Sung 
    # Author: Minchang Sung 
    # E-mail: wdrac331@hanyang.ac.kr
    # Date: November 30, 2023    
    def __init__(self, z_list, p_list,z_tcf,p_tcf,x_tcf,x_0):
        self.COLLINEAR = 0
        self.DISTANT = 1
        self.INTERSECTED = 2
        self.SKEWED = 3        
        self.LineGeometry_list=[]
        self.Line_list = []
        self.MDH=MDH([],[],[],[])
        self.epsilon = 0.00000001
        p_list.append(p_tcf)
        z_list.append(z_tcf)
        N=len(z_list)-2;    
        self.x_list=[]
        self.alpha_list = []
        self.a_list = []
        self.d_list = []
        self.theta_list = []        
        self.x_list.append(np.array(x_0))
        for i in range(1,N+1):
            for j in range(i-1,i+2):
                p_j = np.array(p_list[j])
                z_j = np.array(z_list[j])
                L_j=Line(z_j,p_j);
                self.Line_list.append(L_j);
                self.Line_list[j]=L_j;
            
            LG_prev_i_i = LineGeometry(self.Line_list[i-1],self.Line_list[i],self.epsilon);
            LG_i_next_i = LineGeometry(self.Line_list[i],self.Line_list[i+1],self.epsilon);
            alpha_prev_i_i,a_prev_i_i,n_prev_i_i,t_prev_i_prev_i,t_prev_i_i=LG_prev_i_i.get_parameters();
            alpha_i_next_i,a_i_next_i,n_i_next_i,t_i_i,t_i_next_i=LG_i_next_i.get_parameters();
            z_prev_i = LG_prev_i_i.L1.z_hat;
            z_i = LG_prev_i_i.L2.z_hat;
            self.LineGeometry_list.append(LG_prev_i_i);
            x_prev_i = np.array(self.x_list[-1]);
            x_i=np.array([0,0,0]);
            if LG_i_next_i.type==self.COLLINEAR:
                x_i=np.array(self.x_list[-1]);
            else:
                x_i=np.array(n_i_next_i);
            s_ix=1;
            s_iz=1;
            if norm(cross(z_prev_i,z_i))>self.epsilon:
                s_ix=dot(x_prev_i,n_prev_i_i)/norm(dot(x_prev_i,n_prev_i_i));
            if norm(cross(x_prev_i,x_i))>self.epsilon:
                s_iz=dot(z_i,(cross(x_prev_i,x_i)))/norm(dot(z_i,(cross(x_prev_i,x_i))))
            alpha_i = s_ix*alpha_prev_i_i;
            a_i = s_ix*a_prev_i_i;
            d_i= dot(z_i ,(t_i_i-t_prev_i_i));
            theta_i = s_iz*arctan2(norm(cross(x_prev_i,x_i)),dot(x_prev_i,x_i));
            self.x_list.append(x_i);
            self.alpha_list.append(alpha_i)
            self.a_list.append(a_i)
            self.d_list.append(d_i)
            self.theta_list.append(theta_i)
        self.MDH.alpha = self.alpha_list
        self.MDH.a = self.a_list
        self.MDH.d = self.d_list
        self.MDH.theta = self.theta_list

            