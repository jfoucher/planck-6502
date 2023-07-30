
import board
import pwmio
import time
led = pwmio.PWMOut(board.GP0, frequency=500000, duty_cycle=32767)

while True:
    led.duty_cycle = int(65535 / 2)  # Up
    time.sleep(0.1)