import pybullet as p
import numpy as np
import time
from Plotter import Plotter
from MDH import MDH
from ForwardKinematics import ForwardKinematics
class PbSim:
    def __init__(self,MDH,urdf_name):
        self.MDH=MDH
        self.urdf_name = urdf_name;

        FK = ForwardKinematics(self.MDH)
        p.connect(p.GUI)
        robotId = p.loadURDF(urdf_name)
        p.resetDebugVisualizerCamera(2,90,-10,[0,0,0.0])
        p.configureDebugVisualizer(p.COV_ENABLE_GUI,0)
        #print(p.getNumJoints(robotId))
        actuated_joint_list = []
        joint_type_list = []
        joint_lower_limit = []
        joint_upper_limit = []
        for i in range(0,p.getNumJoints(robotId)):
            ret = p.getJointInfo(robotId,i)
            if ret[2]==0 :
                actuated_joint_list.append(ret[0])
                joint_type_list.append(0)
            elif ret[2]==1 :
                actuated_joint_list.append(ret[0])
                joint_type_list.append(1)
            joint_lower_limit.append(ret[8])
            joint_upper_limit.append(ret[9])
        #print(joint_type_list)      
        #print("joint lower_limit : ",joint_lower_limit)          
        #print("joint upper_limit : ",joint_upper_limit)          
        TPlotter = Plotter(p,0.1,len(actuated_joint_list)+1)
        FK = ForwardKinematics(MDH)
        t=0
        dt = 0.001
        while(1):
            t = t+dt
            ret = p.getJointStates(robotId,actuated_joint_list)
            thetalist = np.zeros(len(actuated_joint_list))
            
            for i in range(0,len(actuated_joint_list)):
                thetalist[i]=ret[i][0]
                p.setJointMotorControl2(robotId,actuated_joint_list[i],p.POSITION_CONTROL,targetPosition=0*np.sin(2*3.141592*t))

            
            
            #thetalist[5] =-thetalist[5] 
            #print(thetalist)
            T_list = FK.calc_T_list(thetalist,joint_type_list)
            #print(T_list[5])
            TPlotter.draw_T_list(T_list)
            time.sleep(0.001)
            p.stepSimulation()        


    