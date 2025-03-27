# This  is urdf demo file 
# Author: Minchang Sung 
# E-mail: wdrac331@hanyang.ac.kr
# Date: November 30, 2023      

from Line import Line
from LineGeometry import LineGeometry
from URDF2Line import URDF2Line
from AlgorithmicMDH import AlgorithmicMDH
from Plotter import Plotter
from PbSim import PbSim
import numpy as np

# you can change urdf_name
urdf_name = "urdf/indy7/indy7.urdf"
#urdf_name = "urdf/kuka_iiwa/kuka_iiwa.urdf"
#urdf_name = "urdf/ur5/ur5.urdf"
#urdf_name = "urdf/kuka_lwr/kuka.urdf"
#urdf_name = "urdf/softrobot_urdf/softarm_urdf(p)_test.urdf"
#urdf_name ="urdf/scara/scara.urdf"
urdf=URDF2Line(urdf_name)

ADH = AlgorithmicMDH(urdf.z_list,urdf.p_list,urdf.z_tcf,urdf.p_tcf,urdf.x_tcf,urdf.x_0)
print("=================MDH RESULT================")
print(ADH.MDH)
PbSim(ADH.MDH,urdf_name)


