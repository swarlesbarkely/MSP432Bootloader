/**************************************************************************
* Description:	Collection of useful typedefs
*
* Author:		Zack Day
*
* Changelog:	08/13/2015 Zack Day | Initial revision
* 				11/18/2015 Zack Day | Use stdint
**************************************************************************/


#ifndef TYPES_H_
#define TYPES_H_

#include <stdint.h>

// Because I don't like typing _t...
typedef uint8_t		uint8;
typedef uint16_t	uint16;
typedef uint32_t	uint32;
typedef uint64_t	uint64;

typedef int8_t		int8;
typedef int16_t		int16;
typedef int32_t		int32;
typedef int64_t		int64;

typedef uint32		BOOL;

typedef char const * const	STRING_CONSTANT;

#define FALSE   ((BOOL)0)
#define TRUE    ((BOOL)1)

#define HIGH (TRUE)
#define LOW	 (FALSE)

#define NULL 0

#endif /* TYPES_H_ */
