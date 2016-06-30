/**************************************************************************
* Description:	Collection of useful macros
*
* Author:		Zack Day
*
* Changelog:	10/21/2015 Zack Day | Initial revision
*
**************************************************************************/
#ifndef _COMMONMACROS_H_
#define _COMMONMACROS_H_

#define WaitForInterrupt()		asm("		wfi")
#define DisableInterrupts()		asm("		cpsid i")
#define EnableInterrupts()		asm("		cpsie i")

#define LENGTH(x)		(sizeof(x)/sizeof(x[0]))

#define BIT(x)	(1 << (x))
#define PIN(x)  (1 << (x))

#define ABS(x)		((x) < 0 ? -(x) : (x))
#define MAX(x,y)	((x) < (y) ? (y): (x))
#define MIN(x,y)	((x) > (y) ? (y): (x))

#define TOGGLE_BOOL(x) ((x) ^= 1)

#define LOBYTE(Word) ((Word) & 0xFF)
#define HIBYTE(Word) (((Word) >> 8) & 0xFF)

#define MAKEWORD(LoByte, HiByte) ((LoByte) | ((HiByte) << 8))

#define IS_ODD(x)   ((x) & BIT(0))

#endif
