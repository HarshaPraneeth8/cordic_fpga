# Implementation of CORDIC Algorithm on FPGA
This repo includes the project files and instructions to implement the CORDIC algorithm on Nexys 4 DDR FPGA

The CORDIC Algorithm was developed by Jack E. Volder. CORDIC stands for COordinate Rotation Digital Computer is a special-purpose digital computer for real-time airborne computation. In this computer, a unique computing technique is employed , which is especially suitable for solving the trigonometric relationships involved in plane coordinate rotation and conversion from rectangular to polar coordinates. There are two computing modes present, ROTATION and VECTORING. In the ROTATION mode, the coordinate components of a vector and an angle of rotation are given and the coordinate components of the original vector, after rotation are computed. In the second mode, VECTORING, the coordinate components of a vector are given and the magnitude and angular argument of the original vector are computed. Feedback is employed in the VECTORING mode.

CORDIC is an iterative algorithm that can be used for efficient computation of sine and cosine (among other usecases) values. Using the CORDIC algorithm mitigates the use for multipliers, which often limited and require more computing power. The CORDIC approach uses only adders and shift registers for computation.

In this project, the CORDIC algorithm was implemented on the **Nexys 4 DDR** board (xc7a100tcsg324-1) and the output was taken from the PMOD DA1 DAC and finally visualized on an oscilloscope.
File descriptions:

- **pmod_da1_ctrlr**: This is the controller block for the external digital to analog converter (PMOD DA1)
- **counter**: This is the stimulus file that drives the xilinx cordic IP and also tells the controller when to display the output
- **sep1**: The CORDIC IP core produces a 16 bit output in which the top 8 bits represent the sine output and the bottom 8 bits represent the cosine output, this module is used to split the outputs and send them into the 2 channels of the controller block

The Vivado design suite IP integrator was exclusively used to integrate all the above modules. 
- The clocking wizard is used to generate 2 clocks, a 100MHz and a 25MHz clock, and the reset pin is set to active low
- The following parameters are set for the CORDIC IP:
  - Functional selection: sin and cos
  - Architectural configuration: parallel
  - Pipelining mode: maximum
  - Data format: signed fraction
  - Phase format: Radians
  - Input width, output width: 8 bits
  - Round mode: Truncate
  - Iterations and precision is set to 0, this allows for automatic selection by the CORDIC IP
  - Coarse rotation: enabled, enabling this allows the CORDIC IP to perform computations from -pi to +pi
- An additional constant block of value 1 is used to enable the input of the CORDIC IP
- The output m_axis_dout_tvalid can be ignored
- The remaining ports are connected as shown and some are made as external pins
The blocks, were connected as shown below:
![image](https://github.com/HarshaPraneeth8/cordic_fpga/assets/72025415/381a2aa6-80cc-4642-8a36-a03f61c2d0dc)
