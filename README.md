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
- The clocking wizard can be used in one of 2 different ways:
  - Using MMCM, the desired input clock rate can be set and an output sine wave can be generated, the disadvantage to this approach is that we do not have total control over the output frequency
  - The second method is to create a clock divider and obtain the required input clock frequency corresponding to the output required.
- This project follows the second approach, and the required output sine frequency is 50Hz, corresponding to this, the required input frequency is 212.77KHz
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
- The clocking wizard IP can be completely removed and the clk_div module can be directly connected to the E3 pin of Nexys 4 DDR. I have used the clocking wizard only for the purpose of the RESET function which i tied off to an external port.
![image](https://github.com/HarshaPraneeth8/cordic_fpga/assets/72025415/07249eb5-1498-4a8b-99f4-ce4db0bda42e)

- A HDL Wrapper is created and set as the top module, simulating the block design (simulation is done by creating multiple external pins), the output is as shown:
![image](https://github.com/HarshaPraneeth8/cordic_fpga/assets/72025415/083c7480-a95a-4dc7-b31f-93465c122350)

- The implementation results are as follows:
  - Less than 1 percent of the total available LUTs were used
![image](https://github.com/HarshaPraneeth8/cordic_fpga/assets/72025415/52b1d27c-5a21-4811-b08d-4cbe5bd4e3ea)

- The following constraints can be used to get the output from the JA header:

```python
set_property PACKAGE_PIN E3 [get_ports clk_100MHz]
set_property IOSTANDARD LVCMOS33 [get_ports clk_100MHz]
set_property PACKAGE_PIN J15 [get_ports reset_rtl_0]
set_property IOSTANDARD LVCMOS33 [get_ports reset_rtl_0]
set_property PACKAGE_PIN C17 [get_ports sync_0]
set_property PACKAGE_PIN D18 [get_ports sd00_0]
set_property PACKAGE_PIN E18 [get_ports sd11_0]
set_property IOSTANDARD LVCMOS33 [get_ports sd00_0]
set_property IOSTANDARD LVCMOS33 [get_ports sd11_0]
set_property IOSTANDARD LVCMOS33 [get_ports sync_0]
set_property PACKAGE_PIN G17 [get_ports sclk]
set_property IOSTANDARD LVCMOS33 [get_ports sclk]
```
- The connections are made as shown below:
![3](https://github.com/HarshaPraneeth8/cordic_fpga/assets/72025415/5487ed13-d428-4187-bd2d-2647bebc2cd2)
- The output on the oscilloscope is:
![sine-op-cordic_1](https://github.com/HarshaPraneeth8/cordic_fpga/assets/72025415/9df7a7fd-19c8-4809-a9e4-7dd1ee7660b6)


- It is to be noted that the full range of the DAC is not used in this case, The PMOD DA1 is a 8bit DAC, however, due to number represenation formats of the CORDIC IP, to avoid overflow condition, the entire wave is shifted by 128 instead of 256.
- This results in a resulting output waveform with origin at 0.4v and peak to peak voltage of approximately 0.8v(The range of DAC is from 0 to 1.65V(0 - Vcc/2)

# References
- PMOD_DA1_ctrlr: https://staff.fysik.su.se/~silver/digsyst/lab7.html
- PMOD DA1: https://digilent.com/reference/pmod/pmodda1/start
- Nexys 4 DDR: https://digilent.com/reference/programmable-logic/nexys-4-ddr/reference-manual
- CORDIC: https://ieeexplore.ieee.org/document/5222693
- Xilinx CORDIC IP: https://docs.xilinx.com/v/u/en-US/pg105-cordic
