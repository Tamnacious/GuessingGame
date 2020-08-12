## Clock signal
set_property PACKAGE_PIN W5 [get_ports clock]       
set_property IOSTANDARD LVCMOS33 [get_ports clock]
#Reset BUTTON
set_property PACKAGE_PIN R2 [get_ports reset]     
set_property IOSTANDARD LVCMOS33 [get_ports reset]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets BTN_IBUF[4]]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets BTN_IBUF[3]]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets BTN_IBUF[2]]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets BTN_IBUF[1]]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets BTN_IBUF[0]]
# Switches
set_property PACKAGE_PIN V17 [get_ports {SW[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[0]}]
set_property PACKAGE_PIN V16 [get_ports {SW[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[1]}]
set_property PACKAGE_PIN W16 [get_ports {SW[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[2]}]
set_property PACKAGE_PIN W17 [get_ports {SW[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[3]}]


# LEDs
set_property PACKAGE_PIN U16 [get_ports {LED[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property PACKAGE_PIN E19 [get_ports {LED[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property PACKAGE_PIN U19 [get_ports {LED[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property PACKAGE_PIN V19 [get_ports {LED[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]

set_property PACKAGE_PIN L1 [get_ports GAME]    
set_property IOSTANDARD LVCMOS33 [get_ports GAME]

#7 segment display
#Bank = 34, Pin name = , Sch name = CA
set_property PACKAGE_PIN W7 [get_ports {SSEG[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG[0]}]
#Bank = 34, Pin name = , Sch name = CB
set_property PACKAGE_PIN W6 [get_ports {SSEG[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG[1]}]
#Bank = 34, Pin name = , Sch name = CC
set_property PACKAGE_PIN U8 [get_ports {SSEG[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG[2]}]
#Bank = 34, Pin name = , Sch name = CD
set_property PACKAGE_PIN V8 [get_ports {SSEG[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG[3]}]
#Bank = 34, Pin name = , Sch name = CE
set_property PACKAGE_PIN U5 [get_ports {SSEG[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG[4]}]
#Bank = 34, Pin name = , Sch name = CF
set_property PACKAGE_PIN V5 [get_ports {SSEG[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG[5]}]
#Bank = 34, Pin name = , Sch name = CG
set_property PACKAGE_PIN U7 [get_ports {SSEG[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG[6]}]
#Bank = 34, Pin name = , Sch name = DP
set_property PACKAGE_PIN V7 [get_ports {SSEG[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG[7]}]

#------------------ANODE-------------------
#Bank = 34, Pin name = , Sch name = AN0
set_property PACKAGE_PIN U2 [get_ports {SSEG_AN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[0]}]
#Bank = 34, Pin name = , Sch name = AN1
set_property PACKAGE_PIN U4 [get_ports {SSEG_AN[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[1]}]
#Bank = 34, Pin name = , Sch name = AN2
set_property PACKAGE_PIN V4 [get_ports {SSEG_AN[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[2]}]
#Bank = 34, Pin name = , Sch name = AN3
set_property PACKAGE_PIN W4 [get_ports {SSEG_AN[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[3]}]

#Bank = 14, Pin name = ,					Sch name = BTNC
set_property PACKAGE_PIN U18 [get_ports {BTN[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTN[4]}]
#Bank = 14, Pin name = ,					Sch name = BTNU
set_property PACKAGE_PIN T18 [get_ports {BTN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTN[0]}]
#Bank = 14, Pin name = ,	Sch name = BTNL
set_property PACKAGE_PIN W19 [get_ports {BTN[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTN[1]}]
#Bank = 14, Pin name = ,							Sch name = BTNR
set_property PACKAGE_PIN T17 [get_ports {BTN[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTN[2]}]
#Bank = 14, Pin name = ,					Sch name = BTND
set_property PACKAGE_PIN U17 [get_ports {BTN[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTN[3]}]
