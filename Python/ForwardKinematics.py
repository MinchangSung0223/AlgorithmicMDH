from MDH import MDH
import numpy as np
from numpy import cos, sin
class ForwardKinematics:
    # This class is Forward Kinematics calculation using MDH parameters.
    # Author: Minchang Sung 
    # 
    def __init__(self,MDH):
        self.MDH = MDH;
        self.n = len(self.MDH.alpha)
    def calc_tcf(self,thetalist,joint_type_iist):
        T_tcf = np.eye(4)
        return T_tcf
    def calc_T_list(self,thetalist,joint_type_list):
        T_list=[]
        Ti = np.eye(4)
        T_list.append(Ti)
        for i in range(0,self.n):
            if joint_type_list[i]==0: # Revolute
                T_i_i_next = np.array([[cos(thetalist[i]+self.MDH.theta[i]), -sin(thetalist[i]+self.MDH.theta[i]),0,self.MDH.a[i]]
                                   ,[sin(thetalist[i]+self.MDH.theta[i])*cos(self.MDH.alpha[i]) ,cos(thetalist[i]+self.MDH.theta[i])*cos(self.MDH.alpha[i]) ,-sin(self.MDH.alpha[i]) ,-self.MDH.d[i]*sin(self.MDH.alpha[i])]
                                   ,[sin(thetalist[i]+self.MDH.theta[i])*sin(self.MDH.alpha[i]), cos(thetalist[i]+self.MDH.theta[i])*sin(self.MDH.alpha[i]) ,cos(self.MDH.alpha[i]) ,self.MDH.d[i]*cos(self.MDH.alpha[i])]
                                   ,[0,0,0,1]])
            elif joint_type_list[i]==1: # Prismatic
                T_i_i_next = np.array([[cos(self.MDH.theta[i]), -sin(self.MDH.theta[i]),0,self.MDH.a[i]]
                                   ,[sin(self.MDH.theta[i])*cos(self.MDH.alpha[i]) ,cos(self.MDH.theta[i])*cos(self.MDH.alpha[i]) ,-sin(self.MDH.alpha[i]) ,(-thetalist[i]-self.MDH.d[i])*sin(self.MDH.alpha[i])]
                                   ,[sin(self.MDH.theta[i])*sin(self.MDH.alpha[i]), cos(self.MDH.theta[i])*sin(self.MDH.alpha[i]) ,cos(self.MDH.alpha[i]) ,(thetalist[i]+self.MDH.d[i])*cos(self.MDH.alpha[i])]
                                   ,[0,0,0,1]])  
            Ti = Ti@ T_i_i_next     
            T_list.append(Ti)                  
        return T_list