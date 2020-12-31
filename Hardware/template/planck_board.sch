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
P 2150 3550
F 0 "J1" H 2200 4967 50  0000 C CNN
F 1 "Conn_01x40" H 2200 4876 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x25_P2.54mm_Horizontal" H 2150 3550 50  0001 C CNN
F 3 "~" H 2150 3550 50  0001 C CNN
	1    2150 3550
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0101
U 1 1 5FD64472
P 2650 3450
F 0 "#PWR0101" H 2650 3300 50  0001 C CNN
F 1 "+5V" H 2665 3623 50  0000 C CNN
F 2 "" H 2650 3450 50  0001 C CNN
F 3 "" H 2650 3450 50  0001 C CNN
	1    2650 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	2650 3450 2450 3450
$Comp
L power:+5V #PWR0102
U 1 1 5FD65A34
P 1650 3550
F 0 "#PWR0102" H 1650 3400 50  0001 C CNN
F 1 "+5V" H 1665 3723 50  0000 C CNN
F 2 "" H 1650 3550 50  0001 C CNN
F 3 "" H 1650 3550 50  0001 C CNN
	1    1650 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	1950 3550 1700 3550
$Comp
L power:GND #PWR0103
U 1 1 5FD65E00
P 2650 3550
F 0 "#PWR0103" H 2650 3300 50  0001 C CNN
F 1 "GND" H 2655 3377 50  0000 C CNN
F 2 "" H 2650 3550 50  0001 C CNN
F 3 "" H 2650 3550 50  0001 C CNN
	1    2650 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	2650 3550 2450 3550
$Comp
L power:GND #PWR0104
U 1 1 5FD66D1A
P 1500 3400
F 0 "#PWR0104" H 1500 3150 50  0001 C CNN
F 1 "GND" H 1505 3227 50  0000 C CNN
F 2 "" H 1500 3400 50  0001 C CNN
F 3 "" H 1500 3400 50  0001 C CNN
	1    1500 3400
	1    0    0    -1  
$EndComp
Wire Wire Line
	1750 3450 1750 3400
Wire Wire Line
	1750 3400 1500 3400
Wire Wire Line
	1750 3450 1950 3450
Text GLabel 1950 2350 0    50   Input ~ 0
A0
Text GLabel 1950 2450 0    50   Input ~ 0
A1
Text GLabel 1950 2550 0    50   Input ~ 0
A2
Text GLabel 1950 2650 0    50   Input ~ 0
A3
Text GLabel 1950 2750 0    50   Input ~ 0
A4
Text GLabel 1950 2850 0    50   Input ~ 0
A5
Text GLabel 1950 2950 0    50   Input ~ 0
A6
Text GLabel 1950 3050 0    50   Input ~ 0
A7
Text GLabel 1950 3150 0    50   Input ~ 0
A8
Text GLabel 1950 3250 0    50   Input ~ 0
A9
Text GLabel 1950 3350 0    50   Input ~ 0
A10
Text GLabel 1950 3650 0    50   Input ~ 0
A11
Text GLabel 1950 3750 0    50   Input ~ 0
A12
Text GLabel 1950 3850 0    50   Input ~ 0
A13
Text GLabel 1950 3950 0    50   Input ~ 0
A14
Text GLabel 1950 4050 0    50   Input ~ 0
A15
Text GLabel 2450 2350 2    50   BiDi ~ 0
D0
Text GLabel 2450 2450 2    50   BiDi ~ 0
D1
Text GLabel 2450 2550 2    50   BiDi ~ 0
D2
Text GLabel 2450 2650 2    50   BiDi ~ 0
D3
Text GLabel 2450 2750 2    50   BiDi ~ 0
D4
Text GLabel 2450 2850 2    50   BiDi ~ 0
D5
Text GLabel 2450 2950 2    50   BiDi ~ 0
D6
Text GLabel 2450 3050 2    50   BiDi ~ 0
D7
Text GLabel 1950 4750 0    50   Input ~ 0
~RESET~
Text GLabel 2450 4750 2    50   BiDi ~ 0
~NMI~
Text GLabel 1400 4150 0    50   Input ~ 0
RDY
Text GLabel 1400 4250 0    50   Input ~ 0
BE
Text GLabel 1950 4350 0    50   Input ~ 0
CLK
Text GLabel 1950 4450 0    50   Input ~ 0
R~W~
Text GLabel 1950 4650 0    50   Input ~ 0
SYNC
Text GLabel 1400 4550 0    50   BiDi ~ 0
~IRQ~
Text GLabel 2450 4650 2    50   BiDi ~ 0
~SLOT_IRQ~
Text GLabel 2450 4550 2    50   BiDi ~ 0
EX5
Text GLabel 2450 4450 2    50   BiDi ~ 0
EX4
Text GLabel 2450 4350 2    50   BiDi ~ 0
EX3
$Comp
L Device:C_Small C2
U 1 1 5FD8A65F
P 2800 3500
F 0 "C2" H 2892 3546 50  0000 L CNN
F 1 "C_Small" H 2892 3455 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 2800 3500 50  0001 C CNN
F 3 "~" H 2800 3500 50  0001 C CNN
	1    2800 3500
	1    0    0    -1  
$EndComp
Wire Wire Line
	2800 3400 2750 3400
Wire Wire Line
	2750 3400 2750 3450
Wire Wire Line
	2750 3450 2650 3450
Connection ~ 2650 3450
Wire Wire Line
	2800 3600 2750 3600
Wire Wire Line
	2750 3600 2750 3550
Wire Wire Line
	2750 3550 2650 3550
Connection ~ 2650 3550
$Comp
L Device:C_Small C1
U 1 1 5FD8C99F
P 1300 3500
F 0 "C1" H 1392 3546 50  0000 L CNN
F 1 "C_Small" H 1392 3455 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric_Pad1.42x1.75mm_HandSolder" H 1300 3500 50  0001 C CNN
F 3 "~" H 1300 3500 50  0001 C CNN
	1    1300 3500
	1    0    0    -1  
$EndComp
Wire Wire Line
	1300 3400 1500 3400
Connection ~ 1500 3400
Wire Wire Line
	1300 3600 1700 3600
Wire Wire Line
	1700 3600 1700 3550
Connection ~ 1700 3550
Wire Wire Line
	1700 3550 1650 3550
Wire Wire Line
	1400 4550 1950 4550
Wire Wire Line
	1400 4150 1950 4150
Wire Wire Line
	1400 4250 1950 4250
Text GLabel 2450 3650 2    50   BiDi ~ 0
~SSEL~
Text GLabel 2450 3750 2    50   BiDi ~ 0
~INH~
Text GLabel 2450 3850 2    50   BiDi ~ 0
~SLOT_SEL~
Text GLabel 2450 3950 2    50   BiDi ~ 0
LED1
Text GLabel 2450 4050 2    50   BiDi ~ 0
LED2
Text GLabel 2450 4150 2    50   BiDi ~ 0
LED3
Text GLabel 2450 4250 2    50   BiDi ~ 0
LED4
Text GLabel 2450 3150 2    50   BiDi ~ 0
EX0
Text GLabel 2450 3250 2    50   BiDi ~ 0
EX1
Text GLabel 2450 3350 2    50   BiDi ~ 0
EX2
$EndSCHEMATC
