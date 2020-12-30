EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Connector_Generic:Conn_02x25_Odd_Even J1
U 1 1 5FD62DCD
P 2500 3450
F 0 "J1" H 2550 4867 50  0000 C CNN
F 1 "Conn_01x40" H 2550 4776 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x25_P2.54mm_Horizontal" H 2500 3450 50  0001 C CNN
F 3 "~" H 2500 3450 50  0001 C CNN
	1    2500 3450
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0101
U 1 1 5FD64472
P 3000 3350
F 0 "#PWR0101" H 3000 3200 50  0001 C CNN
F 1 "+5V" H 3015 3523 50  0000 C CNN
F 2 "" H 3000 3350 50  0001 C CNN
F 3 "" H 3000 3350 50  0001 C CNN
	1    3000 3350
	1    0    0    -1  
$EndComp
Wire Wire Line
	3000 3350 2800 3350
$Comp
L power:+5V #PWR0102
U 1 1 5FD65A34
P 2000 3450
F 0 "#PWR0102" H 2000 3300 50  0001 C CNN
F 1 "+5V" H 2015 3623 50  0000 C CNN
F 2 "" H 2000 3450 50  0001 C CNN
F 3 "" H 2000 3450 50  0001 C CNN
	1    2000 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	2300 3450 2050 3450
$Comp
L power:GND #PWR0103
U 1 1 5FD65E00
P 3000 3450
F 0 "#PWR0103" H 3000 3200 50  0001 C CNN
F 1 "GND" H 3005 3277 50  0000 C CNN
F 2 "" H 3000 3450 50  0001 C CNN
F 3 "" H 3000 3450 50  0001 C CNN
	1    3000 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	3000 3450 2800 3450
$Comp
L power:GND #PWR0104
U 1 1 5FD66D1A
P 1850 3300
F 0 "#PWR0104" H 1850 3050 50  0001 C CNN
F 1 "GND" H 1855 3127 50  0000 C CNN
F 2 "" H 1850 3300 50  0001 C CNN
F 3 "" H 1850 3300 50  0001 C CNN
	1    1850 3300
	1    0    0    -1  
$EndComp
Wire Wire Line
	2100 3350 2100 3300
Wire Wire Line
	2100 3300 1850 3300
Wire Wire Line
	2100 3350 2300 3350
Text GLabel 2300 2250 0    50   Input ~ 0
A0
Text GLabel 2300 2350 0    50   Input ~ 0
A1
Text GLabel 2300 2450 0    50   Input ~ 0
A2
Text GLabel 2300 2550 0    50   Input ~ 0
A3
Text GLabel 2300 2650 0    50   Input ~ 0
A4
Text GLabel 2300 2750 0    50   Input ~ 0
A5
Text GLabel 2300 2850 0    50   Input ~ 0
A6
Text GLabel 2300 2950 0    50   Input ~ 0
A7
Text GLabel 2300 3050 0    50   Input ~ 0
A8
Text GLabel 2300 3150 0    50   Input ~ 0
A9
Text GLabel 2300 3250 0    50   Input ~ 0
A10
Text GLabel 2300 3550 0    50   Input ~ 0
A11
Text GLabel 2300 3650 0    50   Input ~ 0
A12
Text GLabel 2300 3750 0    50   Input ~ 0
A13
Text GLabel 2300 3850 0    50   Input ~ 0
A14
Text GLabel 2300 3950 0    50   Input ~ 0
A15
Text GLabel 2800 2250 2    50   BiDi ~ 0
D0
Text GLabel 2800 2350 2    50   BiDi ~ 0
D1
Text GLabel 2800 2450 2    50   BiDi ~ 0
D2
Text GLabel 2800 2550 2    50   BiDi ~ 0
D3
Text GLabel 2800 2650 2    50   BiDi ~ 0
D4
Text GLabel 2800 2750 2    50   BiDi ~ 0
D5
Text GLabel 2800 2850 2    50   BiDi ~ 0
D6
Text GLabel 2800 2950 2    50   BiDi ~ 0
D7
Text GLabel 2300 4650 0    50   Input ~ 0
RESET
Text GLabel 2800 4650 2    50   BiDi ~ 0
NMI
Text GLabel 1750 4050 0    50   Input ~ 0
RDY
Text GLabel 1750 4150 0    50   Input ~ 0
BE
Text GLabel 2300 4250 0    50   Input ~ 0
CLK
Text GLabel 2300 4350 0    50   Input ~ 0
RW
Text GLabel 2300 4550 0    50   Input ~ 0
SYNC
Text GLabel 1750 4450 0    50   Input ~ 0
IRQ
Text GLabel 2800 4550 2    50   BiDi ~ 0
IRQ0
Text GLabel 2800 4450 2    50   BiDi ~ 0
IRQ1
Text GLabel 2800 4350 2    50   BiDi ~ 0
IRQ2
Text GLabel 2800 4250 2    50   BiDi ~ 0
IRQ3
Wire Wire Line
	2050 3500 2050 3450
Connection ~ 2050 3450
Wire Wire Line
	2050 3450 2000 3450
Wire Wire Line
	1750 4450 2300 4450
Wire Wire Line
	1750 4050 2300 4050
Wire Wire Line
	1750 4150 2300 4150
Text GLabel 2800 3550 2    50   BiDi ~ 0
EX3
Text GLabel 2800 3650 2    50   BiDi ~ 0
EX4
Text GLabel 2800 3750 2    50   BiDi ~ 0
EX5
Text GLabel 2800 3850 2    50   BiDi ~ 0
EX6
Text GLabel 2800 3950 2    50   BiDi ~ 0
EX7
Text GLabel 2800 4050 2    50   BiDi ~ 0
EX8
Text GLabel 2800 4150 2    50   BiDi ~ 0
EX9
Text GLabel 2800 3050 2    50   BiDi ~ 0
EX0
Text GLabel 2800 3150 2    50   BiDi ~ 0
EX1
Text GLabel 2800 3250 2    50   BiDi ~ 0
EX2
$Comp
L Memory_EEPROM:28C256 U2
U 1 1 5FD6808B
P 5000 3400
F 0 "U2" H 5000 4681 50  0000 C CNN
F 1 "28C256" H 5000 4590 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm_Socket" H 5000 3400 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/doc0006.pdf" H 5000 3400 50  0001 C CNN
	1    5000 3400
	1    0    0    -1  
$EndComp
Text GLabel 5400 2500 2    50   BiDi ~ 0
D0
Text GLabel 5400 2600 2    50   BiDi ~ 0
D1
Text GLabel 5400 2700 2    50   BiDi ~ 0
D2
Text GLabel 5400 2800 2    50   BiDi ~ 0
D3
Text GLabel 5400 2900 2    50   BiDi ~ 0
D4
Text GLabel 5400 3000 2    50   BiDi ~ 0
D5
Text GLabel 5400 3100 2    50   BiDi ~ 0
D6
Text GLabel 5400 3200 2    50   BiDi ~ 0
D7
Text GLabel 4600 2500 0    50   Input ~ 0
A0
Text GLabel 4600 2600 0    50   Input ~ 0
A1
Text GLabel 4600 2700 0    50   Input ~ 0
A2
Text GLabel 4600 2800 0    50   Input ~ 0
A3
Text GLabel 4600 2900 0    50   Input ~ 0
A4
Text GLabel 4600 3000 0    50   Input ~ 0
A5
Text GLabel 4600 3100 0    50   Input ~ 0
A6
Text GLabel 4600 3200 0    50   Input ~ 0
A7
Text GLabel 4600 3300 0    50   Input ~ 0
A8
Text GLabel 4600 3400 0    50   Input ~ 0
A9
Text GLabel 4600 3500 0    50   Input ~ 0
A10
Text GLabel 4600 3600 0    50   Input ~ 0
A11
Text GLabel 4600 3700 0    50   Input ~ 0
A12
Text GLabel 4600 3800 0    50   Input ~ 0
A13
Text GLabel 4600 3900 0    50   Input ~ 0
A14
$Comp
L Device:R_Small R1
U 1 1 5FD6A62A
P 4300 4100
F 0 "R1" V 4104 4100 50  0000 C CNN
F 1 "R_Small" V 4195 4100 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 4300 4100 50  0001 C CNN
F 3 "~" H 4300 4100 50  0001 C CNN
	1    4300 4100
	0    1    1    0   
$EndComp
Wire Wire Line
	4600 4100 4400 4100
$Comp
L power:+5V #PWR0105
U 1 1 5FD6BCBD
P 4050 4100
F 0 "#PWR0105" H 4050 3950 50  0001 C CNN
F 1 "+5V" H 4065 4273 50  0000 C CNN
F 2 "" H 4050 4100 50  0001 C CNN
F 3 "" H 4050 4100 50  0001 C CNN
	1    4050 4100
	1    0    0    -1  
$EndComp
Wire Wire Line
	4200 4100 4050 4100
$Comp
L power:+5V #PWR0106
U 1 1 5FD6C766
P 5000 1850
F 0 "#PWR0106" H 5000 1700 50  0001 C CNN
F 1 "+5V" H 5015 2023 50  0000 C CNN
F 2 "" H 5000 1850 50  0001 C CNN
F 3 "" H 5000 1850 50  0001 C CNN
	1    5000 1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	5000 2300 5000 1950
$Comp
L Device:C_Small C1
U 1 1 5FD6CE4E
P 5200 1950
F 0 "C1" V 4971 1950 50  0000 C CNN
F 1 "C_Small" V 5062 1950 50  0000 C CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 5200 1950 50  0001 C CNN
F 3 "~" H 5200 1950 50  0001 C CNN
	1    5200 1950
	0    1    1    0   
$EndComp
Wire Wire Line
	5100 1950 5000 1950
Connection ~ 5000 1950
Wire Wire Line
	5000 1950 5000 1850
$Comp
L power:GND #PWR0107
U 1 1 5FD6DE1D
P 5000 4600
F 0 "#PWR0107" H 5000 4350 50  0001 C CNN
F 1 "GND" H 5005 4427 50  0000 C CNN
F 2 "" H 5000 4600 50  0001 C CNN
F 3 "" H 5000 4600 50  0001 C CNN
	1    5000 4600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0108
U 1 1 5FD6E442
P 5300 1950
F 0 "#PWR0108" H 5300 1700 50  0001 C CNN
F 1 "GND" H 5305 1777 50  0000 C CNN
F 2 "" H 5300 1950 50  0001 C CNN
F 3 "" H 5300 1950 50  0001 C CNN
	1    5300 1950
	1    0    0    -1  
$EndComp
$Comp
L Memory_RAM:HM62256BLP U3
U 1 1 5FD76293
P 6950 3150
F 0 "U3" H 6950 4231 50  0000 C CNN
F 1 "IDT71256SA15" H 6950 4140 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W7.62mm_Socket" H 6950 3050 50  0001 C CNN
F 3 "https://web.mit.edu/6.115/www/document/62256.pdf" H 6950 3050 50  0001 C CNN
	1    6950 3150
	1    0    0    -1  
$EndComp
Text GLabel 6450 2450 0    50   Input ~ 0
A0
Text GLabel 6450 2550 0    50   Input ~ 0
A1
Text GLabel 6450 2650 0    50   Input ~ 0
A2
Text GLabel 6450 2750 0    50   Input ~ 0
A3
Text GLabel 6450 2850 0    50   Input ~ 0
A4
Text GLabel 6450 2950 0    50   Input ~ 0
A5
Text GLabel 6450 3050 0    50   Input ~ 0
A6
Text GLabel 6450 3150 0    50   Input ~ 0
A7
Text GLabel 6450 3250 0    50   Input ~ 0
A8
Text GLabel 6450 3350 0    50   Input ~ 0
A9
Text GLabel 6450 3450 0    50   Input ~ 0
A10
Text GLabel 6450 3550 0    50   Input ~ 0
A11
Text GLabel 6450 3650 0    50   Input ~ 0
A12
Text GLabel 6450 3750 0    50   Input ~ 0
A13
Text GLabel 6450 3850 0    50   Input ~ 0
A14
Text GLabel 7450 2450 2    50   BiDi ~ 0
D0
Text GLabel 7450 2550 2    50   BiDi ~ 0
D1
Text GLabel 7450 2650 2    50   BiDi ~ 0
D2
Text GLabel 7450 2750 2    50   BiDi ~ 0
D3
Text GLabel 7450 2850 2    50   BiDi ~ 0
D4
Text GLabel 7450 2950 2    50   BiDi ~ 0
D5
Text GLabel 7450 3050 2    50   BiDi ~ 0
D6
Text GLabel 7450 3150 2    50   BiDi ~ 0
D7
$Comp
L 74xx:74LS00 U1
U 1 1 5FD77888
P 9000 3550
F 0 "U1" H 9000 3875 50  0000 C CNN
F 1 "74LS00" H 9000 3784 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 9000 3550 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74ls00" H 9000 3550 50  0001 C CNN
	1    9000 3550
	-1   0    0    1   
$EndComp
$Comp
L 74xx:74LS00 U1
U 2 1 5FD78A60
P 8150 3650
F 0 "U1" H 8150 3975 50  0000 C CNN
F 1 "74LS00" H 8150 3884 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 8150 3650 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74ls00" H 8150 3650 50  0001 C CNN
	2    8150 3650
	-1   0    0    1   
$EndComp
$Comp
L 74xx:74LS00 U1
U 3 1 5FD79B19
P 3950 4400
F 0 "U1" H 3950 4725 50  0000 C CNN
F 1 "74LS00" H 3950 4634 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 3950 4400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74ls00" H 3950 4400 50  0001 C CNN
	3    3950 4400
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS00 U1
U 4 1 5FD7BAAC
P 9150 1050
F 0 "U1" H 9150 1375 50  0000 C CNN
F 1 "74LS00" H 9150 1284 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 9150 1050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74ls00" H 9150 1050 50  0001 C CNN
	4    9150 1050
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS00 U1
U 5 1 5FD7D4B8
P 9950 1900
F 0 "U1" H 10180 1946 50  0000 L CNN
F 1 "74LS00" H 10180 1855 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 9950 1900 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74ls00" H 9950 1900 50  0001 C CNN
	5    9950 1900
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0109
U 1 1 5FD8049D
P 6950 1800
F 0 "#PWR0109" H 6950 1650 50  0001 C CNN
F 1 "+5V" H 6965 1973 50  0000 C CNN
F 2 "" H 6950 1800 50  0001 C CNN
F 3 "" H 6950 1800 50  0001 C CNN
	1    6950 1800
	1    0    0    -1  
$EndComp
Wire Wire Line
	6950 2250 6950 1900
$Comp
L Device:C_Small C2
U 1 1 5FD804A4
P 7150 1900
F 0 "C2" V 6921 1900 50  0000 C CNN
F 1 "C_Small" V 7012 1900 50  0000 C CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 7150 1900 50  0001 C CNN
F 3 "~" H 7150 1900 50  0001 C CNN
	1    7150 1900
	0    1    1    0   
$EndComp
Wire Wire Line
	7050 1900 6950 1900
Connection ~ 6950 1900
Wire Wire Line
	6950 1900 6950 1800
$Comp
L power:GND #PWR0110
U 1 1 5FD804AD
P 7250 1900
F 0 "#PWR0110" H 7250 1650 50  0001 C CNN
F 1 "GND" H 7255 1727 50  0000 C CNN
F 2 "" H 7250 1900 50  0001 C CNN
F 3 "" H 7250 1900 50  0001 C CNN
	1    7250 1900
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0111
U 1 1 5FD81775
P 9950 950
F 0 "#PWR0111" H 9950 800 50  0001 C CNN
F 1 "+5V" H 9965 1123 50  0000 C CNN
F 2 "" H 9950 950 50  0001 C CNN
F 3 "" H 9950 950 50  0001 C CNN
	1    9950 950 
	1    0    0    -1  
$EndComp
Wire Wire Line
	9950 1400 9950 1050
$Comp
L Device:C_Small C3
U 1 1 5FD8177C
P 10150 1050
F 0 "C3" V 9921 1050 50  0000 C CNN
F 1 "C_Small" V 10012 1050 50  0000 C CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 10150 1050 50  0001 C CNN
F 3 "~" H 10150 1050 50  0001 C CNN
	1    10150 1050
	0    1    1    0   
$EndComp
Wire Wire Line
	10050 1050 9950 1050
Connection ~ 9950 1050
Wire Wire Line
	9950 1050 9950 950 
$Comp
L power:GND #PWR0112
U 1 1 5FD81785
P 10250 1050
F 0 "#PWR0112" H 10250 800 50  0001 C CNN
F 1 "GND" H 10255 877 50  0000 C CNN
F 2 "" H 10250 1050 50  0001 C CNN
F 3 "" H 10250 1050 50  0001 C CNN
	1    10250 1050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0113
U 1 1 5FD81E49
P 9950 2400
F 0 "#PWR0113" H 9950 2150 50  0001 C CNN
F 1 "GND" H 9955 2227 50  0000 C CNN
F 2 "" H 9950 2400 50  0001 C CNN
F 3 "" H 9950 2400 50  0001 C CNN
	1    9950 2400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0114
U 1 1 5FD82675
P 6950 4150
F 0 "#PWR0114" H 6950 3900 50  0001 C CNN
F 1 "GND" H 6955 3977 50  0000 C CNN
F 2 "" H 6950 4150 50  0001 C CNN
F 3 "" H 6950 4150 50  0001 C CNN
	1    6950 4150
	1    0    0    -1  
$EndComp
Wire Wire Line
	5000 4500 5000 4550
Wire Wire Line
	4600 4200 4450 4200
Wire Wire Line
	4450 4200 4450 4550
Wire Wire Line
	4450 4550 5000 4550
Connection ~ 5000 4550
Wire Wire Line
	5000 4550 5000 4600
Wire Wire Line
	4250 4400 4300 4400
Wire Wire Line
	4300 4400 4300 4300
Wire Wire Line
	4300 4300 4600 4300
Text GLabel 3650 4300 0    50   Input ~ 0
A15
Text GLabel 3650 4500 0    50   Input ~ 0
A15
Text GLabel 7450 3350 2    50   Input ~ 0
A15
Wire Wire Line
	6950 4150 6950 4100
Wire Wire Line
	6950 4100 7650 4100
Wire Wire Line
	7650 4100 7650 3550
Wire Wire Line
	7650 3550 7450 3550
Connection ~ 6950 4100
Wire Wire Line
	6950 4100 6950 4050
Text GLabel 8450 3750 2    50   Input ~ 0
CLK
Wire Wire Line
	8700 3550 8450 3550
Text GLabel 9300 3450 2    50   Input ~ 0
RW
Text GLabel 9300 3650 2    50   Input ~ 0
RW
Wire Wire Line
	7850 3650 7450 3650
$Comp
L power:GND #PWR0115
U 1 1 5FDA12ED
P 8850 1250
F 0 "#PWR0115" H 8850 1000 50  0001 C CNN
F 1 "GND" H 8855 1077 50  0000 C CNN
F 2 "" H 8850 1250 50  0001 C CNN
F 3 "" H 8850 1250 50  0001 C CNN
	1    8850 1250
	1    0    0    -1  
$EndComp
Wire Wire Line
	8850 950  8850 1150
Connection ~ 8850 1150
Wire Wire Line
	8850 1150 8850 1250
$EndSCHEMATC
