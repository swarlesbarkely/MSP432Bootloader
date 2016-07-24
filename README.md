# MSP432 Bootloader
Simple bootloader for the MSP432. The bootloader is able to program Intel hex files sent over UART. It has been tested on an MSP432 launchpad.
## Necessary Tools (on Linux)
* ARM GCC compiler (arm-none-eabi-gcc)
* Serial terminal program such as Gtk Term or Python 2.7

## Instructions
* Copy all files into a common directory
* Run `make` from said directory
* Set up your serial program using:
  * 9600 baud
  * No parity
  * One stop bit
  * Ensure each line is terminated with a CR-LF
* Flash the bootloader. For launchpads, this is easiest using Code Composer Studio. You will have to manually configure CCS to program Bootloader.out (more to come on this).
* To flash a new hex file, simply pull down P1.1 on power up. On the launchpad, this is done by holding button 1. The bootloader will send a `>` over UART channel 1 (USB connector on launchpad) if all is well. After that, simply send the hex file using your serial program or run `python Program.py` (which you will have to configure to use your specific serial port) from the same directory as your hex file.
* DO NOT hold down button 2 (P1.4) -- this will (hopefully) erase the bootloader and is totally untested

## Troubleshooting
If programming fails, the bootloader will send out a diagnostic character over UART and set P2.0 (Red part of RGB LED on Launchpad) high.
* `B` -- Buffer overflow. UART Rx buffer is 77 bytes wide. If we hit 77 and it's not LF (0x0A), we go to the error state.
* `C` -- Checksum error. Checksum sent with line being processed didn't match the calculated one. If you get this consistently, add a transmission delay (~80 ms) at the end of each line.
* `F` -- Flash program error. Make sure you're not attempting to program the lower 4k of memory or any SRAM.

### Todos
* Add checks for valid app code
* Test reprogramming of bootloader
