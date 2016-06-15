# MSP432Bootloader
Simple bootloader for the MSP432. The bootloader is able to program Intel hex files sent over UART. It has been tested on an MSP432 launchpad.
## Necessary Tools (on Linux)
* ARM GCC compiler (arm-none-eabi-gcc)
* Serial terminal program such as Gtk Term

## Instructions
* Copy all files into a common directory
* Run `make` from said directory
* Set up your serial program using:
  * 9600 baud
  * No parity
  * One stop bit
  * Ensure each line is terminated with a CR-LF
* Flash the bootloader. For launchpads, this is easiest using Code Composer Studio. You will have to manually configure CCS to program Bootloader.out (more to come on this).
* To flash a new hex file, simply pull down P1.1 on power up. On the launchpad, this is done by holding button 1. The bootloader will send a `>` if all is well. After that, simply send the hex file using your serial program.
* DO NOT hold down button 2 (P1.4) -- this will (hopefully) erase the bootloader and is totally untested

### Todos
* Add checks for valid app code
* Test reprogramming of bootloader
