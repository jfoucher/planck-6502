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
P 3050 3450
F 0 "#PWR0101" H 3050 3300 50  0001 C CNN
F 1 "+5V" H 3065 3623 50  0000 C CNN
F 2 "" H 3050 3450 50  0001 C CNN
F 3 "" H 3050 3450 50  0001 C CNN
	1    3050 3450
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0102
U 1 1 5FD65A34
P 850 3600
F 0 "#PWR0102" H 850 3450 50  0001 C CNN
F 1 "+5V" H 865 3773 50  0000 C CNN
F 2 "" H 850 3600 50  0001 C CNN
F 3 "" H 850 3600 50  0001 C CNN
	1    850  3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	1950 3550 1700 3550
$Comp
L power:GND #PWR0103
U 1 1 5FD65E00
P 3050 3550
F 0 "#PWR0103" H 3050 3300 50  0001 C CNN
F 1 "GND" H 3055 3377 50  0000 C CNN
F 2 "" H 3050 3550 50  0001 C CNN
F 3 "" H 3050 3550 50  0001 C CNN
	1    3050 3550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0104
U 1 1 5FD66D1A
P 1100 3300
F 0 "#PWR0104" H 1100 3050 50  0001 C CNN
F 1 "GND" H 1105 3127 50  0000 C CNN
F 2 "" H 1100 3300 50  0001 C CNN
F 3 "" H 1100 3300 50  0001 C CNN
	1    1100 3300
	1    0    0    -1  
$EndComp
Wire Wire Line
	1750 3450 1750 3400
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
Text GLabel 1900 4800 0    50   Input ~ 0
~RESET~
Text GLabel 2450 4750 2    50   BiDi ~ 0
~NMI~
Text GLabel 1950 4150 0    50   Input ~ 0
RDY
Text GLabel 1950 4250 0    50   Input ~ 0
BE
Text GLabel 1950 4350 0    50   Input ~ 0
CLK
Text GLabel 1700 4400 0    50   Input ~ 0
R~W~
Text GLabel 1950 4650 0    50   Input ~ 0
SYNC
Text GLabel 1700 4550 0    50   BiDi ~ 0
~IRQ~
Text GLabel 2650 4650 2    50   BiDi ~ 0
~SLOT_IRQ~
Text GLabel 2450 4550 2    50   BiDi ~ 0
EX3
Text GLabel 2450 4450 2    50   BiDi ~ 0
EX2
Text GLabel 2450 4350 2    50   BiDi ~ 0
CLK_12M
Wire Wire Line
	1700 3600 1700 3550
Wire Wire Line
	1700 4550 1950 4550
Text GLabel 2450 3650 2    50   BiDi ~ 0
~SSEL~
Text GLabel 2750 3700 2    50   BiDi ~ 0
~INH~
Text GLabel 2700 3850 2    50   Output ~ 0
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
~SLOW~
Wire Wire Line
	2450 3450 3050 3450
Wire Wire Line
	2450 3550 3050 3550
Wire Wire Line
	2750 3700 2700 3700
Wire Wire Line
	2700 3700 2700 3750
Wire Wire Line
	2700 3750 2450 3750
Wire Wire Line
	2650 4650 2450 4650
Wire Wire Line
	1900 4800 1950 4800
Wire Wire Line
	1950 4800 1950 4750
Wire Wire Line
	1700 4400 1750 4400
Wire Wire Line
	1750 4400 1750 4450
Wire Wire Line
	1750 4450 1950 4450
Wire Wire Line
	2700 3850 2450 3850
Wire Wire Line
	1300 3400 1750 3400
Wire Wire Line
	1300 3400 1300 3300
Wire Wire Line
	1300 3300 1100 3300
Wire Wire Line
	850  3600 1700 3600
Text GLabel 4750 2450 0    50   BiDi ~ 0
D0
Text GLabel 4750 2550 0    50   BiDi ~ 0
D1
Text GLabel 4750 2650 0    50   BiDi ~ 0
D2
Text GLabel 4750 2750 0    50   BiDi ~ 0
D3
Text GLabel 4750 2850 0    50   BiDi ~ 0
D4
Text GLabel 4750 2950 0    50   BiDi ~ 0
D5
Text GLabel 4750 3050 0    50   BiDi ~ 0
D6
Text GLabel 4750 3150 0    50   BiDi ~ 0
D7
Text GLabel 4750 3350 0    50   Input ~ 0
A0
Text GLabel 3650 3600 0    50   Input ~ 0
R~W~
Text GLabel 4750 3700 0    50   Input ~ 0
R~W~
Wire Wire Line
	4750 3600 4350 3600
$Comp
L power:+5V #PWR0105
U 1 1 60352462
P 9750 900
F 0 "#PWR0105" H 9750 750 50  0001 C CNN
F 1 "+5V" H 9765 1073 50  0000 C CNN
F 2 "" H 9750 900 50  0001 C CNN
F 3 "" H 9750 900 50  0001 C CNN
	1    9750 900 
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C7
U 1 1 60353CA7
P 10100 1000
F 0 "C7" V 9871 1000 50  0000 C CNN
F 1 "10n" V 9962 1000 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D4.3mm_W1.9mm_P5.00mm" H 10100 1000 50  0001 C CNN
F 3 "~" H 10100 1000 50  0001 C CNN
	1    10100 1000
	0    1    1    0   
$EndComp
Wire Wire Line
	9750 1150 9750 1000
Wire Wire Line
	10000 1000 9750 1000
Connection ~ 9750 1000
Wire Wire Line
	9750 1000 9750 900 
$Comp
L power:GND #PWR0106
U 1 1 60355C28
P 10200 1000
F 0 "#PWR0106" H 10200 750 50  0001 C CNN
F 1 "GND" H 10205 827 50  0000 C CNN
F 2 "" H 10200 1000 50  0001 C CNN
F 3 "" H 10200 1000 50  0001 C CNN
	1    10200 1000
	1    0    0    -1  
$EndComp
Text GLabel 5650 4100 2    50   Output ~ 0
~SLOT_IRQ~
$Comp
L power:+5V #PWR0107
U 1 1 6035BE49
P 5250 1600
F 0 "#PWR0107" H 5250 1450 50  0001 C CNN
F 1 "+5V" H 5265 1773 50  0000 C CNN
F 2 "" H 5250 1600 50  0001 C CNN
F 3 "" H 5250 1600 50  0001 C CNN
	1    5250 1600
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C2
U 1 1 6035BE4F
P 5600 1700
F 0 "C2" V 5371 1700 50  0000 C CNN
F 1 "10n" V 5462 1700 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D4.3mm_W1.9mm_P5.00mm" H 5600 1700 50  0001 C CNN
F 3 "~" H 5600 1700 50  0001 C CNN
	1    5600 1700
	0    1    1    0   
$EndComp
Wire Wire Line
	5500 1700 5250 1700
Connection ~ 5250 1700
Wire Wire Line
	5250 1700 5250 1600
$Comp
L power:GND #PWR0108
U 1 1 6035BE59
P 5700 1700
F 0 "#PWR0108" H 5700 1450 50  0001 C CNN
F 1 "GND" H 5705 1527 50  0000 C CNN
F 2 "" H 5700 1700 50  0001 C CNN
F 3 "" H 5700 1700 50  0001 C CNN
	1    5700 1700
	1    0    0    -1  
$EndComp
Wire Wire Line
	5250 1700 5250 2350
$Comp
L power:GND #PWR0109
U 1 1 6035E8B0
P 5250 4300
F 0 "#PWR0109" H 5250 4050 50  0001 C CNN
F 1 "GND" H 5255 4127 50  0000 C CNN
F 2 "" H 5250 4300 50  0001 C CNN
F 3 "" H 5250 4300 50  0001 C CNN
	1    5250 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	5250 4300 5250 4150
Wire Wire Line
	6100 2450 5650 2450
Wire Wire Line
	6100 2550 5650 2550
Wire Wire Line
	6100 2650 5650 2650
Wire Wire Line
	7750 2150 7350 2150
Wire Wire Line
	7350 2150 7350 2450
Wire Wire Line
	7350 2450 7100 2450
Wire Wire Line
	7750 2350 7750 2600
Wire Wire Line
	7750 2600 8350 2600
Wire Wire Line
	8350 2600 8350 2250
$Comp
L power:GND #PWR0110
U 1 1 603BB63F
P 8800 1650
F 0 "#PWR0110" H 8800 1400 50  0001 C CNN
F 1 "GND" H 8805 1477 50  0000 C CNN
F 2 "" H 8800 1650 50  0001 C CNN
F 3 "" H 8800 1650 50  0001 C CNN
	1    8800 1650
	1    0    0    -1  
$EndComp
Wire Wire Line
	7800 3000 7800 3200
Wire Wire Line
	7800 3200 8400 3200
Wire Wire Line
	8400 3200 8400 2900
Wire Wire Line
	7100 2800 7200 2800
Wire Wire Line
	7450 2800 7450 3000
Wire Wire Line
	7450 3000 7800 3000
Wire Wire Line
	7100 2700 7250 2700
Wire Wire Line
	7550 2700 7550 2800
Wire Wire Line
	7550 2800 7800 2800
$Comp
L power:GNDA #PWR0111
U 1 1 603BB655
P 7800 3300
F 0 "#PWR0111" H 7800 3050 50  0001 C CNN
F 1 "GNDA" H 7805 3127 50  0000 C CNN
F 2 "" H 7800 3300 50  0001 C CNN
F 3 "" H 7800 3300 50  0001 C CNN
	1    7800 3300
	1    0    0    -1  
$EndComp
Wire Wire Line
	7500 3550 7650 3550
Wire Wire Line
	8450 3550 8450 2250
Wire Wire Line
	8450 2250 8350 2250
Wire Wire Line
	7500 3650 7650 3650
Wire Wire Line
	7650 3650 7650 3550
Connection ~ 7650 3550
Wire Wire Line
	7650 3550 8450 3550
$Comp
L Connector:AudioJack3 J2
U 1 1 603BB663
P 7300 3550
F 0 "J2" H 7282 3875 50  0000 C CNN
F 1 "AudioJack3" H 7282 3784 50  0000 C CNN
F 2 "Connector_Audio:Jack_3.5mm_CUI_SJ1-3533NG_Horizontal" H 7300 3550 50  0001 C CNN
F 3 "~" H 7300 3550 50  0001 C CNN
	1    7300 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	7500 3450 7500 3300
$Comp
L Device:C C5
U 1 1 603BB66B
P 7200 2950
F 0 "C5" H 7315 2996 50  0000 L CNN
F 1 "10uF" H 7315 2905 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D4.3mm_W1.9mm_P5.00mm" H 7238 2800 50  0001 C CNN
F 3 "~" H 7200 2950 50  0001 C CNN
	1    7200 2950
	1    0    0    -1  
$EndComp
Connection ~ 7200 2800
Wire Wire Line
	7200 2800 7450 2800
$Comp
L Device:C C4
U 1 1 603BB677
P 6900 3100
F 0 "C4" H 7015 3146 50  0000 L CNN
F 1 "10uF" H 7015 3055 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D4.3mm_W1.9mm_P5.00mm" H 6938 2950 50  0001 C CNN
F 3 "~" H 6900 3100 50  0001 C CNN
	1    6900 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	6900 2950 6900 2600
Wire Wire Line
	6900 2600 7250 2600
Wire Wire Line
	7250 2600 7250 2700
Connection ~ 7250 2700
Wire Wire Line
	7250 2700 7550 2700
$Comp
L power:GND #PWR0112
U 1 1 603C0634
P 6550 2900
F 0 "#PWR0112" H 6550 2650 50  0001 C CNN
F 1 "GND" H 6555 2727 50  0000 C CNN
F 2 "" H 6550 2900 50  0001 C CNN
F 3 "" H 6550 2900 50  0001 C CNN
	1    6550 2900
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0113
U 1 1 603C2877
P 6550 1600
F 0 "#PWR0113" H 6550 1450 50  0001 C CNN
F 1 "+5V" H 6565 1773 50  0000 C CNN
F 2 "" H 6550 1600 50  0001 C CNN
F 3 "" H 6550 1600 50  0001 C CNN
	1    6550 1600
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C3
U 1 1 603C287D
P 6900 1700
F 0 "C3" V 6671 1700 50  0000 C CNN
F 1 "10n" V 6762 1700 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D4.3mm_W1.9mm_P5.00mm" H 6900 1700 50  0001 C CNN
F 3 "~" H 6900 1700 50  0001 C CNN
	1    6900 1700
	0    1    1    0   
$EndComp
Wire Wire Line
	6800 1700 6550 1700
Connection ~ 6550 1700
Wire Wire Line
	6550 1700 6550 1600
$Comp
L power:GND #PWR0114
U 1 1 603C2886
P 7000 1700
F 0 "#PWR0114" H 7000 1450 50  0001 C CNN
F 1 "GND" H 7005 1527 50  0000 C CNN
F 2 "" H 7000 1700 50  0001 C CNN
F 3 "" H 7000 1700 50  0001 C CNN
	1    7000 1700
	1    0    0    -1  
$EndComp
Wire Wire Line
	6550 1700 6550 2350
$Comp
L Oscillator:CXO_DIP8 X1
U 1 1 603D8611
P 3950 5050
F 0 "X1" H 4294 5096 50  0000 L CNN
F 1 "3.579545 MHz" H 4294 5005 50  0000 L CNN
F 2 "Oscillator:Oscillator_DIP-8" H 4400 4700 50  0001 C CNN
F 3 "http://cdn-reichelt.de/documents/datenblatt/B400/OSZI.pdf" H 3850 5050 50  0001 C CNN
	1    3950 5050
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0115
U 1 1 603DCC1E
P 3950 4500
F 0 "#PWR0115" H 3950 4350 50  0001 C CNN
F 1 "+5V" H 3965 4673 50  0000 C CNN
F 2 "" H 3950 4500 50  0001 C CNN
F 3 "" H 3950 4500 50  0001 C CNN
	1    3950 4500
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C1
U 1 1 603DCC24
P 4300 4600
F 0 "C1" V 4071 4600 50  0000 C CNN
F 1 "10n" V 4162 4600 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D4.3mm_W1.9mm_P5.00mm" H 4300 4600 50  0001 C CNN
F 3 "~" H 4300 4600 50  0001 C CNN
	1    4300 4600
	0    1    1    0   
$EndComp
Wire Wire Line
	3950 4750 3950 4600
Wire Wire Line
	4200 4600 3950 4600
Connection ~ 3950 4600
Wire Wire Line
	3950 4600 3950 4500
$Comp
L power:GND #PWR0116
U 1 1 603DCC2E
P 4400 4600
F 0 "#PWR0116" H 4400 4350 50  0001 C CNN
F 1 "GND" H 4405 4427 50  0000 C CNN
F 2 "" H 4400 4600 50  0001 C CNN
F 3 "" H 4400 4600 50  0001 C CNN
	1    4400 4600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0117
U 1 1 603E498E
P 3950 5350
F 0 "#PWR0117" H 3950 5100 50  0001 C CNN
F 1 "GND" H 3955 5177 50  0000 C CNN
F 2 "" H 3950 5350 50  0001 C CNN
F 3 "" H 3950 5350 50  0001 C CNN
	1    3950 5350
	1    0    0    -1  
$EndComp
Wire Wire Line
	4750 3900 4500 3900
Wire Wire Line
	4500 3900 4500 5050
Wire Wire Line
	4500 5050 4250 5050
Text GLabel 4350 4100 0    50   Input ~ 0
~RESET~
Wire Wire Line
	4750 4100 4350 4100
$Comp
L power:+5V #PWR0118
U 1 1 603F57CA
P 8800 800
F 0 "#PWR0118" H 8800 650 50  0001 C CNN
F 1 "+5V" H 8815 973 50  0000 C CNN
F 2 "" H 8800 800 50  0001 C CNN
F 3 "" H 8800 800 50  0001 C CNN
	1    8800 800 
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C6
U 1 1 603F57D0
P 9150 900
F 0 "C6" V 8921 900 50  0000 C CNN
F 1 "10n" V 9012 900 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D4.3mm_W1.9mm_P5.00mm" H 9150 900 50  0001 C CNN
F 3 "~" H 9150 900 50  0001 C CNN
	1    9150 900 
	0    1    1    0   
$EndComp
Wire Wire Line
	8800 1050 8800 900 
Wire Wire Line
	9050 900  8800 900 
Connection ~ 8800 900 
Wire Wire Line
	8800 900  8800 800 
$Comp
L power:GND #PWR0119
U 1 1 603F57DA
P 9250 900
F 0 "#PWR0119" H 9250 650 50  0001 C CNN
F 1 "GND" H 9255 727 50  0000 C CNN
F 2 "" H 9250 900 50  0001 C CNN
F 3 "" H 9250 900 50  0001 C CNN
	1    9250 900 
	1    0    0    -1  
$EndComp
Text GLabel 2750 6150 0    50   Input ~ 0
~SLOT_SEL~
Text GLabel 3550 6150 2    50   Output ~ 0
~SLOW~
$Comp
L 74xx:74HC00 U1
U 1 1 60450257
P 4050 3600
F 0 "U1" H 4050 3925 50  0000 C CNN
F 1 "74HC00" H 4050 3834 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 4050 3600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 4050 3600 50  0001 C CNN
	1    4050 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	3750 3700 3750 3600
Wire Wire Line
	3750 3600 3650 3600
Wire Wire Line
	3750 3500 3750 3600
Connection ~ 3750 3600
$Comp
L 74xx:74HC00 U1
U 2 1 604599A1
P 9700 2850
F 0 "U1" H 9700 3175 50  0000 C CNN
F 1 "74HC00" H 9700 3084 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 9700 2850 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 9700 2850 50  0001 C CNN
	2    9700 2850
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U1
U 3 1 6045A727
P 3900 2300
F 0 "U1" H 3900 2625 50  0000 C CNN
F 1 "74HC00" H 3900 2534 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 3900 2300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 3900 2300 50  0001 C CNN
	3    3900 2300
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U1
U 4 1 6045B64F
P 3300 2400
F 0 "U1" H 3300 2725 50  0000 C CNN
F 1 "74HC00" H 3300 2634 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 3300 2400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 3300 2400 50  0001 C CNN
	4    3300 2400
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U1
U 5 1 6045C719
P 9750 1650
F 0 "U1" H 9980 1696 50  0000 L CNN
F 1 "74HC00" H 9980 1605 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 9750 1650 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 9750 1650 50  0001 C CNN
	5    9750 1650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0121
U 1 1 60464888
P 9750 2150
F 0 "#PWR0121" H 9750 1900 50  0001 C CNN
F 1 "GND" H 9755 1977 50  0000 C CNN
F 2 "" H 9750 2150 50  0001 C CNN
F 3 "" H 9750 2150 50  0001 C CNN
	1    9750 2150
	1    0    0    -1  
$EndComp
Text GLabel 3600 2200 0    50   Input ~ 0
CLK
Text GLabel 2950 1950 0    50   Input ~ 0
~SLOT_SEL~
Wire Wire Line
	4750 3500 4300 3500
Wire Wire Line
	4300 3500 4300 2300
Wire Wire Line
	4300 2300 4200 2300
Wire Wire Line
	3000 1950 2950 1950
$Comp
L power:GND #PWR0122
U 1 1 6047F84D
P 9400 3050
F 0 "#PWR0122" H 9400 2800 50  0001 C CNN
F 1 "GND" H 9405 2877 50  0000 C CNN
F 2 "" H 9400 3050 50  0001 C CNN
F 3 "" H 9400 3050 50  0001 C CNN
	1    9400 3050
	1    0    0    -1  
$EndComp
Wire Wire Line
	9400 3050 9400 2950
Connection ~ 9400 2950
Wire Wire Line
	9400 2950 9400 2750
Wire Wire Line
	3000 1950 3000 2300
Wire Wire Line
	3000 2500 3000 2300
Connection ~ 3000 2300
$Comp
L Device:LED D2
U 1 1 6049AA52
P 3850 1250
F 0 "D2" H 3843 1467 50  0000 C CNN
F 1 "LED" H 3843 1376 50  0000 C CNN
F 2 "LED_THT:LED_D3.0mm_Horizontal_O3.81mm_Z6.0mm" H 3850 1250 50  0001 C CNN
F 3 "~" H 3850 1250 50  0001 C CNN
	1    3850 1250
	1    0    0    -1  
$EndComp
Text GLabel 3050 1250 0    50   Input ~ 0
~SLOT_SEL~
$Comp
L power:+5V #PWR0123
U 1 1 6049D7AB
P 4000 1250
F 0 "#PWR0123" H 4000 1100 50  0001 C CNN
F 1 "+5V" H 4015 1423 50  0000 C CNN
F 2 "" H 4000 1250 50  0001 C CNN
F 3 "" H 4000 1250 50  0001 C CNN
	1    4000 1250
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R2
U 1 1 604ABF00
P 3350 1250
F 0 "R2" H 3409 1296 50  0000 L CNN
F 1 "330R" H 3409 1205 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" H 3350 1250 50  0001 C CNN
F 3 "~" H 3350 1250 50  0001 C CNN
	1    3350 1250
	0    -1   -1   0   
$EndComp
Wire Wire Line
	3700 1250 3450 1250
$Comp
L Amplifier_Operational:LM358 U4
U 1 1 604C59E9
P 8050 2250
F 0 "U4" H 8050 2617 50  0000 C CNN
F 1 "LM358" H 8050 2526 50  0000 C CNN
F 2 "Package_DIP:DIP-8_W7.62mm_Socket" H 8050 2250 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/lm2904-n.pdf" H 8050 2250 50  0001 C CNN
	1    8050 2250
	1    0    0    -1  
$EndComp
Connection ~ 8350 2250
$Comp
L Amplifier_Operational:LM358 U4
U 2 1 604C7D50
P 8100 2900
F 0 "U4" H 8100 3267 50  0000 C CNN
F 1 "LM358" H 8100 3176 50  0000 C CNN
F 2 "Package_DIP:DIP-8_W7.62mm_Socket" H 8100 2900 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/lm2904-n.pdf" H 8100 2900 50  0001 C CNN
	2    8100 2900
	1    0    0    -1  
$EndComp
Connection ~ 7800 3000
$Comp
L Amplifier_Operational:LM358 U4
U 3 1 604C958C
P 8900 1350
F 0 "U4" H 8858 1396 50  0000 L CNN
F 1 "LM358" H 8858 1305 50  0000 L CNN
F 2 "Package_DIP:DIP-8_W7.62mm_Socket" H 8900 1350 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/lm2904-n.pdf" H 8900 1350 50  0001 C CNN
	3    8900 1350
	1    0    0    -1  
$EndComp
Wire Wire Line
	3550 6150 2750 6150
Text Notes 2400 6000 0    50   ~ 0
Diode + pullup provided by backplane
$Comp
L power:GND #PWR0120
U 1 1 612E6AF8
P 6950 4300
F 0 "#PWR0120" H 6950 4050 50  0001 C CNN
F 1 "GND" H 6955 4127 50  0000 C CNN
F 2 "" H 6950 4300 50  0001 C CNN
F 3 "" H 6950 4300 50  0001 C CNN
	1    6950 4300
	1    0    0    -1  
$EndComp
$Comp
L power:GNDA #PWR0124
U 1 1 612E9200
P 7350 4300
F 0 "#PWR0124" H 7350 4050 50  0001 C CNN
F 1 "GNDA" H 7355 4127 50  0000 C CNN
F 2 "" H 7350 4300 50  0001 C CNN
F 3 "" H 7350 4300 50  0001 C CNN
	1    7350 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	7500 3300 7800 3300
Wire Wire Line
	7200 3100 7200 3250
Wire Wire Line
	7200 3250 6900 3250
$Comp
L power:GND #PWR0125
U 1 1 612FD955
P 6900 3250
F 0 "#PWR0125" H 6900 3000 50  0001 C CNN
F 1 "GND" H 6905 3077 50  0000 C CNN
F 2 "" H 6900 3250 50  0001 C CNN
F 3 "" H 6900 3250 50  0001 C CNN
	1    6900 3250
	1    0    0    -1  
$EndComp
$Comp
L opl2_board-rescue:YM3014B-adlib U3
U 1 1 604D5363
P 6550 2550
F 0 "U3" H 6600 3069 60  0000 C CNN
F 1 "YM3014B" H 6600 2963 60  0000 C CNN
F 2 "Package_DIP:DIP-8_W7.62mm_Socket" H 6600 2857 60  0000 C CNN
F 3 "" H 6550 2550 60  0000 C CNN
	1    6550 2550
	1    0    0    -1  
$EndComp
$Comp
L opl2_board-rescue:YM3812-adlib U2
U 1 1 6033A272
P 5250 3150
F 0 "U2" H 5200 4163 60  0000 C CNN
F 1 "YM3812" H 5200 4057 60  0000 C CNN
F 2 "Package_DIP:DIP-24_W15.24mm_Socket" H 5250 3050 60  0000 C CNN
F 3 "" H 5250 3150 60  0000 C CNN
	1    5250 3150
	1    0    0    -1  
$EndComp
Wire Wire Line
	7350 4300 6950 4300
Wire Wire Line
	3050 1250 3250 1250
$EndSCHEMATC
