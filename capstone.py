from cProfile import label
import numpy as np
import matplotlib.pyplot as plt

distance = np.array([i for i in range(10,101,10)])
weighted_average1 = np.array([-2.75,-2.45,-2.25,-2.10,-2,-1.95,-1.85,-1.75,-1.58,-1.5])
weighted_average2 = np.array([-2.49,-2.25,-2,-1.90,-1.85,-1.75,-1.65,-1.58,-1.55,-1.5])
weighted_average3 = np.array([-2.25,-1.85,-1.60,-1.50,-1.45,-1.30,-1.25,-1.20,-1.10,-1.05])
weighted_average4 = np.array([-1.90,-1.5,-1.38,-1.25,-1.10,-1,-0.95,-0.85,-0.80,-0.75])





plt.figure(1)
plt.plot(distance,weighted_average1,marker='D',label='Coprime Accuracy') 
plt.plot(distance,weighted_average2,marker='D',label='Uniform Accuracy') 
plt.plot(distance,weighted_average3,marker='D',label = 'Coprime Resolution') 
plt.plot(distance,weighted_average4,marker='D',label='Uniform Resolution') 
plt.legend(loc="upper left")
plt.ylabel('Weighted Average', fontname = 'Gill Sans', fontsize = 14, fontweight ='bold')
plt.xlabel('Distance', fontname = 'Gill Sans', fontsize = 14,fontweight ='bold')
plt.xticks(fontsize = 16)
plt.yticks(fontsize = 16)

plt.figure(2)
plt.yscale('log')
x1 = [1e-4,5e-4,1.5e-3,3e-3,6e-3,8e-3,1.3e-2,1.9e-2,2.3e-2,3e-2]
x2 = [2e-4,1e-3,2e-3,4e-3,7e-3,1.2e-2,1.8e-2,2.4e-2,2.8e-2,3.2e-2]
x3 = [1e-3,3.5e-3,7e-3,1.2e-2,2e-2,2.9e-2,3.9e-2,5e-2,6e-2,7e-2]
plt.plot(distance,x1,marker='D',label='Coprime Accuracy')
plt.plot(distance,x2,marker='D',label='Coprime Resolution')
plt.plot(distance,x3,marker='D',label='Uniform Accuracy')
plt.legend(loc="upper left")
plt.ylabel('Communication Distortion', fontname = 'Gill Sans', fontsize = 14, fontweight ='bold')
plt.xlabel('Distance', fontname = 'Gill Sans', fontsize = 14,fontweight ='bold')

plt.figure(3)
plt.yscale('log')
y1 = [5e-4,1.4e-3,1.8e-3,2e-3,3e-3,5e-3,6e-3,7.5e-3,1.5e-2,2.2e-2]
y2 = [2.7e-3,3e-3,4e-3,4.8e-3,5e-3,7e-3,9e-3,1e-2,1.6e-2,1.95e-2]
y3 = [4e-2,4.5e-2,5e-2,5.5e-2,5.3e-2,6e-2,7.5e-2,8e-2,1e-1,1.2e-1]
y4 = [1.7e-1,1.9e-1,2e-1,2.2e-1,2.4e-1,2.8e-1,3e-1,3.2e-1,4e-1,4.8e-1]
plt.plot(distance,y1,marker='D',label='Coprime Accuracy')
plt.plot(distance,y2,marker='D',label='Coprime Resolution')
plt.plot(distance,y3,marker='D',label='Uniform Accuracy')
plt.plot(distance,y4,marker='D',label='Uniform Resolution')
plt.legend(loc="upper left")
plt.ylabel('Velocity Error (m/s)', fontname = 'Gill Sans', fontsize = 14, fontweight ='bold')
plt.xlabel('Distance', fontname = 'Gill Sans', fontsize = 14,fontweight ='bold')


plt.xticks(fontsize = 16)
plt.yticks(fontsize = 16)
plt.show() 