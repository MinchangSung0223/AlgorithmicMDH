
import numpy as np

class Plotter:
    def __init__(self, p,line_length,num_joint):
        self.p = p;
        self.num_joint = num_joint;
        self.line_width =1
        self.line_length = line_length;
        self.line_x_id_list= []
        self.line_y_id_list= []
        self.line_z_id_list= []
        for i in range(0,num_joint):
            line_p=[0,0,0];
            line_px=[0,0,0];
            line_py=[0,0,0];
            line_pz=[0,0,0];
            line_x_id =  self.p.addUserDebugLine(lineFromXYZ=line_p,
                            lineToXYZ=line_px,
                            lineColorRGB=[1,0,0],
                            lineWidth=self.line_width,
                            lifeTime=0)
            line_y_id =  self.p.addUserDebugLine(lineFromXYZ=line_p,
                            lineToXYZ=line_py,
                            lineColorRGB=[0,1,0],
                            lineWidth=self.line_width,
                            lifeTime=0)
            line_z_id =  self.p.addUserDebugLine(lineFromXYZ=line_p,
                            lineToXYZ=line_pz,
                            lineColorRGB=[0,0,1],
                            lineWidth=self.line_width,
                            lifeTime=0) 
            self.line_x_id_list.append(line_x_id);
            self.line_y_id_list.append(line_y_id);
            self.line_z_id_list.append(line_z_id);
    def draw_T_list(self,transform_matrices):
        for i in range(0,self.num_joint):
            T = transform_matrices[i]
            line_p = T[0:3,3];
            line_px = T@np.array([self.line_length,0,0,1]).T
            line_py = T@np.array([0.0,self.line_length,0,1]).T
            line_pz = T@np.array([0.0,0,self.line_length,1]).T

            line_p = [line_p[0],line_p[1],line_p[2]]
            line_px = [line_px[0],line_px[1],line_px[2]]
            line_py = [line_py[0],line_py[1],line_py[2]]
            line_pz = [line_pz[0],line_pz[1],line_pz[2]]
            line_x_id =  self.p.addUserDebugLine(lineFromXYZ=line_p,
                        lineToXYZ=line_px,
                        lineColorRGB=[1,0,0],
                        lineWidth=self.line_width,
                        lifeTime=0,replaceItemUniqueId =self.line_x_id_list[i])
            line_y_id =  self.p.addUserDebugLine(lineFromXYZ=line_p,
                        lineToXYZ=line_py,
                        lineColorRGB=[0,1,0],
                        lineWidth=self.line_width,
                        lifeTime=0,replaceItemUniqueId =self.line_y_id_list[i])
            line_z_id =  self.p.addUserDebugLine(lineFromXYZ=line_p,
                        lineToXYZ=line_pz,
                        lineColorRGB=[0,0,1],
                        lineWidth=self.line_width,
                        lifeTime=0,
                        replaceItemUniqueId =self.line_z_id_list[i]) 


            
