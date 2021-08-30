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
P 3350 3350
F 0 "#PWR0101" H 3350 3200 50  0001 C CNN
F 1 "+5V" H 3365 3523 50  0000 C CNN
F 2 "" H 3350 3350 50  0001 C CNN
F 3 "" H 3350 3350 50  0001 C CNN
	1    3350 3350
	1    0    0    -1  
$EndComp
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
$Comp
L power:GND #PWR0103
U 1 1 5FD65E00
P 3350 3450
F 0 "#PWR0103" H 3350 3200 50  0001 C CNN
F 1 "GND" H 3355 3277 50  0000 C CNN
F 2 "" H 3350 3450 50  0001 C CNN
F 3 "" H 3350 3450 50  0001 C CNN
	1    3350 3450
	1    0    0    -1  
$EndComp
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
~RESET~
Text GLabel 2800 4650 2    50   BiDi ~ 0
~NMI~
Text GLabel 2050 4050 0    50   Input ~ 0
RDY
Text GLabel 2050 4150 0    50   Input ~ 0
BE
Text GLabel 2300 4250 0    50   Input ~ 0
CLK
Text GLabel 2300 4350 0    50   Input ~ 0
R~W~
Text GLabel 2300 4550 0    50   Input ~ 0
SYNC
Text GLabel 2050 4450 0    50   Input ~ 0
~IRQ~
Text GLabel 3000 4550 2    50   BiDi ~ 0
~SLOT_IRQ~
Text GLabel 2800 4450 2    50   BiDi ~ 0
EX3
Text GLabel 2800 4350 2    50   BiDi ~ 0
EX2
Text GLabel 2800 4250 2    50   BiDi ~ 0
CLK_12M
Wire Wire Line
	2050 4450 2300 4450
Wire Wire Line
	2050 4050 2300 4050
Wire Wire Line
	2050 4150 2300 4150
Text GLabel 2900 3500 2    50   BiDi ~ 0
~SSEL~
Text GLabel 2800 3650 2    50   BiDi ~ 0
~INH~
Text GLabel 3050 3750 2    50   BiDi ~ 0
~SLOT_SEL~
Text GLabel 2800 3850 2    50   BiDi ~ 0
LED1
Text GLabel 2800 3950 2    50   BiDi ~ 0
LED2
Text GLabel 2800 4050 2    50   BiDi ~ 0
LED3
Text GLabel 2800 4150 2    50   BiDi ~ 0
LED4
Text GLabel 2800 3050 2    50   BiDi ~ 0
EX0
Text GLabel 2800 3150 2    50   BiDi ~ 0
EX1
Text GLabel 2800 3250 2    50   BiDi ~ 0
~SLOW~
$Comp
L 65xx:W65C22NxP U2
U 1 1 5FD922C5
P 6450 2700
F 0 "U2" H 6450 4331 50  0000 C CNN
F 1 "W65C22NxP" H 6450 4240 50  0000 C CIB
F 2 "Package_DIP:DIP-40_W15.24mm_Socket" H 6450 2850 50  0001 C CNN
F 3 "http://www.westerndesigncenter.com/wdc/documentation/w65c22.pdf" H 6450 2850 50  0001 C CNN
	1    6450 2700
	1    0    0    -1  
$EndComp
$Comp
L Connector:Mini-DIN-6 J3
U 1 1 5FD93536
P 8500 4650
F 0 "J3" H 8500 5017 50  0000 C CNN
F 1 "Mini-DIN-6" H 8550 4950 50  0000 C CNN
F 2 "mini-din:MINI-DIN-6-FULL-SHIELD" H 8500 4650 50  0001 C CNN
F 3 "http://service.powerdynamics.com/ec/Catalog17/Section%2011.pdf" H 8500 4650 50  0001 C CNN
	1    8500 4650
	1    0    0    -1  
$EndComp
Text GLabel 5850 3100 0    50   Input ~ 0
D0
Text GLabel 5850 3200 0    50   Input ~ 0
D1
Text GLabel 5850 3300 0    50   Input ~ 0
D2
Text GLabel 5850 3400 0    50   Input ~ 0
D3
Text GLabel 5850 3500 0    50   Input ~ 0
D4
Text GLabel 5850 3600 0    50   Input ~ 0
D5
Text GLabel 5850 3700 0    50   Input ~ 0
D6
Text GLabel 5850 3800 0    50   Input ~ 0
D7
Text GLabel 5850 2900 0    50   Input ~ 0
R~W~
Text GLabel 5850 1700 0    50   Input ~ 0
CLK_12M
Text GLabel 5750 1550 0    50   Input ~ 0
~RESET~
Text GLabel 5850 1900 0    50   Output ~ 0
~SLOT_IRQ~
Text GLabel 5850 2400 0    50   Input ~ 0
A0
Text GLabel 5850 2500 0    50   Input ~ 0
A1
Text GLabel 5850 2600 0    50   Input ~ 0
A2
Text GLabel 5850 2700 0    50   Input ~ 0
A3
$Comp
L power:GND #PWR0105
U 1 1 5FF45847
P 6450 4150
F 0 "#PWR0105" H 6450 3900 50  0001 C CNN
F 1 "GND" H 6455 3977 50  0000 C CNN
F 2 "" H 6450 4150 50  0001 C CNN
F 3 "" H 6450 4150 50  0001 C CNN
	1    6450 4150
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0106
U 1 1 5FF46155
P 6450 800
F 0 "#PWR0106" H 6450 650 50  0001 C CNN
F 1 "+5V" H 6465 973 50  0000 C CNN
F 2 "" H 6450 800 50  0001 C CNN
F 3 "" H 6450 800 50  0001 C CNN
	1    6450 800 
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C4
U 1 1 5FF4615C
P 6800 1000
F 0 "C4" H 6892 1046 50  0000 L CNN
F 1 "4.7u" H 6892 955 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D4.7mm_W2.5mm_P5.00mm" H 6800 1000 50  0001 C CNN
F 3 "~" H 6800 1000 50  0001 C CNN
	1    6800 1000
	1    0    0    -1  
$EndComp
Wire Wire Line
	6450 800  6450 900 
Wire Wire Line
	6800 900  6450 900 
Connection ~ 6450 900 
Wire Wire Line
	6450 900  6450 1250
$Comp
L power:GND #PWR0107
U 1 1 5FF48AF7
P 6800 1100
F 0 "#PWR0107" H 6800 850 50  0001 C CNN
F 1 "GND" H 6805 927 50  0000 C CNN
F 2 "" H 6800 1100 50  0001 C CNN
F 3 "" H 6800 1100 50  0001 C CNN
	1    6800 1100
	1    0    0    -1  
$EndComp
Wire Wire Line
	8800 4550 8800 4400
$Comp
L power:GND #PWR0111
U 1 1 5FF6B4A5
P 9300 4650
F 0 "#PWR0111" H 9300 4400 50  0001 C CNN
F 1 "GND" H 9305 4477 50  0000 C CNN
F 2 "" H 9300 4650 50  0001 C CNN
F 3 "" H 9300 4650 50  0001 C CNN
	1    9300 4650
	1    0    0    -1  
$EndComp
Wire Wire Line
	8800 4650 9300 4650
$Comp
L power:+5V #PWR0112
U 1 1 5FF6CB8E
P 7900 4650
F 0 "#PWR0112" H 7900 4500 50  0001 C CNN
F 1 "+5V" H 7915 4823 50  0000 C CNN
F 2 "" H 7900 4650 50  0001 C CNN
F 3 "" H 7900 4650 50  0001 C CNN
	1    7900 4650
	1    0    0    -1  
$EndComp
Wire Wire Line
	8200 4650 8000 4650
Wire Wire Line
	8800 4750 8900 4750
Wire Wire Line
	8900 4750 8900 3750
$Comp
L Device:R_Small R2
U 1 1 5FF6EAC9
P 8750 3300
F 0 "R2" H 8809 3346 50  0000 L CNN
F 1 "1k" H 8809 3255 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P5.08mm_Horizontal" H 8750 3300 50  0001 C CNN
F 3 "~" H 8750 3300 50  0001 C CNN
	1    8750 3300
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0113
U 1 1 5FF6F5A5
P 8750 3200
F 0 "#PWR0113" H 8750 3050 50  0001 C CNN
F 1 "+5V" H 8765 3373 50  0000 C CNN
F 2 "" H 8750 3200 50  0001 C CNN
F 3 "" H 8750 3200 50  0001 C CNN
	1    8750 3200
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R1
U 1 1 5FF71274
P 9000 4100
F 0 "R1" H 9059 4146 50  0000 L CNN
F 1 "1k" H 9059 4055 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P5.08mm_Horizontal" H 9000 4100 50  0001 C CNN
F 3 "~" H 9000 4100 50  0001 C CNN
	1    9000 4100
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0114
U 1 1 5FF7127A
P 9000 4000
F 0 "#PWR0114" H 9000 3850 50  0001 C CNN
F 1 "+5V" H 9015 4173 50  0000 C CNN
F 2 "" H 9000 4000 50  0001 C CNN
F 3 "" H 9000 4000 50  0001 C CNN
	1    9000 4000
	1    0    0    -1  
$EndComp
Wire Wire Line
	9000 4200 9000 4400
Text GLabel 7050 2800 2    50   BiDi ~ 0
LED1
Text GLabel 7050 2900 2    50   BiDi ~ 0
LED2
Text GLabel 7050 3000 2    50   BiDi ~ 0
LED3
Text GLabel 7600 2900 2    50   BiDi ~ 0
SCK
Text GLabel 5850 2200 0    50   BiDi ~ 0
~SLOT_SEL~
$Comp
L Device:R_Small R3
U 1 1 5FE069E7
P 5450 2050
F 0 "R3" H 5509 2096 50  0000 L CNN
F 1 "10k" H 5509 2005 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P5.08mm_Horizontal" H 5450 2050 50  0001 C CNN
F 3 "~" H 5450 2050 50  0001 C CNN
	1    5450 2050
	0    -1   -1   0   
$EndComp
Wire Wire Line
	5850 2100 5700 2100
Wire Wire Line
	5700 2100 5700 2050
Wire Wire Line
	5700 2050 5550 2050
$Comp
L power:+5V #PWR0108
U 1 1 5FE0944C
P 5200 2050
F 0 "#PWR0108" H 5200 1900 50  0001 C CNN
F 1 "+5V" H 5215 2223 50  0000 C CNN
F 2 "" H 5200 2050 50  0001 C CNN
F 3 "" H 5200 2050 50  0001 C CNN
	1    5200 2050
	1    0    0    -1  
$EndComp
Wire Wire Line
	5350 2050 5200 2050
Text Label 7050 1600 0    50   ~ 0
PA0
Text Label 7050 1700 0    50   ~ 0
PA1
Text Label 7050 1800 0    50   ~ 0
PA2
Text Label 7050 1900 0    50   ~ 0
PA3
Text Label 7050 2000 0    50   ~ 0
PA4
Text Label 7050 2100 0    50   ~ 0
PA5
Text Label 7050 2200 0    50   ~ 0
PA6
Text Label 7050 2300 0    50   ~ 0
PA7
Text Label 7050 2500 0    50   ~ 0
CA1
Text Label 7050 2600 0    50   ~ 0
CA2
Text GLabel 7050 3200 2    50   BiDi ~ 0
MISO
Text GLabel 7050 3300 2    50   BiDi ~ 0
MOSI
Text GLabel 7150 3450 2    50   BiDi ~ 0
~CONF~
$Comp
L Connector_Generic:Conn_02x10_Odd_Even J4
U 1 1 5FF16C05
P 6850 5550
F 0 "J4" H 6900 5967 50  0000 C CNN
F 1 "Conn_02x10_Odd_Even" H 6900 6269 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x10_P2.54mm_Horizontal" H 6850 5550 50  0001 C CNN
F 3 "~" H 6850 5550 50  0001 C CNN
	1    6850 5550
	1    0    0    -1  
$EndComp
Text GLabel 7150 3650 2    50   BiDi ~ 0
~SINT~
Text GLabel 7600 2750 2    50   BiDi ~ 0
LED4
Wire Wire Line
	7600 2750 7600 2900
Wire Wire Line
	7600 2900 7350 2900
Wire Wire Line
	7350 2900 7350 3100
Wire Wire Line
	7350 3100 7050 3100
Wire Wire Line
	7050 2200 7550 2200
Wire Wire Line
	7550 2200 7550 2400
Wire Wire Line
	7550 2400 8600 2400
Wire Wire Line
	8650 2450 7500 2450
Wire Wire Line
	7500 2450 7500 2300
Wire Wire Line
	7500 2300 7050 2300
$Comp
L power:+5V #PWR0118
U 1 1 5FF322A9
P 8550 1600
F 0 "#PWR0118" H 8550 1450 50  0001 C CNN
F 1 "+5V" H 8565 1773 50  0000 C CNN
F 2 "" H 8550 1600 50  0001 C CNN
F 3 "" H 8550 1600 50  0001 C CNN
	1    8550 1600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0119
U 1 1 5FF34117
P 8750 1950
F 0 "#PWR0119" H 8750 1700 50  0001 C CNN
F 1 "GND" H 8755 1777 50  0000 C CNN
F 2 "" H 8750 1950 50  0001 C CNN
F 3 "" H 8750 1950 50  0001 C CNN
	1    8750 1950
	1    0    0    -1  
$EndComp
Wire Wire Line
	7050 2500 8850 2500
Wire Wire Line
	8900 2600 7050 2600
Wire Wire Line
	7050 2100 7750 2100
Wire Wire Line
	7750 2100 7750 1600
Wire Wire Line
	7750 1600 8050 1600
Wire Wire Line
	8050 1700 7700 1700
Wire Wire Line
	7700 1700 7700 2000
Wire Wire Line
	7700 2000 7050 2000
Wire Wire Line
	7050 1900 7650 1900
Wire Wire Line
	7650 1900 7650 1800
Wire Wire Line
	7650 1800 8050 1800
Wire Wire Line
	8050 1900 7800 1900
Wire Wire Line
	7800 1900 7800 1950
Wire Wire Line
	7800 1950 7550 1950
Wire Wire Line
	7550 1950 7550 1800
Wire Wire Line
	7550 1800 7050 1800
Wire Wire Line
	7050 1700 7500 1700
Wire Wire Line
	7500 1700 7500 2050
Wire Wire Line
	7500 2050 7850 2050
Wire Wire Line
	7850 2050 7850 2000
Wire Wire Line
	7850 2000 8050 2000
Wire Wire Line
	8050 2100 7800 2100
Wire Wire Line
	7800 2100 7800 2150
Wire Wire Line
	7800 2150 7400 2150
Wire Wire Line
	7400 2150 7400 1600
Wire Wire Line
	7400 1600 7050 1600
$Comp
L power:+5V #PWR0120
U 1 1 5FEBB5D2
P 4700 4450
F 0 "#PWR0120" H 4700 4300 50  0001 C CNN
F 1 "+5V" H 4715 4623 50  0000 C CNN
F 2 "" H 4700 4450 50  0001 C CNN
F 3 "" H 4700 4450 50  0001 C CNN
	1    4700 4450
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C1
U 1 1 5FEBB5D8
P 5050 4650
F 0 "C1" H 5142 4696 50  0000 L CNN
F 1 "4.7u" H 5142 4605 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D4.7mm_W2.5mm_P5.00mm" H 5050 4650 50  0001 C CNN
F 3 "~" H 5050 4650 50  0001 C CNN
	1    5050 4650
	1    0    0    -1  
$EndComp
Wire Wire Line
	4700 4450 4700 4550
Wire Wire Line
	5050 4550 4700 4550
Connection ~ 4700 4550
Wire Wire Line
	4700 4550 4700 4900
$Comp
L power:GND #PWR0121
U 1 1 5FEBB5E2
P 5050 4750
F 0 "#PWR0121" H 5050 4500 50  0001 C CNN
F 1 "GND" H 5055 4577 50  0000 C CNN
F 2 "" H 5050 4750 50  0001 C CNN
F 3 "" H 5050 4750 50  0001 C CNN
	1    5050 4750
	1    0    0    -1  
$EndComp
Text GLabel 4200 5200 0    50   BiDi ~ 0
LED1
Text GLabel 4200 5300 0    50   BiDi ~ 0
LED2
Text GLabel 4200 5400 0    50   BiDi ~ 0
LED3
Wire Wire Line
	7150 3650 7100 3650
Wire Wire Line
	7100 3650 7100 3700
Wire Wire Line
	7100 3700 7050 3700
Text GLabel 8950 3750 2    50   BiDi ~ 0
PS2_DATA
Wire Wire Line
	8950 3750 8900 3750
Connection ~ 8900 3750
Wire Wire Line
	8900 3750 8900 3500
$Comp
L power:GND #PWR0122
U 1 1 5FED51BE
P 4700 6200
F 0 "#PWR0122" H 4700 5950 50  0001 C CNN
F 1 "GND" H 4705 6027 50  0000 C CNN
F 2 "" H 4700 6200 50  0001 C CNN
F 3 "" H 4700 6200 50  0001 C CNN
	1    4700 6200
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R4
U 1 1 5FED8A92
P 3700 5600
F 0 "R4" H 3759 5646 50  0000 L CNN
F 1 "10k" H 3759 5555 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P5.08mm_Horizontal" H 3700 5600 50  0001 C CNN
F 3 "~" H 3700 5600 50  0001 C CNN
	1    3700 5600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0123
U 1 1 5FED8A98
P 3700 5500
F 0 "#PWR0123" H 3700 5350 50  0001 C CNN
F 1 "+5V" H 3715 5673 50  0000 C CNN
F 2 "" H 3700 5500 50  0001 C CNN
F 3 "" H 3700 5500 50  0001 C CNN
	1    3700 5500
	1    0    0    -1  
$EndComp
Text GLabel 4150 5850 0    50   BiDi ~ 0
~SLOT_SEL~
Wire Wire Line
	4200 5800 4200 5850
Wire Wire Line
	4200 5850 4150 5850
$Comp
L power:GND #PWR0124
U 1 1 5FEFB08D
P 7600 5850
F 0 "#PWR0124" H 7600 5600 50  0001 C CNN
F 1 "GND" H 7605 5677 50  0000 C CNN
F 2 "" H 7600 5850 50  0001 C CNN
F 3 "" H 7600 5850 50  0001 C CNN
	1    7600 5850
	1    0    0    -1  
$EndComp
Wire Wire Line
	7150 5350 7150 5250
Connection ~ 7150 5250
Wire Wire Line
	7150 5250 7150 5150
Wire Wire Line
	7150 5150 7500 5150
Connection ~ 7150 5150
$Comp
L power:+5V #PWR0125
U 1 1 5FF04A3C
P 7350 5450
F 0 "#PWR0125" H 7350 5300 50  0001 C CNN
F 1 "+5V" H 7365 5623 50  0000 C CNN
F 2 "" H 7350 5450 50  0001 C CNN
F 3 "" H 7350 5450 50  0001 C CNN
	1    7350 5450
	1    0    0    -1  
$EndComp
Wire Wire Line
	7150 5550 7150 5450
Wire Wire Line
	7150 5450 7350 5450
Connection ~ 7150 5450
Wire Wire Line
	7150 5650 7500 5650
Wire Wire Line
	7500 5650 7500 6400
Wire Wire Line
	7500 6400 5400 6400
Wire Wire Line
	7150 5750 7450 5750
Wire Wire Line
	7450 5750 7450 6350
Wire Wire Line
	7450 6350 5450 6350
Wire Wire Line
	7600 5850 7150 5850
Wire Wire Line
	7150 5950 7400 5950
Wire Wire Line
	7400 5950 7400 6300
Wire Wire Line
	7400 6300 5500 6300
Wire Wire Line
	5500 6300 5500 5400
Wire Wire Line
	5500 5400 5200 5400
Wire Wire Line
	5450 5700 5200 5700
Wire Wire Line
	5450 5700 5450 6350
Wire Wire Line
	5400 5800 5200 5800
Wire Wire Line
	5400 5800 5400 6400
Wire Wire Line
	7150 6050 7350 6050
Wire Wire Line
	7350 6050 7350 6250
Wire Wire Line
	7350 6250 5550 6250
Wire Wire Line
	5550 6250 5550 5300
Wire Wire Line
	5550 5300 5200 5300
$Comp
L power:GND #PWR0126
U 1 1 5FF3A477
P 6650 6050
F 0 "#PWR0126" H 6650 5800 50  0001 C CNN
F 1 "GND" H 6655 5877 50  0000 C CNN
F 2 "" H 6650 6050 50  0001 C CNN
F 3 "" H 6650 6050 50  0001 C CNN
	1    6650 6050
	1    0    0    -1  
$EndComp
Wire Wire Line
	6650 5950 5800 5950
Wire Wire Line
	5800 5950 5800 5500
Wire Wire Line
	5800 5500 5200 5500
Wire Wire Line
	6650 5850 5850 5850
Wire Wire Line
	5850 5850 5850 5600
Wire Wire Line
	5850 5600 5200 5600
Wire Wire Line
	6650 5650 5600 5650
Wire Wire Line
	5600 5650 5600 5900
Wire Wire Line
	5600 5900 5200 5900
Text GLabel 6650 5550 0    50   BiDi ~ 0
~SINT~
Text GLabel 6400 5450 0    50   BiDi ~ 0
MISO
Text GLabel 6400 5350 0    50   BiDi ~ 0
MOSI
Text GLabel 6650 5150 0    50   BiDi ~ 0
~CONF~
Text GLabel 6400 5250 0    50   BiDi ~ 0
SCK
Wire Wire Line
	6650 5250 6400 5250
Wire Wire Line
	6650 5350 6400 5350
Wire Wire Line
	6650 5450 6400 5450
$Comp
L power:GND #PWR0127
U 1 1 5FFA2122
P 7500 5150
F 0 "#PWR0127" H 7500 4900 50  0001 C CNN
F 1 "GND" H 7505 4977 50  0000 C CNN
F 2 "" H 7500 5150 50  0001 C CNN
F 3 "" H 7500 5150 50  0001 C CNN
	1    7500 5150
	1    0    0    -1  
$EndComp
Text Label 5200 5900 0    50   ~ 0
SS1
Text Label 5200 5800 0    50   ~ 0
SS2
Text Label 5200 5700 0    50   ~ 0
SS3
Text Label 5200 5600 0    50   ~ 0
SS4
Text Label 5200 5500 0    50   ~ 0
SS5
Text Label 5200 5400 0    50   ~ 0
SS6
Text Label 5200 5300 0    50   ~ 0
SS7
Wire Wire Line
	2800 3350 3350 3350
Wire Wire Line
	2800 3450 2850 3450
Wire Wire Line
	3050 3750 2800 3750
Wire Wire Line
	2000 3450 2300 3450
Wire Wire Line
	3000 4550 2800 4550
Wire Wire Line
	2900 3500 2850 3500
Wire Wire Line
	2850 3500 2850 3550
Wire Wire Line
	2850 3550 2800 3550
Wire Wire Line
	7150 3450 7100 3450
Wire Wire Line
	7100 3450 7100 3400
Wire Wire Line
	7100 3400 7050 3400
Wire Wire Line
	7450 3550 7100 3550
Wire Wire Line
	7100 3550 7100 3500
Wire Wire Line
	7100 3500 7050 3500
Wire Wire Line
	5750 1550 5800 1550
Wire Wire Line
	5800 1550 5800 1600
Wire Wire Line
	5800 1600 5850 1600
Wire Wire Line
	3350 3450 3350 3400
Wire Wire Line
	3350 3400 2850 3400
Wire Wire Line
	2850 3400 2850 3450
$Comp
L Device:LED D1
U 1 1 5FF231E9
P 4150 1800
F 0 "D1" H 4143 2017 50  0000 C CNN
F 1 "LED" H 4143 1926 50  0000 C CNN
F 2 "LED_THT:LED_D3.0mm_Horizontal_O3.81mm_Z6.0mm" H 4150 1800 50  0001 C CNN
F 3 "~" H 4150 1800 50  0001 C CNN
	1    4150 1800
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R5
U 1 1 5FF2E9E8
P 4400 1800
F 0 "R5" H 4459 1846 50  0000 L CNN
F 1 "470R" H 4459 1755 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P5.08mm_Horizontal" H 4400 1800 50  0001 C CNN
F 3 "~" H 4400 1800 50  0001 C CNN
	1    4400 1800
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0109
U 1 1 5FF3557C
P 4500 1800
F 0 "#PWR0109" H 4500 1550 50  0001 C CNN
F 1 "GND" H 4505 1627 50  0000 C CNN
F 2 "" H 4500 1800 50  0001 C CNN
F 3 "" H 4500 1800 50  0001 C CNN
	1    4500 1800
	1    0    0    -1  
$EndComp
Text Label 3800 1800 0    50   ~ 0
PA0
Wire Wire Line
	4000 1800 3800 1800
$Comp
L Device:LED D2
U 1 1 5FF4DDFD
P 4150 2050
F 0 "D2" H 4143 2267 50  0000 C CNN
F 1 "LED" H 4143 2176 50  0000 C CNN
F 2 "LED_THT:LED_D3.0mm_Horizontal_O3.81mm_Z6.0mm" H 4150 2050 50  0001 C CNN
F 3 "~" H 4150 2050 50  0001 C CNN
	1    4150 2050
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R6
U 1 1 5FF4DE03
P 4400 2050
F 0 "R6" H 4459 2096 50  0000 L CNN
F 1 "470R" H 4459 2005 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P5.08mm_Horizontal" H 4400 2050 50  0001 C CNN
F 3 "~" H 4400 2050 50  0001 C CNN
	1    4400 2050
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0110
U 1 1 5FF4DE09
P 4500 2050
F 0 "#PWR0110" H 4500 1800 50  0001 C CNN
F 1 "GND" H 4505 1877 50  0000 C CNN
F 2 "" H 4500 2050 50  0001 C CNN
F 3 "" H 4500 2050 50  0001 C CNN
	1    4500 2050
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 2050 3800 2050
$Comp
L Device:LED D3
U 1 1 5FF55550
P 4150 2300
F 0 "D3" H 4143 2517 50  0000 C CNN
F 1 "LED" H 4143 2426 50  0000 C CNN
F 2 "LED_THT:LED_D3.0mm_Horizontal_O3.81mm_Z6.0mm" H 4150 2300 50  0001 C CNN
F 3 "~" H 4150 2300 50  0001 C CNN
	1    4150 2300
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R7
U 1 1 5FF55556
P 4400 2300
F 0 "R7" H 4459 2346 50  0000 L CNN
F 1 "470R" H 4459 2255 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P5.08mm_Horizontal" H 4400 2300 50  0001 C CNN
F 3 "~" H 4400 2300 50  0001 C CNN
	1    4400 2300
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0115
U 1 1 5FF5555C
P 4500 2300
F 0 "#PWR0115" H 4500 2050 50  0001 C CNN
F 1 "GND" H 4505 2127 50  0000 C CNN
F 2 "" H 4500 2300 50  0001 C CNN
F 3 "" H 4500 2300 50  0001 C CNN
	1    4500 2300
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 2300 3800 2300
$Comp
L Device:LED D4
U 1 1 5FF5CDD6
P 4150 2550
F 0 "D4" H 4143 2767 50  0000 C CNN
F 1 "LED" H 4143 2676 50  0000 C CNN
F 2 "LED_THT:LED_D3.0mm_Horizontal_O3.81mm_Z6.0mm" H 4150 2550 50  0001 C CNN
F 3 "~" H 4150 2550 50  0001 C CNN
	1    4150 2550
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R8
U 1 1 5FF5CDDC
P 4400 2550
F 0 "R8" H 4459 2596 50  0000 L CNN
F 1 "470R" H 4459 2505 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P5.08mm_Horizontal" H 4400 2550 50  0001 C CNN
F 3 "~" H 4400 2550 50  0001 C CNN
	1    4400 2550
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0116
U 1 1 5FF5CDE2
P 4500 2550
F 0 "#PWR0116" H 4500 2300 50  0001 C CNN
F 1 "GND" H 4505 2377 50  0000 C CNN
F 2 "" H 4500 2550 50  0001 C CNN
F 3 "" H 4500 2550 50  0001 C CNN
	1    4500 2550
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 2550 3800 2550
$Comp
L Device:LED D5
U 1 1 5FF64552
P 4150 2800
F 0 "D5" H 4143 3017 50  0000 C CNN
F 1 "LED" H 4143 2926 50  0000 C CNN
F 2 "LED_THT:LED_D3.0mm_Horizontal_O3.81mm_Z6.0mm" H 4150 2800 50  0001 C CNN
F 3 "~" H 4150 2800 50  0001 C CNN
	1    4150 2800
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R9
U 1 1 5FF64558
P 4400 2800
F 0 "R9" H 4459 2846 50  0000 L CNN
F 1 "470R" H 4459 2755 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P5.08mm_Horizontal" H 4400 2800 50  0001 C CNN
F 3 "~" H 4400 2800 50  0001 C CNN
	1    4400 2800
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0128
U 1 1 5FF6455E
P 4500 2800
F 0 "#PWR0128" H 4500 2550 50  0001 C CNN
F 1 "GND" H 4505 2627 50  0000 C CNN
F 2 "" H 4500 2800 50  0001 C CNN
F 3 "" H 4500 2800 50  0001 C CNN
	1    4500 2800
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 2800 3800 2800
$Comp
L Device:LED D6
U 1 1 5FF6C107
P 4150 3050
F 0 "D6" H 4143 3267 50  0000 C CNN
F 1 "LED" H 4143 3176 50  0000 C CNN
F 2 "LED_THT:LED_D3.0mm_Horizontal_O3.81mm_Z6.0mm" H 4150 3050 50  0001 C CNN
F 3 "~" H 4150 3050 50  0001 C CNN
	1    4150 3050
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R10
U 1 1 5FF6C10D
P 4400 3050
F 0 "R10" H 4459 3096 50  0000 L CNN
F 1 "470R" H 4459 3005 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P5.08mm_Horizontal" H 4400 3050 50  0001 C CNN
F 3 "~" H 4400 3050 50  0001 C CNN
	1    4400 3050
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0129
U 1 1 5FF6C113
P 4500 3050
F 0 "#PWR0129" H 4500 2800 50  0001 C CNN
F 1 "GND" H 4505 2877 50  0000 C CNN
F 2 "" H 4500 3050 50  0001 C CNN
F 3 "" H 4500 3050 50  0001 C CNN
	1    4500 3050
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 3050 3800 3050
$Comp
L Device:LED D7
U 1 1 5FF73AB8
P 4150 3300
F 0 "D7" H 4143 3517 50  0000 C CNN
F 1 "LED" H 4143 3426 50  0000 C CNN
F 2 "LED_THT:LED_D3.0mm_Horizontal_O3.81mm_Z6.0mm" H 4150 3300 50  0001 C CNN
F 3 "~" H 4150 3300 50  0001 C CNN
	1    4150 3300
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R11
U 1 1 5FF73ABE
P 4400 3300
F 0 "R11" H 4459 3346 50  0000 L CNN
F 1 "470R" H 4459 3255 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P5.08mm_Horizontal" H 4400 3300 50  0001 C CNN
F 3 "~" H 4400 3300 50  0001 C CNN
	1    4400 3300
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0130
U 1 1 5FF73AC4
P 4500 3300
F 0 "#PWR0130" H 4500 3050 50  0001 C CNN
F 1 "GND" H 4505 3127 50  0000 C CNN
F 2 "" H 4500 3300 50  0001 C CNN
F 3 "" H 4500 3300 50  0001 C CNN
	1    4500 3300
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 3300 3800 3300
$Comp
L Device:LED D8
U 1 1 5FF7B8A8
P 4150 3550
F 0 "D8" H 4143 3767 50  0000 C CNN
F 1 "LED" H 4143 3676 50  0000 C CNN
F 2 "LED_THT:LED_D3.0mm_Horizontal_O3.81mm_Z6.0mm" H 4150 3550 50  0001 C CNN
F 3 "~" H 4150 3550 50  0001 C CNN
	1    4150 3550
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R12
U 1 1 5FF7B8AE
P 4400 3550
F 0 "R12" H 4459 3596 50  0000 L CNN
F 1 "470R" H 4459 3505 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P5.08mm_Horizontal" H 4400 3550 50  0001 C CNN
F 3 "~" H 4400 3550 50  0001 C CNN
	1    4400 3550
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0131
U 1 1 5FF7B8B4
P 4500 3550
F 0 "#PWR0131" H 4500 3300 50  0001 C CNN
F 1 "GND" H 4505 3377 50  0000 C CNN
F 2 "" H 4500 3550 50  0001 C CNN
F 3 "" H 4500 3550 50  0001 C CNN
	1    4500 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 3550 3800 3550
Text Label 3800 2050 0    50   ~ 0
PA1
Text Label 3800 2300 0    50   ~ 0
PA2
Text Label 3800 2550 0    50   ~ 0
PA3
Text Label 3800 2800 0    50   ~ 0
PA4
Text Label 3800 3050 0    50   ~ 0
PA5
Text Label 3800 3300 0    50   ~ 0
PA6
Text Label 3800 3550 0    50   ~ 0
PA7
$Comp
L 74xx:74LS14 U3
U 1 1 601A49CD
P 8250 3900
F 0 "U3" H 8250 4217 50  0000 C CNN
F 1 "74LS14" H 8250 4126 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 8250 3900 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 8250 3900 50  0001 C CNN
	1    8250 3900
	-1   0    0    1   
$EndComp
$Comp
L 74xx:74LS14 U3
U 2 1 601A559B
P 7450 3900
F 0 "U3" H 7450 4217 50  0000 C CNN
F 1 "74LS14" H 7450 4126 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 7450 3900 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 7450 3900 50  0001 C CNN
	2    7450 3900
	-1   0    0    1   
$EndComp
$Comp
L 74xx:74LS14 U3
U 3 1 601A5DD3
P 1900 6350
F 0 "U3" H 1900 6667 50  0000 C CNN
F 1 "74LS14" H 1900 6576 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 1900 6350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 1900 6350 50  0001 C CNN
	3    1900 6350
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS14 U3
U 4 1 601A768F
P 1900 6800
F 0 "U3" H 1900 7117 50  0000 C CNN
F 1 "74LS14" H 1900 7026 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 1900 6800 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 1900 6800 50  0001 C CNN
	4    1900 6800
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS14 U3
U 5 1 601A824E
P 7750 3400
F 0 "U3" H 7750 3717 50  0000 C CNN
F 1 "74LS14" H 7750 3626 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 7750 3400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 7750 3400 50  0001 C CNN
	5    7750 3400
	-1   0    0    1   
$EndComp
$Comp
L 74xx:74LS14 U3
U 6 1 601A8ACA
P 8400 3500
F 0 "U3" H 8400 3817 50  0000 C CNN
F 1 "74LS14" H 8400 3726 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 8400 3500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 8400 3500 50  0001 C CNN
	6    8400 3500
	-1   0    0    1   
$EndComp
$Comp
L 74xx:74LS14 U3
U 7 1 601A9A10
P 9450 5550
F 0 "U3" H 9680 5596 50  0000 L CNN
F 1 "74LS14" H 9680 5505 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 9450 5550 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 9450 5550 50  0001 C CNN
	7    9450 5550
	1    0    0    -1  
$EndComp
Wire Wire Line
	8900 3500 8750 3500
Wire Wire Line
	8750 3400 8750 3500
Connection ~ 8750 3500
Wire Wire Line
	8750 3500 8700 3500
Wire Wire Line
	9000 4400 8800 4400
Connection ~ 8800 4400
Wire Wire Line
	8800 4400 8800 3900
$Comp
L power:+5V #PWR0132
U 1 1 6023E73F
P 9450 4600
F 0 "#PWR0132" H 9450 4450 50  0001 C CNN
F 1 "+5V" H 9465 4773 50  0000 C CNN
F 2 "" H 9450 4600 50  0001 C CNN
F 3 "" H 9450 4600 50  0001 C CNN
	1    9450 4600
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C2
U 1 1 6023E745
P 9800 4800
F 0 "C2" H 9892 4846 50  0000 L CNN
F 1 "4.7u" H 9892 4755 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D4.7mm_W2.5mm_P5.00mm" H 9800 4800 50  0001 C CNN
F 3 "~" H 9800 4800 50  0001 C CNN
	1    9800 4800
	1    0    0    -1  
$EndComp
Wire Wire Line
	9450 4600 9450 4700
Wire Wire Line
	9800 4700 9450 4700
Connection ~ 9450 4700
Wire Wire Line
	9450 4700 9450 5050
$Comp
L power:GND #PWR0133
U 1 1 6023E74F
P 8000 4950
F 0 "#PWR0133" H 8000 4700 50  0001 C CNN
F 1 "GND" H 8005 4777 50  0000 C CNN
F 2 "" H 8000 4950 50  0001 C CNN
F 3 "" H 8000 4950 50  0001 C CNN
	1    8000 4950
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0134
U 1 1 60246579
P 9450 6050
F 0 "#PWR0134" H 9450 5800 50  0001 C CNN
F 1 "GND" H 9455 5877 50  0000 C CNN
F 2 "" H 9450 6050 50  0001 C CNN
F 3 "" H 9450 6050 50  0001 C CNN
	1    9450 6050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0135
U 1 1 6024EC1D
P 1600 6950
F 0 "#PWR0135" H 1600 6700 50  0001 C CNN
F 1 "GND" H 1605 6777 50  0000 C CNN
F 2 "" H 1600 6950 50  0001 C CNN
F 3 "" H 1600 6950 50  0001 C CNN
	1    1600 6950
	1    0    0    -1  
$EndComp
Wire Wire Line
	1600 6350 1600 6800
Connection ~ 1600 6800
Wire Wire Line
	1600 6800 1600 6950
$Comp
L 74xx:74LS138 U1
U 1 1 6029065F
P 4700 5500
F 0 "U1" H 4700 6281 50  0000 C CNN
F 1 "74LS138" H 4700 6190 50  0000 C CNN
F 2 "Package_DIP:DIP-16_W7.62mm_Socket" H 4700 5500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS138" H 4700 5500 50  0001 C CNN
	1    4700 5500
	1    0    0    -1  
$EndComp
Wire Wire Line
	3700 5700 4200 5700
Wire Wire Line
	4200 5900 4200 5850
Connection ~ 4200 5850
$Comp
L Device:C_Small C3
U 1 1 604850AB
P 8000 4850
F 0 "C3" H 8092 4896 50  0000 L CNN
F 1 "4.7u" H 8092 4805 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D4.7mm_W2.5mm_P5.00mm" H 8000 4850 50  0001 C CNN
F 3 "~" H 8000 4850 50  0001 C CNN
	1    8000 4850
	1    0    0    -1  
$EndComp
Wire Wire Line
	8000 4750 8000 4650
Connection ~ 8000 4650
Wire Wire Line
	8000 4650 7900 4650
Wire Wire Line
	8100 3400 8100 3500
Wire Wire Line
	7450 3400 7450 3550
Wire Wire Line
	8550 3900 8800 3900
Connection ~ 8800 3900
Wire Wire Line
	8800 3900 8800 3800
Wire Wire Line
	7950 3900 7750 3900
Wire Wire Line
	7150 3900 7100 3900
Wire Wire Line
	7100 3900 7100 3800
Wire Wire Line
	7100 3800 7050 3800
Wire Wire Line
	8100 3400 8050 3400
$Comp
L power:GND #PWR0136
U 1 1 613198B5
P 9800 4900
F 0 "#PWR0136" H 9800 4650 50  0001 C CNN
F 1 "GND" H 9805 4727 50  0000 C CNN
F 2 "" H 9800 4900 50  0001 C CNN
F 3 "" H 9800 4900 50  0001 C CNN
	1    9800 4900
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_02x06_Odd_Even J2
U 1 1 613B2285
P 8250 1800
F 0 "J2" H 8300 2217 50  0000 C CNN
F 1 "Conn_02x06_Odd_Even" H 8300 2126 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x06_P2.54mm_Horizontal" H 8250 1800 50  0001 C CNN
F 3 "~" H 8250 1800 50  0001 C CNN
	1    8250 1800
	1    0    0    -1  
$EndComp
Wire Wire Line
	8600 2100 8550 2100
Wire Wire Line
	8600 2100 8600 2400
Wire Wire Line
	8650 2000 8550 2000
Wire Wire Line
	8650 2000 8650 2450
Wire Wire Line
	8850 1800 8550 1800
Wire Wire Line
	8850 1800 8850 2500
Wire Wire Line
	8900 1700 8550 1700
Wire Wire Line
	8900 1700 8900 2600
Wire Wire Line
	8750 1950 8750 1900
Wire Wire Line
	8750 1900 8550 1900
$EndSCHEMATC
