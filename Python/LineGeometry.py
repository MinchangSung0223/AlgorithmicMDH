from Line import Line
import numpy as np
from numpy import cross,dot,sin,cos,arctan2,outer
from numpy.linalg import norm
def normvec(vector):
    return vector/norm(vector)
def reciprocal_product(L1, L2):
    return np.dot(L1.z_hat,L2.v)+np.dot(L2.z_hat,L1.v)
def Criterion2_2(L1,L2,epsilon):
    if abs(reciprocal_product(L1, L2))<epsilon:
        return 1
    else:
        return 0
def Criterion2_1(L1,L2,epsilon):
    if norm(L1.p_perp-L2.p_perp)<epsilon:
        return 1
    else:
        return 0    
def Criterion1(L1,L2,epsilon):
    if norm(cross(L1.z_hat,L2.z_hat))<epsilon:
        return 1
    else:
        return 0
class LineGeometry:
    # This class is LineGeometry 
    # you can get five parameters alpha, a, n, t1, and t2 using the get_parameters() function.
    # Author: Minchang Sung 
    # E-mail: wdrac331@hanyang.ac.kr
    # Date: November 30, 2023       
    def __init__(self, L1, L2,epsilon):
        self.L1 = L1
        self.L2 = L2
        self.COLLINEAR = 0
        self.DISTANT = 1
        self.INTERSECTED = 2
        self.SKEWED = 3
        self.epsilon = epsilon;
        self.criterion,self.type=self.get_type(L1,L2,epsilon)
        self.alpha = self.get_alpha(L1,L2)
        self.n = self.get_n(L1,L2,epsilon)
        self.a = self.get_a(L1,L2,epsilon)
        self.t1,self.t2 = self.get_feets(L1,L2,epsilon)
    def __str__(self):
        np.set_printoptions(suppress=True)
        str_type = ""
        if self.type ==0:
            str_type = "COLLINEAR   "
        elif self.type==1:
            str_type = "DISTANT    "
        elif self.type==2:
            str_type = "INTERSECTED"
        elif self.type==3:
            str_type = "SKEWED     "  

        str_="----------------------------------------------------------------------------\n"
        str_+= "type:"+str_type+"\t alpha :{:.4f}".format( self.alpha)+"\t n :{:.4f} {:.4f} {:.4f}".format( self.n[0],self.n[1],self.n[2])+"\t a :{:.4f}".format( self.a)+"\t \n t1 :{:.4f} {:.4f} {:.4f}".format( self.t1[0],self.t1[1],self.t1[2])+"\t t2 :{:.4f} {:.4f} {:.4f}".format( self.t2[0],self.t2[1],self.t2[2])
        str_+="\n----------------------------------------------------------------------------"
        return str_
    def print(self):
        str_type = ""
        if self.type ==0:
            str_type = "COLLINEAR   "
        elif self.type==1:
            str_type = "DISTANT    "
        elif self.type==2:
            str_type = "INTERSECTED"
        elif self.type==3:
            str_type = "SKEWED     "  
        print("type:",str_type,"\talpha :{:.4f}".format( self.alpha),"\t n :{:.4f} {:.4f} {:.4f}".format( self.n[0],self.n[1],self.n[2]),"\td :{:.4f}".format( self.a),"\t q1 :{:.4f} {:.4f} {:.4f}".format( self.t1[0],self.t1[1],self.t1[2]),"\t q2 :{:.4f} {:.4f} {:.4f}".format( self.t2[0],self.t2[1],self.t2[2]))
    
    def get_type(self,L1,L2,epsilon):
        type=-1;
        if Criterion1(L1,L2,epsilon):
            if Criterion2_1(L1,L2,epsilon):
                type=self.COLLINEAR;
            else:
                type=self.DISTANT;
        else:
            if Criterion2_2(L1,L2,epsilon):
                type=self.INTERSECTED;
            else:
                type=self.SKEWED;
        criterion=[Criterion1(L1,L2,epsilon),Criterion2_1(L1,L2,epsilon),Criterion2_2(L1,L2,epsilon)];
        return criterion,type
    def get_alpha(self,L1,L2):    
        return arctan2(norm(cross(L1.z_hat,L2.z_hat)),dot(L1.z_hat,L2.z_hat))
    def get_n(self,L1,L2,epsilon):
        n=np.zeros(3)
        criterion,type = self.get_type(L1,L2,epsilon);
        if type == self.COLLINEAR:
            n = np.zeros(3)
        elif type == self.DISTANT:
            alpha = self.get_alpha(L1,L2);   
            n = cross(self.L1.z_hat,(cos(alpha)*self.L2.v-self.L1.v))/norm(cross(self.L1.z_hat,(cos(alpha)*self.L2.v-self.L1.v)));
        elif type==self.INTERSECTED:
            n = cross(self.L1.z_hat,self.L2.z_hat)/norm(cross(self.L1.z_hat,self.L2.z_hat));
        elif type==self.SKEWED:
            n = cross(self.L1.z_hat,self.L2.z_hat)/norm(cross(self.L1.z_hat,self.L2.z_hat));
        return n;

    def get_feets(self,L1,L2,epsilon):
        t1 = np.zeros(3)
        t2 = np.zeros(3)
        criterion,type = self.get_type(L1,L2,epsilon);

        if type == self.COLLINEAR:
            t1 = self.L1.p;
            t2 = self.L1.p;
        elif type == self.DISTANT:
            alpha = self.get_alpha(L1,L2);
            L1= self.L1;
            L2= self.L2;            
            t1 = L1.p;
            t2 = L1.p+cross(L1.z_hat,(L2.v*cos(alpha)-L1.v));
        elif type==self.INTERSECTED:
            L1= self.L1;
            L2= self.L2;            
            t1 =((dot(L1.v,L2.z_hat)*np.eye(3)+outer(L1.z_hat,L2.v.T)-outer(L2.z_hat,L1.v.T))@cross(L1.z_hat,L2.z_hat))/norm(cross(L1.z_hat,L2.z_hat))/norm(cross(L1.z_hat,L2.z_hat))
            
            t2 = t1;   
        elif type==self.SKEWED:       
            L1= self.L1;
            L2= self.L2;
            t1=(cross(L1.v,cross(L2.z_hat,cross(L2.z_hat,L1.z_hat)))+dot(L2.v,cross(L1.z_hat,L2.z_hat))*L1.z_hat)/norm(cross(L1.z_hat,L2.z_hat))/norm(cross(L1.z_hat,L2.z_hat));
            t2=(cross(L2.v,cross(L1.z_hat,cross(L1.z_hat,L2.z_hat)))+dot(L1.v,cross(L2.z_hat,L1.z_hat))*L2.z_hat)/norm(cross(L2.z_hat,L1.z_hat))/norm(cross(L2.z_hat,L1.z_hat));        
        return t1,t2;                
    def get_a(self,L1,L2,epsilon):
        a = 0
        criterion,type = self.get_type(L1,L2,epsilon);
        if type ==self.COLLINEAR:
            a = 0
        elif type == self.DISTANT:
            alpha = self.get_alpha(L1,L2);
            a = norm(cross(self.L1.z_hat,cos(alpha)*self.L2.v-self.L1.v))
        elif type==self.INTERSECTED:
            a =-reciprocal_product(self.L1,self.L2)/norm(cross(self.L1.z_hat,self.L2.z_hat));
        elif type==self.SKEWED:
            a = -reciprocal_product(self.L1,self.L2)/norm(cross(self.L1.z_hat,self.L2.z_hat));
        return a
    def get_parameters(self):
        return self.alpha,self.a,self.n,self.t1,self.t2