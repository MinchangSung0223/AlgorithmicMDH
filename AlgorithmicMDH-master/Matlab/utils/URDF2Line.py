import numpy as np
from urdfpy import URDF 
#   Author: Minchang Sung
#   
#   pip install urdfpy
#   pip install networkx==2.8.4
#

def getJoint(robot,link_name):
	ret_link=[]
	for link in robot.links:
		if link.name == link_name:
			ret_link=link
			break;
	return ret_link
def TransToRp(T):
 	return np.array(T[0:3,0:3]),np.array(T[0:3,3])
class URDF2Line:
    def __init__(self, urdf_path):
        self.p_list=[]
        self.z_list=[]		
        robot = URDF.load(urdf_path)
        self.robot =robot
        base_link = getJoint(robot,robot.actuated_joints[0].parent)
        T_0 = robot.link_fk()[base_link]
        R_0,p_0 = TransToRp(T_0)
        self.p_0 = p_0
        self.z_0 = np.array(R_0 @ np.array([0,0,1]).T)		
        self.x_0 = np.array(R_0 @ np.array([1,0,0]).T)
		
        self.p_list.append(self.p_0)
        self.z_list.append(self.z_0)
        self.name = urdf_path
        for joint in robot.actuated_joints:
            child_link = getJoint(robot,joint.child)
            R,p = TransToRp(robot.link_fk()[child_link])
            self.p_list.append(p)
            child_M_R,child_M_p=TransToRp(robot.link_fk()[child_link])
            child_z = np.array(child_M_R @ np.array(joint.axis).T)
            #print(child_z)
            self.z_list.append( child_z ) 	
        tcf_link = getJoint(robot,robot.end_links[0].name)	
        Mtcf = robot.link_fk()[tcf_link]
        Mtcf_R,Mtcf_p=TransToRp(Mtcf)
        self.z_tcf = np.array(Mtcf_R @ np.array(joint.axis).T)
        self.p_tcf = Mtcf_p
        self.x_tcf = np.array(Mtcf_R @ np.array([1,0,0]).T)
    def show_robot(self):
        self.robot.show(cfg={ })

		