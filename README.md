# MSP432 Bootloader
Simple bootloader for the MSP432. The bootloader is able to program Intel hex files sent over UART. It has been tested on an MSP432 launchpad.
## Necessary Tools (on Linux)
* ARM GCC compiler (arm-none-eabi-gcc)
* Serial terminal program such as Gtk Term or Python 2.7

## Instructions
* Copy all files into a common directory
* Run `make` from said directory
* Set up your serial program using:
  * 19200 baud
  * No parity
  * One stop bit
  * Ensure each line is terminated with a CR-LF
* Flash the bootloader. For launchpads, this is easiest using Code Composer Studio. You will have to manually configure CCS to program Bootloader.out:
  * Right click on the project
  * Go to Debug As... -> Debug Configurations
  * Go to the Program tab and set the Program field to Bootloader.out
  * Debug the project to program the bootloader
* To flash a new hex file, simply pull down P1.1 on power up. On the launchpad, this is done by holding button 1. The bootloader will send a `>` over UART channel 1 (USB connector on launchpad) if all is well. After that, simply send the hex file using your serial program or run `python Program.py` (which you will have to configure to use your specific serial port) from the same directory as your hex file.
* To reprogram the bootloader, hold down P1.1 and P1.4 (both buttons on the launchpad) and send the hex file. This will also erase the application.

## Troubleshooting
If programming fails, the bootloader will send out a diagnostic character over UART and set P2.0 (Red part of RGB LED on Launchpad) high.
* `B` -- Buffer overflow. We can only hold 64 bytes of real data (2 address, 1 record type, 60 data, and 1 checksum).
* `C` -- Checksum error. Checksum sent with line being processed didn't match the calculated one.
* `F` -- Flash program error. Make sure you're not attempting to program the lower 4k of memory or any SRAM.

### Todos
* Add checks for valid app code

### See also
[MSP432 Reuse](https://github.com/swarlesbarkely/MSP432Reuse)
