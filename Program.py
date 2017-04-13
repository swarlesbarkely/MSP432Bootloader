import serial
import os
import time
import sys

# 9600 baud, no parity, 1 stop bit, 5 sec timeout
try:
    print "Opening serial port at /dev/ttyACM0..."
    Serial = serial.Serial ('/dev/ttyACM0', 19200, timeout = 5)

except:
    print "Could not open serial port!"
    sys.exit()

# Find the hex file
for each in os.listdir ("./") :
    if each.endswith (".hex") :
        try:
            print "Opening " + each + "..."
            File = open (each, 'r')
            break

        except:
            print "Cannot open file!"
            sys.exit()
else :
    print "No hex file found!"
    sys.exit()

# Count number of lines
TotalLines = sum (1 for each in File)

File.seek (0)
LinesSent = 0
Line = []

print "Making sure controller is in programming mode..."
if Serial.read () != '>' :
    print "Controller not in programming mode!"
    sys.exit()

print "Sending file..."

while Line != '' :
    Line = File.readline ()
    Serial.write (bytes (Line))
    LinesSent += 1

    # Handle response
    Rx = Serial.read ()

    if Rx == ':' :
        PercentComplete = 100 * LinesSent / TotalLines
        print '\r' + str (PercentComplete) + "% Complete",

    elif LinesSent == TotalLines :
        print "\rPrograming complete!"
        sys.exit()

    elif Rx == 'B' :
        print "\nBuffer overflow!"
        sys.exit()

    elif Rx == 'C' :
        print "\nChecksum error!"
        sys.exit()

    elif Rx == 'F' :
        print "\nFlash error!"
        sys.exit()

    else :
        print "\nSerial error!"
        print Rx
        sys.exit()
