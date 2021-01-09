EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A3 16535 11693
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
L Connector_Generic:Conn_02x25_Odd_Even SLOT0
U 1 1 5FD62DCD
P 2500 3550
F 0 "SLOT0" H 2550 4967 50  0000 C CNN
F 1 "Conn_01x40" H 2550 4876 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x25_P2.54mm_Vertical" H 2500 3550 50  0001 C CNN
F 3 "~" H 2500 3550 50  0001 C CNN
	1    2500 3550
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0101
U 1 1 5FD64472
P 3000 3450
F 0 "#PWR0101" H 3000 3300 50  0001 C CNN
F 1 "+5V" H 3015 3623 50  0000 C CNN
F 2 "" H 3000 3450 50  0001 C CNN
F 3 "" H 3000 3450 50  0001 C CNN
	1    3000 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	3000 3450 2800 3450
$Comp
L power:+5V #PWR0102
U 1 1 5FD65A34
P 2000 3550
F 0 "#PWR0102" H 2000 3400 50  0001 C CNN
F 1 "+5V" H 2015 3723 50  0000 C CNN
F 2 "" H 2000 3550 50  0001 C CNN
F 3 "" H 2000 3550 50  0001 C CNN
	1    2000 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	2300 3550 2050 3550
$Comp
L power:GND #PWR0103
U 1 1 5FD65E00
P 3000 3550
F 0 "#PWR0103" H 3000 3300 50  0001 C CNN
F 1 "GND" H 3005 3377 50  0000 C CNN
F 2 "" H 3000 3550 50  0001 C CNN
F 3 "" H 3000 3550 50  0001 C CNN
	1    3000 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	3000 3550 2800 3550
$Comp
L power:GND #PWR0104
U 1 1 5FD66D1A
P 1850 3400
F 0 "#PWR0104" H 1850 3150 50  0001 C CNN
F 1 "GND" H 1855 3227 50  0000 C CNN
F 2 "" H 1850 3400 50  0001 C CNN
F 3 "" H 1850 3400 50  0001 C CNN
	1    1850 3400
	1    0    0    -1  
$EndComp
Wire Wire Line
	2100 3450 2100 3400
Wire Wire Line
	2100 3400 1850 3400
Wire Wire Line
	2100 3450 2300 3450
Text GLabel 2300 2350 0    50   Input ~ 0
A0
Text GLabel 2300 2450 0    50   Input ~ 0
A1
Text GLabel 2300 2550 0    50   Input ~ 0
A2
Text GLabel 2300 2650 0    50   Input ~ 0
A3
Text GLabel 2300 2750 0    50   Input ~ 0
A4
Text GLabel 2300 2850 0    50   Input ~ 0
A5
Text GLabel 2300 2950 0    50   Input ~ 0
A6
Text GLabel 2300 3050 0    50   Input ~ 0
A7
Text GLabel 2300 3150 0    50   Input ~ 0
A8
Text GLabel 2300 3250 0    50   Input ~ 0
A9
Text GLabel 2300 3350 0    50   Input ~ 0
A10
Text GLabel 2300 3650 0    50   Input ~ 0
A11
Text GLabel 2300 3750 0    50   Input ~ 0
A12
Text GLabel 2300 3850 0    50   Input ~ 0
A13
Text GLabel 2300 3950 0    50   Input ~ 0
A14
Text GLabel 2300 4050 0    50   Input ~ 0
A15
Text GLabel 2800 2350 2    50   BiDi ~ 0
D0
Text GLabel 2800 2450 2    50   BiDi ~ 0
D1
Text GLabel 2800 2550 2    50   BiDi ~ 0
D2
Text GLabel 2800 2650 2    50   BiDi ~ 0
D3
Text GLabel 2800 2750 2    50   BiDi ~ 0
D4
Text GLabel 2800 2850 2    50   BiDi ~ 0
D5
Text GLabel 2800 2950 2    50   BiDi ~ 0
D6
Text GLabel 2800 3050 2    50   BiDi ~ 0
D7
Text GLabel 2300 4750 0    50   Input ~ 0
~RESET~
Text GLabel 2800 4750 2    50   BiDi ~ 0
~NMI~
Text GLabel 1750 4150 0    50   Input ~ 0
RDY
Text GLabel 1750 4250 0    50   Input ~ 0
BE
Text GLabel 2300 4350 0    50   Input ~ 0
CLK
Text GLabel 2300 4450 0    50   Input ~ 0
R~W~
Text GLabel 2300 4650 0    50   Input ~ 0
SYNC
Text GLabel 1750 4550 0    50   Input ~ 0
~IRQ~
$Comp
L Device:C_Small C1
U 1 1 5FD8C99F
P 1650 3500
F 0 "C1" H 1742 3546 50  0000 L CNN
F 1 "C_Small" H 1742 3455 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 1650 3500 50  0001 C CNN
F 3 "~" H 1650 3500 50  0001 C CNN
	1    1650 3500
	1    0    0    -1  
$EndComp
Wire Wire Line
	1650 3400 1850 3400
Connection ~ 1850 3400
Wire Wire Line
	1650 3600 2050 3600
Wire Wire Line
	2050 3600 2050 3550
Connection ~ 2050 3550
Wire Wire Line
	2050 3550 2000 3550
Text GLabel 1150 7150 0    50   BiDi ~ 0
~NMI~
Text GLabel 1150 6750 0    50   BiDi ~ 0
~IRQ4~
Text GLabel 1150 6850 0    50   BiDi ~ 0
~IRQ3~
Text GLabel 1150 6950 0    50   BiDi ~ 0
~IRQ2~
Text GLabel 1150 7050 0    50   BiDi ~ 0
~IRQ1~
Text GLabel 1150 6550 0    50   Input ~ 0
~IRQ~
Text GLabel 1150 5850 0    50   Input ~ 0
RDY
Text GLabel 1150 6050 0    50   Input ~ 0
BE
$Comp
L Device:R_Small R8
U 1 1 5FF07124
P 1300 6050
F 0 "R8" H 1359 6096 50  0000 L CNN
F 1 "4.7k" H 1359 6005 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1300 6050 50  0001 C CNN
F 3 "~" H 1300 6050 50  0001 C CNN
	1    1300 6050
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR0105
U 1 1 5FF0712A
P 1400 6050
F 0 "#PWR0105" H 1400 5900 50  0001 C CNN
F 1 "+5V" H 1415 6223 50  0000 C CNN
F 2 "" H 1400 6050 50  0001 C CNN
F 3 "" H 1400 6050 50  0001 C CNN
	1    1400 6050
	0    1    1    0   
$EndComp
Wire Wire Line
	1150 6050 1200 6050
Wire Wire Line
	1750 4550 2300 4550
Wire Wire Line
	1750 4150 2300 4150
Wire Wire Line
	1750 4250 2300 4250
$Comp
L Device:R_Small R1
U 1 1 5FF2181F
P 1250 5850
F 0 "R1" H 1309 5896 50  0000 L CNN
F 1 "4.7k" H 1309 5805 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1250 5850 50  0001 C CNN
F 3 "~" H 1250 5850 50  0001 C CNN
	1    1250 5850
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR0106
U 1 1 5FF21825
P 1350 5850
F 0 "#PWR0106" H 1350 5700 50  0001 C CNN
F 1 "+5V" H 1365 6023 50  0000 C CNN
F 2 "" H 1350 5850 50  0001 C CNN
F 3 "" H 1350 5850 50  0001 C CNN
	1    1350 5850
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small R2
U 1 1 5FF22418
P 1250 6550
F 0 "R2" V 1054 6550 50  0000 C CNN
F 1 "1k" V 1145 6550 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1250 6550 50  0001 C CNN
F 3 "~" H 1250 6550 50  0001 C CNN
	1    1250 6550
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR0107
U 1 1 5FF2241E
P 1350 6550
F 0 "#PWR0107" H 1350 6400 50  0001 C CNN
F 1 "+5V" H 1365 6723 50  0000 C CNN
F 2 "" H 1350 6550 50  0001 C CNN
F 3 "" H 1350 6550 50  0001 C CNN
	1    1350 6550
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small R3
U 1 1 5FF23FC7
P 1250 6750
F 0 "R3" V 1054 6750 50  0000 C CNN
F 1 "1k" V 1145 6750 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1250 6750 50  0001 C CNN
F 3 "~" H 1250 6750 50  0001 C CNN
	1    1250 6750
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR0108
U 1 1 5FF23FCD
P 1350 6750
F 0 "#PWR0108" H 1350 6600 50  0001 C CNN
F 1 "+5V" H 1365 6923 50  0000 C CNN
F 2 "" H 1350 6750 50  0001 C CNN
F 3 "" H 1350 6750 50  0001 C CNN
	1    1350 6750
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small R4
U 1 1 5FF244F6
P 1250 6850
F 0 "R4" V 1054 6850 50  0000 C CNN
F 1 "1k" V 1145 6850 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1250 6850 50  0001 C CNN
F 3 "~" H 1250 6850 50  0001 C CNN
	1    1250 6850
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR0109
U 1 1 5FF244FC
P 1350 6850
F 0 "#PWR0109" H 1350 6700 50  0001 C CNN
F 1 "+5V" H 1365 7023 50  0000 C CNN
F 2 "" H 1350 6850 50  0001 C CNN
F 3 "" H 1350 6850 50  0001 C CNN
	1    1350 6850
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small R5
U 1 1 5FF249D5
P 1250 6950
F 0 "R5" V 1054 6950 50  0000 C CNN
F 1 "1k" V 1145 6950 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1250 6950 50  0001 C CNN
F 3 "~" H 1250 6950 50  0001 C CNN
	1    1250 6950
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR0110
U 1 1 5FF249DB
P 1350 6950
F 0 "#PWR0110" H 1350 6800 50  0001 C CNN
F 1 "+5V" H 1365 7123 50  0000 C CNN
F 2 "" H 1350 6950 50  0001 C CNN
F 3 "" H 1350 6950 50  0001 C CNN
	1    1350 6950
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small R6
U 1 1 5FF24EB4
P 1250 7050
F 0 "R6" V 1054 7050 50  0000 C CNN
F 1 "1k" V 1145 7050 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1250 7050 50  0001 C CNN
F 3 "~" H 1250 7050 50  0001 C CNN
	1    1250 7050
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR0111
U 1 1 5FF24EBA
P 1350 7050
F 0 "#PWR0111" H 1350 6900 50  0001 C CNN
F 1 "+5V" H 1365 7223 50  0000 C CNN
F 2 "" H 1350 7050 50  0001 C CNN
F 3 "" H 1350 7050 50  0001 C CNN
	1    1350 7050
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small R7
U 1 1 5FF256DB
P 1250 7150
F 0 "R7" V 1054 7150 50  0000 C CNN
F 1 "1k" V 1145 7150 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1250 7150 50  0001 C CNN
F 3 "~" H 1250 7150 50  0001 C CNN
	1    1250 7150
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR0112
U 1 1 5FF256E1
P 1350 7150
F 0 "#PWR0112" H 1350 7000 50  0001 C CNN
F 1 "+5V" H 1365 7323 50  0000 C CNN
F 2 "" H 1350 7150 50  0001 C CNN
F 3 "" H 1350 7150 50  0001 C CNN
	1    1350 7150
	0    1    1    0   
$EndComp
$Comp
L Connector_Generic:Conn_02x25_Odd_Even SLOT2
U 1 1 5FF330AA
P 4650 3550
F 0 "SLOT2" H 4700 4967 50  0000 C CNN
F 1 "Conn_01x40" H 4700 4876 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x25_P2.54mm_Vertical" H 4650 3550 50  0001 C CNN
F 3 "~" H 4650 3550 50  0001 C CNN
	1    4650 3550
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0113
U 1 1 5FF330B0
P 5150 3450
F 0 "#PWR0113" H 5150 3300 50  0001 C CNN
F 1 "+5V" H 5165 3623 50  0000 C CNN
F 2 "" H 5150 3450 50  0001 C CNN
F 3 "" H 5150 3450 50  0001 C CNN
	1    5150 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	5150 3450 4950 3450
$Comp
L power:+5V #PWR0114
U 1 1 5FF330B7
P 4150 3550
F 0 "#PWR0114" H 4150 3400 50  0001 C CNN
F 1 "+5V" H 4165 3723 50  0000 C CNN
F 2 "" H 4150 3550 50  0001 C CNN
F 3 "" H 4150 3550 50  0001 C CNN
	1    4150 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	4450 3550 4200 3550
$Comp
L power:GND #PWR0115
U 1 1 5FF330BE
P 5150 3550
F 0 "#PWR0115" H 5150 3300 50  0001 C CNN
F 1 "GND" H 5155 3377 50  0000 C CNN
F 2 "" H 5150 3550 50  0001 C CNN
F 3 "" H 5150 3550 50  0001 C CNN
	1    5150 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	5150 3550 4950 3550
$Comp
L power:GND #PWR0116
U 1 1 5FF330C5
P 4000 3400
F 0 "#PWR0116" H 4000 3150 50  0001 C CNN
F 1 "GND" H 4005 3227 50  0000 C CNN
F 2 "" H 4000 3400 50  0001 C CNN
F 3 "" H 4000 3400 50  0001 C CNN
	1    4000 3400
	1    0    0    -1  
$EndComp
Wire Wire Line
	4250 3450 4250 3400
Wire Wire Line
	4250 3400 4000 3400
Wire Wire Line
	4250 3450 4450 3450
Text GLabel 4450 2350 0    50   Input ~ 0
A0
Text GLabel 4450 2450 0    50   Input ~ 0
A1
Text GLabel 4450 2550 0    50   Input ~ 0
A2
Text GLabel 4450 2650 0    50   Input ~ 0
A3
Text GLabel 4450 2750 0    50   Input ~ 0
A4
Text GLabel 4450 2850 0    50   Input ~ 0
A5
Text GLabel 4450 2950 0    50   Input ~ 0
A6
Text GLabel 4450 3050 0    50   Input ~ 0
A7
Text GLabel 4450 3150 0    50   Input ~ 0
A8
Text GLabel 4450 3250 0    50   Input ~ 0
A9
Text GLabel 4450 3350 0    50   Input ~ 0
A10
Text GLabel 4450 3650 0    50   Input ~ 0
A11
Text GLabel 4450 3750 0    50   Input ~ 0
A12
Text GLabel 4450 3850 0    50   Input ~ 0
A13
Text GLabel 4450 3950 0    50   Input ~ 0
A14
Text GLabel 4450 4050 0    50   Input ~ 0
A15
Text GLabel 4950 2350 2    50   BiDi ~ 0
D0
Text GLabel 4950 2450 2    50   BiDi ~ 0
D1
Text GLabel 4950 2550 2    50   BiDi ~ 0
D2
Text GLabel 4950 2650 2    50   BiDi ~ 0
D3
Text GLabel 4950 2750 2    50   BiDi ~ 0
D4
Text GLabel 4950 2850 2    50   BiDi ~ 0
D5
Text GLabel 4950 2950 2    50   BiDi ~ 0
D6
Text GLabel 4950 3050 2    50   BiDi ~ 0
D7
Text GLabel 4450 4750 0    50   Input ~ 0
~RESET~
Text GLabel 4950 4750 2    50   BiDi ~ 0
~NMI~
Text GLabel 3900 4150 0    50   Input ~ 0
RDY
Text GLabel 3900 4250 0    50   Input ~ 0
BE
Text GLabel 4450 4350 0    50   Input ~ 0
CLK
Text GLabel 4450 4450 0    50   Input ~ 0
R~W~
Text GLabel 4450 4650 0    50   Input ~ 0
SYNC
Text GLabel 3900 4550 0    50   Input ~ 0
~IRQ~
Text GLabel 4950 4650 2    50   BiDi ~ 0
~IRQ2~
$Comp
L Device:C_Small C7
U 1 1 5FF330F2
P 5300 3500
F 0 "C7" H 5392 3546 50  0000 L CNN
F 1 "C_Small" H 5392 3455 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 5300 3500 50  0001 C CNN
F 3 "~" H 5300 3500 50  0001 C CNN
	1    5300 3500
	1    0    0    -1  
$EndComp
Wire Wire Line
	5300 3400 5250 3400
Wire Wire Line
	5250 3400 5250 3450
Wire Wire Line
	5250 3450 5150 3450
Connection ~ 5150 3450
Wire Wire Line
	5300 3600 5250 3600
Wire Wire Line
	5250 3600 5250 3550
Wire Wire Line
	5250 3550 5150 3550
Connection ~ 5150 3550
Wire Wire Line
	4200 3600 4200 3550
Connection ~ 4200 3550
Wire Wire Line
	4200 3550 4150 3550
Wire Wire Line
	3900 4550 4450 4550
Wire Wire Line
	3900 4150 4450 4150
Wire Wire Line
	3900 4250 4450 4250
$Comp
L Connector_Generic:Conn_02x25_Odd_Even SLOT4
U 1 1 5FF388F3
P 6750 3500
F 0 "SLOT4" H 6800 4917 50  0000 C CNN
F 1 "Conn_01x40" H 6800 4826 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x25_P2.54mm_Vertical" H 6750 3500 50  0001 C CNN
F 3 "~" H 6750 3500 50  0001 C CNN
	1    6750 3500
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0117
U 1 1 5FF388F9
P 7250 3400
F 0 "#PWR0117" H 7250 3250 50  0001 C CNN
F 1 "+5V" H 7265 3573 50  0000 C CNN
F 2 "" H 7250 3400 50  0001 C CNN
F 3 "" H 7250 3400 50  0001 C CNN
	1    7250 3400
	1    0    0    -1  
$EndComp
Wire Wire Line
	7250 3400 7050 3400
$Comp
L power:+5V #PWR0118
U 1 1 5FF38900
P 6250 3500
F 0 "#PWR0118" H 6250 3350 50  0001 C CNN
F 1 "+5V" H 6265 3673 50  0000 C CNN
F 2 "" H 6250 3500 50  0001 C CNN
F 3 "" H 6250 3500 50  0001 C CNN
	1    6250 3500
	1    0    0    -1  
$EndComp
Wire Wire Line
	6550 3500 6300 3500
$Comp
L power:GND #PWR0119
U 1 1 5FF38907
P 7250 3500
F 0 "#PWR0119" H 7250 3250 50  0001 C CNN
F 1 "GND" H 7255 3327 50  0000 C CNN
F 2 "" H 7250 3500 50  0001 C CNN
F 3 "" H 7250 3500 50  0001 C CNN
	1    7250 3500
	1    0    0    -1  
$EndComp
Wire Wire Line
	7250 3500 7050 3500
$Comp
L power:GND #PWR0120
U 1 1 5FF3890E
P 6100 3350
F 0 "#PWR0120" H 6100 3100 50  0001 C CNN
F 1 "GND" H 6105 3177 50  0000 C CNN
F 2 "" H 6100 3350 50  0001 C CNN
F 3 "" H 6100 3350 50  0001 C CNN
	1    6100 3350
	1    0    0    -1  
$EndComp
Wire Wire Line
	6350 3400 6350 3350
Wire Wire Line
	6350 3350 6100 3350
Wire Wire Line
	6350 3400 6550 3400
Text GLabel 6550 2300 0    50   Input ~ 0
A0
Text GLabel 6550 2400 0    50   Input ~ 0
A1
Text GLabel 6550 2500 0    50   Input ~ 0
A2
Text GLabel 6550 2600 0    50   Input ~ 0
A3
Text GLabel 6550 2700 0    50   Input ~ 0
A4
Text GLabel 6550 2800 0    50   Input ~ 0
A5
Text GLabel 6550 2900 0    50   Input ~ 0
A6
Text GLabel 6550 3000 0    50   Input ~ 0
A7
Text GLabel 6550 3100 0    50   Input ~ 0
A8
Text GLabel 6550 3200 0    50   Input ~ 0
A9
Text GLabel 6550 3300 0    50   Input ~ 0
A10
Text GLabel 6550 3600 0    50   Input ~ 0
A11
Text GLabel 6550 3700 0    50   Input ~ 0
A12
Text GLabel 6550 3800 0    50   Input ~ 0
A13
Text GLabel 6550 3900 0    50   Input ~ 0
A14
Text GLabel 6550 4000 0    50   Input ~ 0
A15
Text GLabel 7050 2300 2    50   BiDi ~ 0
D0
Text GLabel 7050 2400 2    50   BiDi ~ 0
D1
Text GLabel 7050 2500 2    50   BiDi ~ 0
D2
Text GLabel 7050 2600 2    50   BiDi ~ 0
D3
Text GLabel 7050 2700 2    50   BiDi ~ 0
D4
Text GLabel 7050 2800 2    50   BiDi ~ 0
D5
Text GLabel 7050 2900 2    50   BiDi ~ 0
D6
Text GLabel 7050 3000 2    50   BiDi ~ 0
D7
Text GLabel 6550 4700 0    50   Input ~ 0
~RESET~
Text GLabel 7050 4700 2    50   BiDi ~ 0
~NMI~
Text GLabel 6000 4100 0    50   Input ~ 0
RDY
Text GLabel 6000 4200 0    50   Input ~ 0
BE
Text GLabel 6550 4300 0    50   Input ~ 0
CLK
Text GLabel 6550 4400 0    50   Input ~ 0
R~W~
Text GLabel 6550 4600 0    50   Input ~ 0
SYNC
Text GLabel 6000 4500 0    50   Input ~ 0
~IRQ~
Text GLabel 7050 4600 2    50   BiDi ~ 0
~IRQ4~
$Comp
L Device:C_Small C10
U 1 1 5FF3893B
P 7400 3450
F 0 "C10" H 7492 3496 50  0000 L CNN
F 1 "C_Small" H 7492 3405 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 7400 3450 50  0001 C CNN
F 3 "~" H 7400 3450 50  0001 C CNN
	1    7400 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	7400 3350 7350 3350
Wire Wire Line
	7350 3350 7350 3400
Wire Wire Line
	7350 3400 7250 3400
Connection ~ 7250 3400
Wire Wire Line
	7400 3550 7350 3550
Wire Wire Line
	7350 3550 7350 3500
Wire Wire Line
	7350 3500 7250 3500
Connection ~ 7250 3500
Wire Wire Line
	6300 3550 6300 3500
Connection ~ 6300 3500
Wire Wire Line
	6300 3500 6250 3500
Wire Wire Line
	6000 4500 6550 4500
Wire Wire Line
	6000 4100 6550 4100
Wire Wire Line
	6000 4200 6550 4200
$Comp
L Connector_Generic:Conn_02x25_Odd_Even SLOT5
U 1 1 5FF3D28D
P 8950 3550
F 0 "SLOT5" H 9000 4967 50  0000 C CNN
F 1 "Conn_01x40" H 9000 4876 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x25_P2.54mm_Vertical" H 8950 3550 50  0001 C CNN
F 3 "~" H 8950 3550 50  0001 C CNN
	1    8950 3550
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0121
U 1 1 5FF3D293
P 9450 3450
F 0 "#PWR0121" H 9450 3300 50  0001 C CNN
F 1 "+5V" H 9465 3623 50  0000 C CNN
F 2 "" H 9450 3450 50  0001 C CNN
F 3 "" H 9450 3450 50  0001 C CNN
	1    9450 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	9450 3450 9250 3450
$Comp
L power:+5V #PWR0122
U 1 1 5FF3D29A
P 8450 3550
F 0 "#PWR0122" H 8450 3400 50  0001 C CNN
F 1 "+5V" H 8465 3723 50  0000 C CNN
F 2 "" H 8450 3550 50  0001 C CNN
F 3 "" H 8450 3550 50  0001 C CNN
	1    8450 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	8750 3550 8500 3550
$Comp
L power:GND #PWR0123
U 1 1 5FF3D2A1
P 9450 3550
F 0 "#PWR0123" H 9450 3300 50  0001 C CNN
F 1 "GND" H 9455 3377 50  0000 C CNN
F 2 "" H 9450 3550 50  0001 C CNN
F 3 "" H 9450 3550 50  0001 C CNN
	1    9450 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	9450 3550 9250 3550
$Comp
L power:GND #PWR0124
U 1 1 5FF3D2A8
P 8300 3400
F 0 "#PWR0124" H 8300 3150 50  0001 C CNN
F 1 "GND" H 8305 3227 50  0000 C CNN
F 2 "" H 8300 3400 50  0001 C CNN
F 3 "" H 8300 3400 50  0001 C CNN
	1    8300 3400
	1    0    0    -1  
$EndComp
Wire Wire Line
	8550 3450 8550 3400
Wire Wire Line
	8550 3400 8300 3400
Wire Wire Line
	8550 3450 8750 3450
Text GLabel 8750 2350 0    50   Input ~ 0
A0
Text GLabel 8750 2450 0    50   Input ~ 0
A1
Text GLabel 8750 2550 0    50   Input ~ 0
A2
Text GLabel 8750 2650 0    50   Input ~ 0
A3
Text GLabel 8750 2750 0    50   Input ~ 0
A4
Text GLabel 8750 2850 0    50   Input ~ 0
A5
Text GLabel 8750 2950 0    50   Input ~ 0
A6
Text GLabel 8750 3050 0    50   Input ~ 0
A7
Text GLabel 8750 3150 0    50   Input ~ 0
A8
Text GLabel 8750 3250 0    50   Input ~ 0
A9
Text GLabel 8750 3350 0    50   Input ~ 0
A10
Text GLabel 8750 3650 0    50   Input ~ 0
A11
Text GLabel 8750 3750 0    50   Input ~ 0
A12
Text GLabel 8750 3850 0    50   Input ~ 0
A13
Text GLabel 8750 3950 0    50   Input ~ 0
A14
Text GLabel 8750 4050 0    50   Input ~ 0
A15
Text GLabel 9250 2350 2    50   BiDi ~ 0
D0
Text GLabel 9250 2450 2    50   BiDi ~ 0
D1
Text GLabel 9250 2550 2    50   BiDi ~ 0
D2
Text GLabel 9250 2650 2    50   BiDi ~ 0
D3
Text GLabel 9250 2750 2    50   BiDi ~ 0
D4
Text GLabel 9250 2850 2    50   BiDi ~ 0
D5
Text GLabel 9250 2950 2    50   BiDi ~ 0
D6
Text GLabel 9250 3050 2    50   BiDi ~ 0
D7
Text GLabel 8750 4750 0    50   Input ~ 0
~RESET~
Text GLabel 9250 4750 2    50   BiDi ~ 0
~NMI~
Text GLabel 8200 4150 0    50   Input ~ 0
RDY
Text GLabel 8200 4250 0    50   Input ~ 0
BE
Text GLabel 8750 4350 0    50   Input ~ 0
CLK
Text GLabel 8750 4450 0    50   Input ~ 0
R~W~
Text GLabel 8750 4650 0    50   Input ~ 0
SYNC
Text GLabel 8200 4550 0    50   Input ~ 0
~IRQ~
$Comp
L Device:C_Small C11
U 1 1 5FF3D2E3
P 8100 3500
F 0 "C11" H 8192 3546 50  0000 L CNN
F 1 "C_Small" H 8192 3455 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 8100 3500 50  0001 C CNN
F 3 "~" H 8100 3500 50  0001 C CNN
	1    8100 3500
	1    0    0    -1  
$EndComp
Wire Wire Line
	8100 3400 8300 3400
Connection ~ 8300 3400
Wire Wire Line
	8100 3600 8500 3600
Wire Wire Line
	8500 3600 8500 3550
Connection ~ 8500 3550
Wire Wire Line
	8500 3550 8450 3550
Wire Wire Line
	8200 4550 8750 4550
Wire Wire Line
	8200 4150 8750 4150
Wire Wire Line
	8200 4250 8750 4250
$Comp
L Connector_Generic:Conn_02x25_Odd_Even SLOT1
U 1 1 5FF4AD1B
P 2950 6250
F 0 "SLOT1" H 3000 7667 50  0000 C CNN
F 1 "Conn_01x40" H 3000 7576 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x25_P2.54mm_Vertical" H 2950 6250 50  0001 C CNN
F 3 "~" H 2950 6250 50  0001 C CNN
	1    2950 6250
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0125
U 1 1 5FF4AD21
P 3450 6150
F 0 "#PWR0125" H 3450 6000 50  0001 C CNN
F 1 "+5V" H 3465 6323 50  0000 C CNN
F 2 "" H 3450 6150 50  0001 C CNN
F 3 "" H 3450 6150 50  0001 C CNN
	1    3450 6150
	1    0    0    -1  
$EndComp
Wire Wire Line
	3450 6150 3250 6150
$Comp
L power:+5V #PWR0126
U 1 1 5FF4AD28
P 2450 6250
F 0 "#PWR0126" H 2450 6100 50  0001 C CNN
F 1 "+5V" H 2465 6423 50  0000 C CNN
F 2 "" H 2450 6250 50  0001 C CNN
F 3 "" H 2450 6250 50  0001 C CNN
	1    2450 6250
	1    0    0    -1  
$EndComp
Wire Wire Line
	2750 6250 2500 6250
$Comp
L power:GND #PWR0127
U 1 1 5FF4AD2F
P 3450 6250
F 0 "#PWR0127" H 3450 6000 50  0001 C CNN
F 1 "GND" H 3455 6077 50  0000 C CNN
F 2 "" H 3450 6250 50  0001 C CNN
F 3 "" H 3450 6250 50  0001 C CNN
	1    3450 6250
	1    0    0    -1  
$EndComp
Wire Wire Line
	3450 6250 3250 6250
$Comp
L power:GND #PWR0128
U 1 1 5FF4AD36
P 2300 6100
F 0 "#PWR0128" H 2300 5850 50  0001 C CNN
F 1 "GND" H 2305 5927 50  0000 C CNN
F 2 "" H 2300 6100 50  0001 C CNN
F 3 "" H 2300 6100 50  0001 C CNN
	1    2300 6100
	1    0    0    -1  
$EndComp
Wire Wire Line
	2550 6150 2550 6100
Wire Wire Line
	2550 6100 2300 6100
Wire Wire Line
	2550 6150 2750 6150
Text GLabel 2750 5050 0    50   Input ~ 0
A0
Text GLabel 2750 5150 0    50   Input ~ 0
A1
Text GLabel 2750 5250 0    50   Input ~ 0
A2
Text GLabel 2750 5350 0    50   Input ~ 0
A3
Text GLabel 2750 5450 0    50   Input ~ 0
A4
Text GLabel 2750 5550 0    50   Input ~ 0
A5
Text GLabel 2750 5650 0    50   Input ~ 0
A6
Text GLabel 2750 5750 0    50   Input ~ 0
A7
Text GLabel 2750 5850 0    50   Input ~ 0
A8
Text GLabel 2750 5950 0    50   Input ~ 0
A9
Text GLabel 2750 6050 0    50   Input ~ 0
A10
Text GLabel 2750 6350 0    50   Input ~ 0
A11
Text GLabel 2750 6450 0    50   Input ~ 0
A12
Text GLabel 2750 6550 0    50   Input ~ 0
A13
Text GLabel 2750 6650 0    50   Input ~ 0
A14
Text GLabel 2750 6750 0    50   Input ~ 0
A15
Text GLabel 3250 5050 2    50   BiDi ~ 0
D0
Text GLabel 3250 5150 2    50   BiDi ~ 0
D1
Text GLabel 3250 5250 2    50   BiDi ~ 0
D2
Text GLabel 3250 5350 2    50   BiDi ~ 0
D3
Text GLabel 3250 5450 2    50   BiDi ~ 0
D4
Text GLabel 3250 5550 2    50   BiDi ~ 0
D5
Text GLabel 3250 5650 2    50   BiDi ~ 0
D6
Text GLabel 3250 5750 2    50   BiDi ~ 0
D7
Text GLabel 2750 7450 0    50   Input ~ 0
~RESET~
Text GLabel 3250 7450 2    50   BiDi ~ 0
~NMI~
Text GLabel 2200 6850 0    50   Input ~ 0
RDY
Text GLabel 2200 6950 0    50   Input ~ 0
BE
Text GLabel 2750 7050 0    50   Input ~ 0
CLK
Text GLabel 2750 7150 0    50   Input ~ 0
R~W~
Text GLabel 2750 7350 0    50   Input ~ 0
SYNC
Text GLabel 2200 7250 0    50   Input ~ 0
~IRQ~
Text GLabel 3250 7350 2    50   BiDi ~ 0
~IRQ1~
Wire Wire Line
	3550 6100 3550 6150
Wire Wire Line
	3550 6150 3450 6150
Connection ~ 3450 6150
Wire Wire Line
	3550 6300 3550 6250
Wire Wire Line
	3550 6250 3450 6250
Connection ~ 3450 6250
$Comp
L Device:C_Small C3
U 1 1 5FF4AD71
P 2100 6200
F 0 "C3" H 2192 6246 50  0000 L CNN
F 1 "C_Small" H 2192 6155 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 2100 6200 50  0001 C CNN
F 3 "~" H 2100 6200 50  0001 C CNN
	1    2100 6200
	1    0    0    -1  
$EndComp
Wire Wire Line
	2100 6100 2300 6100
Connection ~ 2300 6100
Wire Wire Line
	2100 6300 2500 6300
Wire Wire Line
	2500 6300 2500 6250
Connection ~ 2500 6250
Wire Wire Line
	2500 6250 2450 6250
Wire Wire Line
	2200 7250 2750 7250
Wire Wire Line
	2200 6850 2750 6850
Wire Wire Line
	2200 6950 2750 6950
$Comp
L Connector_Generic:Conn_02x25_Odd_Even SLOT3
U 1 1 5FF52D4F
P 5050 6350
F 0 "SLOT3" H 5100 7767 50  0000 C CNN
F 1 "Conn_01x40" H 5100 7676 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x25_P2.54mm_Vertical" H 5050 6350 50  0001 C CNN
F 3 "~" H 5050 6350 50  0001 C CNN
	1    5050 6350
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0129
U 1 1 5FF52D55
P 5550 6250
F 0 "#PWR0129" H 5550 6100 50  0001 C CNN
F 1 "+5V" H 5565 6423 50  0000 C CNN
F 2 "" H 5550 6250 50  0001 C CNN
F 3 "" H 5550 6250 50  0001 C CNN
	1    5550 6250
	1    0    0    -1  
$EndComp
Wire Wire Line
	5550 6250 5350 6250
$Comp
L power:+5V #PWR0130
U 1 1 5FF52D5C
P 4550 6350
F 0 "#PWR0130" H 4550 6200 50  0001 C CNN
F 1 "+5V" H 4565 6523 50  0000 C CNN
F 2 "" H 4550 6350 50  0001 C CNN
F 3 "" H 4550 6350 50  0001 C CNN
	1    4550 6350
	1    0    0    -1  
$EndComp
Wire Wire Line
	4850 6350 4600 6350
$Comp
L power:GND #PWR0131
U 1 1 5FF52D63
P 5550 6350
F 0 "#PWR0131" H 5550 6100 50  0001 C CNN
F 1 "GND" H 5555 6177 50  0000 C CNN
F 2 "" H 5550 6350 50  0001 C CNN
F 3 "" H 5550 6350 50  0001 C CNN
	1    5550 6350
	1    0    0    -1  
$EndComp
Wire Wire Line
	5550 6350 5350 6350
$Comp
L power:GND #PWR0132
U 1 1 5FF52D6A
P 4400 6200
F 0 "#PWR0132" H 4400 5950 50  0001 C CNN
F 1 "GND" H 4405 6027 50  0000 C CNN
F 2 "" H 4400 6200 50  0001 C CNN
F 3 "" H 4400 6200 50  0001 C CNN
	1    4400 6200
	1    0    0    -1  
$EndComp
Wire Wire Line
	4650 6250 4650 6200
Wire Wire Line
	4650 6200 4400 6200
Wire Wire Line
	4650 6250 4850 6250
Text GLabel 4850 5150 0    50   Input ~ 0
A0
Text GLabel 4850 5250 0    50   Input ~ 0
A1
Text GLabel 4850 5350 0    50   Input ~ 0
A2
Text GLabel 4850 5450 0    50   Input ~ 0
A3
Text GLabel 4850 5550 0    50   Input ~ 0
A4
Text GLabel 4850 5650 0    50   Input ~ 0
A5
Text GLabel 4850 5750 0    50   Input ~ 0
A6
Text GLabel 4850 5850 0    50   Input ~ 0
A7
Text GLabel 4850 5950 0    50   Input ~ 0
A8
Text GLabel 4850 6050 0    50   Input ~ 0
A9
Text GLabel 4850 6150 0    50   Input ~ 0
A10
Text GLabel 4850 6450 0    50   Input ~ 0
A11
Text GLabel 4850 6550 0    50   Input ~ 0
A12
Text GLabel 4850 6650 0    50   Input ~ 0
A13
Text GLabel 4850 6750 0    50   Input ~ 0
A14
Text GLabel 4850 6850 0    50   Input ~ 0
A15
Text GLabel 5350 5150 2    50   BiDi ~ 0
D0
Text GLabel 5350 5250 2    50   BiDi ~ 0
D1
Text GLabel 5350 5350 2    50   BiDi ~ 0
D2
Text GLabel 5350 5450 2    50   BiDi ~ 0
D3
Text GLabel 5350 5550 2    50   BiDi ~ 0
D4
Text GLabel 5350 5650 2    50   BiDi ~ 0
D5
Text GLabel 5350 5750 2    50   BiDi ~ 0
D6
Text GLabel 5350 5850 2    50   BiDi ~ 0
D7
Text GLabel 4850 7550 0    50   Input ~ 0
~RESET~
Text GLabel 5350 7550 2    50   BiDi ~ 0
~NMI~
Text GLabel 4300 6950 0    50   Input ~ 0
RDY
Text GLabel 4300 7050 0    50   Input ~ 0
BE
Text GLabel 4850 7150 0    50   Input ~ 0
CLK
Text GLabel 4850 7250 0    50   Input ~ 0
R~W~
Text GLabel 4850 7450 0    50   Input ~ 0
SYNC
Text GLabel 4300 7350 0    50   Input ~ 0
~IRQ~
Text GLabel 5350 7450 2    50   BiDi ~ 0
~IRQ3~
$Comp
L Device:C_Small C8
U 1 1 5FF52D97
P 5700 6300
F 0 "C8" H 5792 6346 50  0000 L CNN
F 1 "C_Small" H 5792 6255 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 5700 6300 50  0001 C CNN
F 3 "~" H 5700 6300 50  0001 C CNN
	1    5700 6300
	1    0    0    -1  
$EndComp
Wire Wire Line
	5700 6200 5650 6200
Wire Wire Line
	5650 6200 5650 6250
Wire Wire Line
	5650 6250 5550 6250
Connection ~ 5550 6250
Wire Wire Line
	5700 6400 5650 6400
Wire Wire Line
	5650 6400 5650 6350
Wire Wire Line
	5650 6350 5550 6350
Connection ~ 5550 6350
$Comp
L Device:C_Small C6
U 1 1 5FF52DA5
P 4200 6300
F 0 "C6" H 4292 6346 50  0000 L CNN
F 1 "C_Small" H 4292 6255 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 4200 6300 50  0001 C CNN
F 3 "~" H 4200 6300 50  0001 C CNN
	1    4200 6300
	1    0    0    -1  
$EndComp
Wire Wire Line
	4200 6200 4400 6200
Connection ~ 4400 6200
Wire Wire Line
	4200 6400 4600 6400
Wire Wire Line
	4600 6400 4600 6350
Connection ~ 4600 6350
Wire Wire Line
	4600 6350 4550 6350
Wire Wire Line
	4300 7350 4850 7350
Wire Wire Line
	4300 6950 4850 6950
Wire Wire Line
	4300 7050 4850 7050
Text GLabel 4950 3150 2    50   BiDi ~ 0
EX0
Text GLabel 4950 3250 2    50   BiDi ~ 0
EX1
Text GLabel 4950 3350 2    50   BiDi ~ 0
~SLOW2~
Text GLabel 4950 3750 2    50   BiDi ~ 0
~INH~
Text GLabel 4950 3850 2    50   BiDi ~ 0
SLOT2
Text GLabel 2800 3950 2    50   BiDi ~ 0
LED1
Text GLabel 2800 4050 2    50   BiDi ~ 0
LED2
Text GLabel 2800 4150 2    50   BiDi ~ 0
LED3
Text GLabel 2800 4250 2    50   BiDi ~ 0
LED4
Text GLabel 2800 3150 2    50   BiDi ~ 0
EX0
Text GLabel 2800 3250 2    50   BiDi ~ 0
EX1
Text GLabel 3250 5850 2    50   BiDi ~ 0
EX0
Text GLabel 3250 5950 2    50   BiDi ~ 0
EX1
Text GLabel 5350 5950 2    50   BiDi ~ 0
EX0
Text GLabel 5350 6050 2    50   BiDi ~ 0
EX1
Text GLabel 7050 3100 2    50   BiDi ~ 0
EX0
Text GLabel 7050 3200 2    50   BiDi ~ 0
EX1
Text GLabel 9250 3150 2    50   BiDi ~ 0
EX0
Text GLabel 9250 3250 2    50   BiDi ~ 0
EX1
$Comp
L Switch:SW_SPST SW1
U 1 1 60031505
P 2250 1100
F 0 "SW1" H 2250 1335 50  0000 C CNN
F 1 "SW_SPST" H 2250 1244 50  0000 C CNN
F 2 "Button_Switch_THT:SW_E-Switch_EG1271_DPDT" H 2250 1100 50  0001 C CNN
F 3 "~" H 2250 1100 50  0001 C CNN
	1    2250 1100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0133
U 1 1 60033398
P 2550 1300
F 0 "#PWR0133" H 2550 1050 50  0001 C CNN
F 1 "GND" H 2555 1127 50  0000 C CNN
F 2 "" H 2550 1300 50  0001 C CNN
F 3 "" H 2550 1300 50  0001 C CNN
	1    2550 1300
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0134
U 1 1 60039848
P 2700 1100
F 0 "#PWR0134" H 2700 950 50  0001 C CNN
F 1 "+5V" H 2715 1273 50  0000 C CNN
F 2 "" H 2700 1100 50  0001 C CNN
F 3 "" H 2700 1100 50  0001 C CNN
	1    2700 1100
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C13
U 1 1 6003A557
P 2550 1200
F 0 "C13" H 2642 1246 50  0000 L CNN
F 1 "C_Small" H 2642 1155 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D6.3mm_P2.50mm" H 2550 1200 50  0001 C CNN
F 3 "~" H 2550 1200 50  0001 C CNN
	1    2550 1200
	1    0    0    -1  
$EndComp
$Comp
L Power_Supervisor:MAX811SEUS-T U3
U 1 1 600754D0
P 8850 1100
F 0 "U3" H 9294 1146 50  0000 L CNN
F 1 "MAX811SEUS-T" H 8550 500 50  0000 L CNN
F 2 "Package_TO_SOT_SMD:SOT-143" H 8950 800 50  0001 L CNN
F 3 "https://datasheets.maximintegrated.com/en/ds/MAX811-MAX812.pdf" H 8500 400 50  0001 C CNN
	1    8850 1100
	1    0    0    -1  
$EndComp
$Comp
L Power_Supervisor:MAX811SEUS-T U2
U 1 1 6007822A
P 7050 1100
F 0 "U2" H 7494 1146 50  0000 L CNN
F 1 "MAX811SEUS-T" H 7494 1055 50  0000 L CNN
F 2 "Package_TO_SOT_SMD:SOT-143" H 7150 800 50  0001 L CNN
F 3 "https://datasheets.maximintegrated.com/en/ds/MAX811-MAX812.pdf" H 6700 400 50  0001 C CNN
	1    7050 1100
	1    0    0    -1  
$EndComp
Text GLabel 9950 1100 2    50   Output ~ 0
~NMI~
Text GLabel 7450 1100 2    50   Output ~ 0
~RESET~
$Comp
L power:GND #PWR0135
U 1 1 6008D891
P 8850 1400
F 0 "#PWR0135" H 8850 1150 50  0001 C CNN
F 1 "GND" H 8855 1227 50  0000 C CNN
F 2 "" H 8850 1400 50  0001 C CNN
F 3 "" H 8850 1400 50  0001 C CNN
	1    8850 1400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0136
U 1 1 60092C1C
P 7050 1400
F 0 "#PWR0136" H 7050 1150 50  0001 C CNN
F 1 "GND" H 7055 1227 50  0000 C CNN
F 2 "" H 7050 1400 50  0001 C CNN
F 3 "" H 7050 1400 50  0001 C CNN
	1    7050 1400
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0137
U 1 1 60098175
P 8850 800
F 0 "#PWR0137" H 8850 650 50  0001 C CNN
F 1 "+5V" H 8865 973 50  0000 C CNN
F 2 "" H 8850 800 50  0001 C CNN
F 3 "" H 8850 800 50  0001 C CNN
	1    8850 800 
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0138
U 1 1 6009D5D9
P 7050 800
F 0 "#PWR0138" H 7050 650 50  0001 C CNN
F 1 "+5V" H 7065 973 50  0000 C CNN
F 2 "" H 7050 800 50  0001 C CNN
F 3 "" H 7050 800 50  0001 C CNN
	1    7050 800 
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Push RESET1
U 1 1 600A3302
P 6450 1100
F 0 "RESET1" H 6450 1385 50  0000 C CNN
F 1 "SW_Push" H 6450 1294 50  0000 C CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm" H 6450 1300 50  0001 C CNN
F 3 "~" H 6450 1300 50  0001 C CNN
	1    6450 1100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0139
U 1 1 600A3D95
P 6250 1100
F 0 "#PWR0139" H 6250 850 50  0001 C CNN
F 1 "GND" H 6255 927 50  0000 C CNN
F 2 "" H 6250 1100 50  0001 C CNN
F 3 "" H 6250 1100 50  0001 C CNN
	1    6250 1100
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Push NMI1
U 1 1 600A9CE7
P 8250 1100
F 0 "NMI1" H 8250 1385 50  0000 C CNN
F 1 "SW_Push" H 8250 1294 50  0000 C CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm" H 8250 1300 50  0001 C CNN
F 3 "~" H 8250 1300 50  0001 C CNN
	1    8250 1100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0140
U 1 1 600A9CED
P 8050 1100
F 0 "#PWR0140" H 8050 850 50  0001 C CNN
F 1 "GND" H 8055 927 50  0000 C CNN
F 2 "" H 8050 1100 50  0001 C CNN
F 3 "" H 8050 1100 50  0001 C CNN
	1    8050 1100
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D1
U 1 1 600C2792
P 5150 1400
F 0 "D1" H 5143 1617 50  0000 C CNN
F 1 "LED" H 5143 1526 50  0000 C CNN
F 2 "LED_SMD:LED_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 5150 1400 50  0001 C CNN
F 3 "~" H 5150 1400 50  0001 C CNN
	1    5150 1400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0141
U 1 1 600C38C8
P 4800 1400
F 0 "#PWR0141" H 4800 1150 50  0001 C CNN
F 1 "GND" H 4805 1227 50  0000 C CNN
F 2 "" H 4800 1400 50  0001 C CNN
F 3 "" H 4800 1400 50  0001 C CNN
	1    4800 1400
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0142
U 1 1 600C9343
P 5300 1400
F 0 "#PWR0142" H 5300 1250 50  0001 C CNN
F 1 "+5V" H 5315 1573 50  0000 C CNN
F 2 "" H 5300 1400 50  0001 C CNN
F 3 "" H 5300 1400 50  0001 C CNN
	1    5300 1400
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R9
U 1 1 600D37C9
P 4900 1400
F 0 "R9" V 4704 1400 50  0000 C CNN
F 1 "470R" V 4795 1400 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 4900 1400 50  0001 C CNN
F 3 "~" H 4900 1400 50  0001 C CNN
	1    4900 1400
	0    1    1    0   
$EndComp
$Comp
L Device:LED LED1
U 1 1 5FD70952
P 4200 950
F 0 "LED1" H 4193 1167 50  0000 C CNN
F 1 "LED" H 4193 1076 50  0000 C CNN
F 2 "LED_SMD:LED_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 4200 950 50  0001 C CNN
F 3 "~" H 4200 950 50  0001 C CNN
	1    4200 950 
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R10
U 1 1 5FD7194C
P 3950 950
F 0 "R10" V 3754 950 50  0000 C CNN
F 1 "470R" V 3845 950 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 3950 950 50  0001 C CNN
F 3 "~" H 3950 950 50  0001 C CNN
	1    3950 950 
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR0143
U 1 1 5FD72A10
P 3850 950
F 0 "#PWR0143" H 3850 700 50  0001 C CNN
F 1 "GND" H 3855 777 50  0000 C CNN
F 2 "" H 3850 950 50  0001 C CNN
F 3 "" H 3850 950 50  0001 C CNN
	1    3850 950 
	1    0    0    -1  
$EndComp
$Comp
L Device:LED LED2
U 1 1 5FD88685
P 4200 1400
F 0 "LED2" H 4193 1617 50  0000 C CNN
F 1 "LED" H 4193 1526 50  0000 C CNN
F 2 "LED_SMD:LED_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 4200 1400 50  0001 C CNN
F 3 "~" H 4200 1400 50  0001 C CNN
	1    4200 1400
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R11
U 1 1 5FD8868B
P 3950 1400
F 0 "R11" V 3754 1400 50  0000 C CNN
F 1 "470R" V 3845 1400 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 3950 1400 50  0001 C CNN
F 3 "~" H 3950 1400 50  0001 C CNN
	1    3950 1400
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR0144
U 1 1 5FD88691
P 3850 1400
F 0 "#PWR0144" H 3850 1150 50  0001 C CNN
F 1 "GND" H 3855 1227 50  0000 C CNN
F 2 "" H 3850 1400 50  0001 C CNN
F 3 "" H 3850 1400 50  0001 C CNN
	1    3850 1400
	1    0    0    -1  
$EndComp
$Comp
L Device:LED LED3
U 1 1 5FD8E89F
P 4200 1750
F 0 "LED3" H 4193 1967 50  0000 C CNN
F 1 "LED" H 4193 1876 50  0000 C CNN
F 2 "LED_SMD:LED_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 4200 1750 50  0001 C CNN
F 3 "~" H 4200 1750 50  0001 C CNN
	1    4200 1750
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R12
U 1 1 5FD8E8A5
P 3950 1750
F 0 "R12" V 3754 1750 50  0000 C CNN
F 1 "470R" V 3845 1750 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 3950 1750 50  0001 C CNN
F 3 "~" H 3950 1750 50  0001 C CNN
	1    3950 1750
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR0145
U 1 1 5FD8E8AB
P 3850 1750
F 0 "#PWR0145" H 3850 1500 50  0001 C CNN
F 1 "GND" H 3855 1577 50  0000 C CNN
F 2 "" H 3850 1750 50  0001 C CNN
F 3 "" H 3850 1750 50  0001 C CNN
	1    3850 1750
	1    0    0    -1  
$EndComp
$Comp
L Device:LED LED4
U 1 1 5FD9443D
P 5150 950
F 0 "LED4" H 5143 1167 50  0000 C CNN
F 1 "LED" H 5143 1076 50  0000 C CNN
F 2 "LED_SMD:LED_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 5150 950 50  0001 C CNN
F 3 "~" H 5150 950 50  0001 C CNN
	1    5150 950 
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R13
U 1 1 5FD94443
P 4900 950
F 0 "R13" V 4704 950 50  0000 C CNN
F 1 "470R" V 4795 950 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 4900 950 50  0001 C CNN
F 3 "~" H 4900 950 50  0001 C CNN
	1    4900 950 
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR0146
U 1 1 5FD94449
P 4800 950
F 0 "#PWR0146" H 4800 700 50  0001 C CNN
F 1 "GND" H 4805 777 50  0000 C CNN
F 2 "" H 4800 950 50  0001 C CNN
F 3 "" H 4800 950 50  0001 C CNN
	1    4800 950 
	1    0    0    -1  
$EndComp
$Comp
L Logic_Programmable:PAL24 U4
U 1 1 5FDAA30B
P 11600 6850
F 0 "U4" H 11600 7831 50  0000 C CNN
F 1 "PAL24" H 11600 7740 50  0000 C CNN
F 2 "Package_DIP:DIP-24_W7.62mm_Socket" H 11600 6800 50  0001 C CNN
F 3 "~" H 11600 6800 50  0001 C CNN
	1    11600 6850
	1    0    0    -1  
$EndComp
Text GLabel 4950 3950 2    50   BiDi ~ 0
LED1
Text GLabel 4950 4050 2    50   BiDi ~ 0
LED2
Text GLabel 4950 4150 2    50   BiDi ~ 0
LED3
Text GLabel 4950 4250 2    50   BiDi ~ 0
LED4
Text GLabel 7050 3900 2    50   BiDi ~ 0
LED1
Text GLabel 7050 4000 2    50   BiDi ~ 0
LED2
Text GLabel 7050 4100 2    50   BiDi ~ 0
LED3
Text GLabel 7050 4200 2    50   BiDi ~ 0
LED4
Text GLabel 9250 3950 2    50   BiDi ~ 0
LED1
Text GLabel 9250 4050 2    50   BiDi ~ 0
LED2
Text GLabel 9250 4150 2    50   BiDi ~ 0
LED3
Text GLabel 9250 4250 2    50   BiDi ~ 0
LED4
Text GLabel 5350 6750 2    50   BiDi ~ 0
LED1
Text GLabel 5350 6850 2    50   BiDi ~ 0
LED2
Text GLabel 5350 6950 2    50   BiDi ~ 0
LED3
Text GLabel 5350 7050 2    50   BiDi ~ 0
LED4
Text GLabel 3250 6650 2    50   BiDi ~ 0
LED1
Text GLabel 3250 6750 2    50   BiDi ~ 0
LED2
Text GLabel 3250 6850 2    50   BiDi ~ 0
LED3
Text GLabel 3250 6950 2    50   BiDi ~ 0
LED4
Text GLabel 4350 950  2    50   BiDi ~ 0
LED1
Text GLabel 4350 1400 2    50   BiDi ~ 0
LED2
Text GLabel 4350 1750 2    50   BiDi ~ 0
LED3
Text GLabel 5300 950  2    50   BiDi ~ 0
LED4
Text GLabel 2800 3350 2    50   BiDi ~ 0
~SLOW0~
Text GLabel 2800 3650 2    50   BiDi ~ 0
~SSEL~
Text GLabel 7050 3300 2    50   BiDi ~ 0
~SLOW4~
Text GLabel 7050 3700 2    50   BiDi ~ 0
~INH~
Text GLabel 7050 3800 2    50   BiDi ~ 0
SLOT4
Text GLabel 9250 3350 2    50   BiDi ~ 0
~SLOW5~
Text GLabel 9250 3750 2    50   BiDi ~ 0
~INH~
Text GLabel 9250 3850 2    50   BiDi ~ 0
SLOT5
Text GLabel 5350 6150 2    50   BiDi ~ 0
~SLOW3~
Text GLabel 5350 6550 2    50   BiDi ~ 0
~INH~
Text GLabel 5350 6650 2    50   BiDi ~ 0
SLOT3
Text GLabel 3250 6050 2    50   BiDi ~ 0
~SLOW1~
Text GLabel 3250 6450 2    50   BiDi ~ 0
~INH~
Text GLabel 3250 6550 2    50   BiDi ~ 0
SLOT1
Text GLabel 11000 6450 0    50   Input ~ 0
A4
Text GLabel 11000 6550 0    50   Input ~ 0
A5
Text GLabel 11000 6650 0    50   Input ~ 0
A6
Text GLabel 11000 6750 0    50   Input ~ 0
A7
Text GLabel 11000 6850 0    50   Input ~ 0
A8
Text GLabel 11000 6950 0    50   Input ~ 0
A9
$Comp
L power:+5V #PWR0147
U 1 1 5FE5238B
P 11600 5600
F 0 "#PWR0147" H 11600 5450 50  0001 C CNN
F 1 "+5V" H 11615 5773 50  0000 C CNN
F 2 "" H 11600 5600 50  0001 C CNN
F 3 "" H 11600 5600 50  0001 C CNN
	1    11600 5600
	1    0    0    -1  
$EndComp
Wire Wire Line
	11600 6050 11600 5750
Text GLabel 11000 7050 0    50   Input ~ 0
A10
Text GLabel 11000 7150 0    50   Input ~ 0
A11
Text GLabel 11000 7250 0    50   Input ~ 0
A12
Text GLabel 11000 7350 0    50   Input ~ 0
A13
Text GLabel 12200 6250 2    50   Input ~ 0
A14
Text GLabel 12200 7350 2    50   Input ~ 0
A15
Text GLabel 12200 6750 2    50   Output ~ 0
SLOT4
Text GLabel 12200 6650 2    50   Output ~ 0
SLOT3
Text GLabel 12200 6550 2    50   Output ~ 0
SLOT2
Text GLabel 12200 6450 2    50   Output ~ 0
SLOT1
$Comp
L power:GND #PWR0148
U 1 1 5FEA08DB
P 11600 7550
F 0 "#PWR0148" H 11600 7300 50  0001 C CNN
F 1 "GND" H 11605 7377 50  0000 C CNN
F 2 "" H 11600 7550 50  0001 C CNN
F 3 "" H 11600 7550 50  0001 C CNN
	1    11600 7550
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C14
U 1 1 5FEA6281
P 11850 5750
F 0 "C14" H 11942 5796 50  0000 L CNN
F 1 "C_Small" H 11942 5705 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 11850 5750 50  0001 C CNN
F 3 "~" H 11850 5750 50  0001 C CNN
	1    11850 5750
	0    -1   -1   0   
$EndComp
Wire Wire Line
	11750 5750 11600 5750
Connection ~ 11600 5750
Wire Wire Line
	11600 5750 11600 5600
$Comp
L power:GND #PWR0149
U 1 1 5FEB1537
P 11950 5750
F 0 "#PWR0149" H 11950 5500 50  0001 C CNN
F 1 "GND" H 11955 5577 50  0000 C CNN
F 2 "" H 11950 5750 50  0001 C CNN
F 3 "" H 11950 5750 50  0001 C CNN
	1    11950 5750
	1    0    0    -1  
$EndComp
Text GLabel 12200 6850 2    50   Output ~ 0
SLOT5
Text GLabel 12200 6950 2    50   Output ~ 0
~SSEL~
Text GLabel 2800 3750 2    50   BiDi ~ 0
~INH~
Text GLabel 1150 7350 0    50   BiDi ~ 0
~INH~
$Comp
L Device:R_Small R14
U 1 1 5FE6B3EF
P 1250 7350
F 0 "R14" V 1054 7350 50  0000 C CNN
F 1 "1k" V 1145 7350 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1250 7350 50  0001 C CNN
F 3 "~" H 1250 7350 50  0001 C CNN
	1    1250 7350
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR0150
U 1 1 5FE6B3F5
P 1350 7350
F 0 "#PWR0150" H 1350 7200 50  0001 C CNN
F 1 "+5V" H 1365 7523 50  0000 C CNN
F 2 "" H 1350 7350 50  0001 C CNN
F 3 "" H 1350 7350 50  0001 C CNN
	1    1350 7350
	0    1    1    0   
$EndComp
Text GLabel 1150 7550 0    50   BiDi ~ 0
~SSEL~
$Comp
L Device:R_Small R15
U 1 1 5FE705F3
P 1250 7550
F 0 "R15" V 1054 7550 50  0000 C CNN
F 1 "1k" V 1145 7550 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1250 7550 50  0001 C CNN
F 3 "~" H 1250 7550 50  0001 C CNN
	1    1250 7550
	0    1    1    0   
$EndComp
$Comp
L power:+5V #PWR0151
U 1 1 5FE705F9
P 1350 7550
F 0 "#PWR0151" H 1350 7400 50  0001 C CNN
F 1 "+5V" H 1365 7723 50  0000 C CNN
F 2 "" H 1350 7550 50  0001 C CNN
F 3 "" H 1350 7550 50  0001 C CNN
	1    1350 7550
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR0152
U 1 1 5FE6F83B
P 1250 1800
F 0 "#PWR0152" H 1250 1550 50  0001 C CNN
F 1 "GND" H 1255 1627 50  0000 C CNN
F 2 "" H 1250 1800 50  0001 C CNN
F 3 "" H 1250 1800 50  0001 C CNN
	1    1250 1800
	1    0    0    -1  
$EndComp
$Comp
L Connector:USB_B_Micro J1
U 1 1 5FE9DEAA
P 1250 1300
F 0 "J1" H 1307 1767 50  0000 C CNN
F 1 "USB_B_Micro" H 1307 1676 50  0000 C CNN
F 2 "Connector_USB:USB_Micro-B_Molex-105017-0001" H 1400 1250 50  0001 C CNN
F 3 "~" H 1400 1250 50  0001 C CNN
	1    1250 1300
	1    0    0    -1  
$EndComp
Wire Wire Line
	1250 1800 1250 1700
Wire Wire Line
	1250 1700 1150 1700
$Comp
L Oscillator:CXO_DIP8 X1
U 1 1 5FE8F313
P 7400 6650
F 0 "X1" H 7744 6696 50  0000 L CNN
F 1 "24MHz" H 7744 6605 50  0000 L CNN
F 2 "Oscillator:Oscillator_DIP-8" H 7850 6300 50  0001 C CNN
F 3 "http://cdn-reichelt.de/documents/datenblatt/B400/OSZI.pdf" H 7300 6650 50  0001 C CNN
	1    7400 6650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0153
U 1 1 5FE8FD3D
P 7400 6950
F 0 "#PWR0153" H 7400 6700 50  0001 C CNN
F 1 "GND" H 7405 6777 50  0000 C CNN
F 2 "" H 7400 6950 50  0001 C CNN
F 3 "" H 7400 6950 50  0001 C CNN
	1    7400 6950
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0154
U 1 1 5FE958FF
P 7400 5900
F 0 "#PWR0154" H 7400 5750 50  0001 C CNN
F 1 "+5V" H 7415 6073 50  0000 C CNN
F 2 "" H 7400 5900 50  0001 C CNN
F 3 "" H 7400 5900 50  0001 C CNN
	1    7400 5900
	1    0    0    -1  
$EndComp
Wire Wire Line
	7400 6350 7400 6050
$Comp
L Device:C_Small C4
U 1 1 5FE95906
P 7650 6050
F 0 "C4" H 7742 6096 50  0000 L CNN
F 1 "C_Small" H 7742 6005 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 7650 6050 50  0001 C CNN
F 3 "~" H 7650 6050 50  0001 C CNN
	1    7650 6050
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7550 6050 7400 6050
Connection ~ 7400 6050
Wire Wire Line
	7400 6050 7400 5900
$Comp
L power:GND #PWR0155
U 1 1 5FE9590F
P 7750 6050
F 0 "#PWR0155" H 7750 5800 50  0001 C CNN
F 1 "GND" H 7755 5877 50  0000 C CNN
F 2 "" H 7750 6050 50  0001 C CNN
F 3 "" H 7750 6050 50  0001 C CNN
	1    7750 6050
	1    0    0    -1  
$EndComp
Text GLabel 4950 3650 2    50   BiDi ~ 0
~SSEL~
Text GLabel 7050 3600 2    50   BiDi ~ 0
~SSEL~
Text GLabel 9250 3650 2    50   BiDi ~ 0
~SSEL~
Text GLabel 5350 6450 2    50   BiDi ~ 0
~SSEL~
Text GLabel 3250 6350 2    50   BiDi ~ 0
~SSEL~
Connection ~ 1250 1700
Text GLabel 4950 4350 2    50   BiDi ~ 0
CLK_12M
Text GLabel 4950 4450 2    50   BiDi ~ 0
EX2
Text GLabel 4950 4550 2    50   BiDi ~ 0
EX3
Text GLabel 7050 4300 2    50   BiDi ~ 0
CLK_12M
Text GLabel 9250 4350 2    50   BiDi ~ 0
CLK_12M
Text GLabel 5350 7150 2    50   BiDi ~ 0
CLK_12M
Text GLabel 3250 7050 2    50   BiDi ~ 0
CLK_12M
Text GLabel 2800 4350 2    50   BiDi ~ 0
~IRQ4~
Text GLabel 2800 4450 2    50   BiDi ~ 0
~IRQ3~
Text GLabel 2800 4550 2    50   BiDi ~ 0
~IRQ2~
Text GLabel 2800 4650 2    50   BiDi ~ 0
~IRQ1~
Wire Wire Line
	2700 1100 2550 1100
Connection ~ 2550 1100
Wire Wire Line
	2550 1100 2450 1100
Wire Wire Line
	1550 1100 2050 1100
Wire Wire Line
	9950 1100 9750 1100
Wire Wire Line
	9550 1100 9250 1100
$Comp
L Device:R_Small R16
U 1 1 60052F9C
P 9650 1100
F 0 "R16" V 9454 1100 50  0000 C CNN
F 1 "4.7k" V 9545 1100 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 9650 1100 50  0001 C CNN
F 3 "~" H 9650 1100 50  0001 C CNN
	1    9650 1100
	0    1    1    0   
$EndComp
$Comp
L 74xx:74LS161 U1
U 1 1 5FF93A76
P 9000 6700
F 0 "U1" H 9000 7681 50  0000 C CNN
F 1 "74AC161" H 9000 7590 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 9000 6700 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS163" H 9000 6700 50  0001 C CNN
	1    9000 6700
	1    0    0    -1  
$EndComp
Text GLabel 8500 7200 0    50   Input ~ 0
~RESET~
Wire Wire Line
	7700 6650 7750 6650
Wire Wire Line
	7750 6650 7750 7000
Wire Wire Line
	7750 7000 8500 7000
$Comp
L power:GND #PWR0156
U 1 1 5FFC8C82
P 9000 7500
F 0 "#PWR0156" H 9000 7250 50  0001 C CNN
F 1 "GND" H 9005 7327 50  0000 C CNN
F 2 "" H 9000 7500 50  0001 C CNN
F 3 "" H 9000 7500 50  0001 C CNN
	1    9000 7500
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0157
U 1 1 5FFCE6E5
P 9000 5450
F 0 "#PWR0157" H 9000 5300 50  0001 C CNN
F 1 "+5V" H 9015 5623 50  0000 C CNN
F 2 "" H 9000 5450 50  0001 C CNN
F 3 "" H 9000 5450 50  0001 C CNN
	1    9000 5450
	1    0    0    -1  
$EndComp
Wire Wire Line
	9000 5900 9000 5600
$Comp
L Device:C_Small C2
U 1 1 5FFCE6EC
P 9250 5600
F 0 "C2" H 9342 5646 50  0000 L CNN
F 1 "C_Small" H 9342 5555 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 9250 5600 50  0001 C CNN
F 3 "~" H 9250 5600 50  0001 C CNN
	1    9250 5600
	0    -1   -1   0   
$EndComp
Wire Wire Line
	9150 5600 9000 5600
Connection ~ 9000 5600
Wire Wire Line
	9000 5600 9000 5450
$Comp
L power:GND #PWR0158
U 1 1 5FFCE6F5
P 9350 5600
F 0 "#PWR0158" H 9350 5350 50  0001 C CNN
F 1 "GND" H 9355 5427 50  0000 C CNN
F 2 "" H 9350 5600 50  0001 C CNN
F 3 "" H 9350 5600 50  0001 C CNN
	1    9350 5600
	1    0    0    -1  
$EndComp
Wire Wire Line
	9500 6500 9650 6500
Wire Wire Line
	9650 5150 8250 5150
Wire Wire Line
	8250 5150 8250 6700
Wire Wire Line
	8250 6700 8500 6700
Wire Wire Line
	9650 5150 9650 6500
Wire Wire Line
	8500 6900 8500 6800
$Comp
L power:+5V #PWR0159
U 1 1 5FFE34F5
P 8250 6900
F 0 "#PWR0159" H 8250 6750 50  0001 C CNN
F 1 "+5V" H 8265 7073 50  0000 C CNN
F 2 "" H 8250 6900 50  0001 C CNN
F 3 "" H 8250 6900 50  0001 C CNN
	1    8250 6900
	1    0    0    -1  
$EndComp
Wire Wire Line
	8500 6900 8250 6900
Connection ~ 8500 6900
Text GLabel 9750 6200 2    50   Output ~ 0
CLK_12M
Wire Wire Line
	9750 6200 9500 6200
Text GLabel 9800 6400 2    50   Output ~ 0
CLK
Text GLabel 11000 6250 0    50   Input ~ 0
CLK
Text Label 7850 7000 0    50   ~ 0
CLK_24M
Wire Wire Line
	9500 6400 9800 6400
Wire Wire Line
	8500 5600 9000 5600
Wire Wire Line
	8500 6200 8500 5600
Wire Wire Line
	8500 6500 8400 6500
Wire Wire Line
	8500 6400 8300 6400
Text GLabel 7050 4400 2    50   BiDi ~ 0
EX2
Text GLabel 7050 4500 2    50   BiDi ~ 0
EX3
Text GLabel 9250 4450 2    50   BiDi ~ 0
EX2
Text GLabel 9250 4550 2    50   BiDi ~ 0
EX3
Text GLabel 5350 7250 2    50   BiDi ~ 0
EX2
Text GLabel 5350 7350 2    50   BiDi ~ 0
EX3
Text GLabel 3250 7150 2    50   BiDi ~ 0
EX2
Text GLabel 3250 7250 2    50   BiDi ~ 0
EX3
Text GLabel 6300 5900 0    50   Input ~ 0
~SLOW0~
Text GLabel 6300 6000 0    50   Input ~ 0
~SLOW1~
Text GLabel 6300 6100 0    50   Input ~ 0
~SLOW2~
Text GLabel 6300 6400 0    50   Input ~ 0
~SLOW3~
Text GLabel 6300 6500 0    50   Input ~ 0
~SLOW4~
Text GLabel 6300 6600 0    50   Input ~ 0
~SLOW5~
Wire Wire Line
	8300 5350 8300 6400
$Comp
L power:+5V #PWR0160
U 1 1 5FFEA08F
P 11250 2950
F 0 "#PWR0160" H 11250 2800 50  0001 C CNN
F 1 "+5V" H 11265 3123 50  0000 C CNN
F 2 "" H 11250 2950 50  0001 C CNN
F 3 "" H 11250 2950 50  0001 C CNN
	1    11250 2950
	1    0    0    -1  
$EndComp
Wire Wire Line
	11250 3400 11250 3100
$Comp
L Device:C_Small C5
U 1 1 5FFEA096
P 11500 3100
F 0 "C5" H 11592 3146 50  0000 L CNN
F 1 "C_Small" H 11592 3055 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 11500 3100 50  0001 C CNN
F 3 "~" H 11500 3100 50  0001 C CNN
	1    11500 3100
	0    -1   -1   0   
$EndComp
Wire Wire Line
	11400 3100 11250 3100
Connection ~ 11250 3100
Wire Wire Line
	11250 3100 11250 2950
$Comp
L power:GND #PWR0161
U 1 1 5FFEA09F
P 11600 3100
F 0 "#PWR0161" H 11600 2850 50  0001 C CNN
F 1 "GND" H 11605 2927 50  0000 C CNN
F 2 "" H 11600 3100 50  0001 C CNN
F 3 "" H 11600 3100 50  0001 C CNN
	1    11600 3100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0162
U 1 1 5FFF04AD
P 11250 4400
F 0 "#PWR0162" H 11250 4150 50  0001 C CNN
F 1 "GND" H 11255 4227 50  0000 C CNN
F 2 "" H 11250 4400 50  0001 C CNN
F 3 "" H 11250 4400 50  0001 C CNN
	1    11250 4400
	1    0    0    -1  
$EndComp
Wire Wire Line
	8400 6500 8400 6200
Wire Wire Line
	8400 6200 8500 6200
Connection ~ 8500 6200
Wire Wire Line
	8500 6300 8500 6400
Connection ~ 8500 6400
$Comp
L 74xx:74LS11 U5
U 1 1 6002FB92
P 6600 6000
F 0 "U5" H 6600 6325 50  0000 C CNN
F 1 "74AC11" H 6600 6234 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 6600 6000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS11" H 6600 6000 50  0001 C CNN
	1    6600 6000
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS11 U5
U 2 1 600332A1
P 6600 6500
F 0 "U5" H 6600 6825 50  0000 C CNN
F 1 "74AC11" H 6600 6734 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 6600 6500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS11" H 6600 6500 50  0001 C CNN
	2    6600 6500
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS11 U5
U 3 1 60036171
P 7300 5350
F 0 "U5" H 7300 5675 50  0000 C CNN
F 1 "74AC11" H 7300 5584 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 7300 5350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS11" H 7300 5350 50  0001 C CNN
	3    7300 5350
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS11 U5
U 4 1 60038B35
P 11250 3900
F 0 "U5" H 11480 3946 50  0000 L CNN
F 1 "74AC11" H 11480 3855 50  0000 L CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 11250 3900 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS11" H 11250 3900 50  0001 C CNN
	4    11250 3900
	1    0    0    -1  
$EndComp
Wire Wire Line
	6900 6500 6950 6500
Wire Wire Line
	7600 5350 8300 5350
Wire Wire Line
	6900 6000 6900 5450
Wire Wire Line
	6900 5450 7000 5450
Wire Wire Line
	6950 6500 6950 5350
Wire Wire Line
	6950 5250 7000 5250
Wire Wire Line
	7000 5350 6950 5350
Connection ~ 6950 5350
Wire Wire Line
	6950 5350 6950 5250
$EndSCHEMATC
