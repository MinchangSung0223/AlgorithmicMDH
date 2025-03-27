import math
import numpy as np
from numpy import cross,dot,sin,cos,arctan2
from numpy.linalg import norm

def vecToso3(x):
    ret = np.array([[0, -x[2], x[1]],
                    [x[2], 0, -x[0]],
                    [-x[1], x[0], 0]])
    return ret
def normvec(vec):
    ret = vec/norm(vec);
    return ret;
class Line:
    def __init__(self, z, p):
        self.z = np.reshape(np.array(z),[3]);
        self.z_hat = normvec(self.z);
        self.p = np.reshape(np.array(p),[3]);
        self.v = cross(self.p,self.z_hat);
        self.z_ceil = vecToso3(self.z_hat);
        self.v_ceil = vecToso3(self.v);
        self.p_perp= cross(self.z_hat , self.v);
    def print(self):
        print("direction vector : ",self.z)
        print("position vector : ",self.p)
        print("moment vector : ",self.v)
    def __str__(self):
        np.set_printoptions(suppress=True)
        str_="------------------------------------------------------\ndirection vector : "+str(np.array(self.z))+"\nposition vector : "+str(np.array(self.p))+"\nmoment vector : "+str(np.array(self.v))
        return str_