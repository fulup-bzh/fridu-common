/*
 *      Copyright(c) 1996 Fridu a Free SOftware company
 *	Copyright(c) 1995 par IUT Vannes DUIA-TR
 *
 * File   	:   easyc.h  usefull macro definition
 * Projet	:   cTest
 * SubModule    :   initLib
 * Auteur       :   Thierry Nael (origine Byte)
 *
 * Last
 *      Modification: add STATIC define
 *      Author      : $Author: fulup $
 *      Date        : $Date: 1999/02/16 17:29:45 $
 *      Revision    : $Revision: 3.3 $
 *      Source      : $Source: /Master/Common/Config/Include/Unix/easyc.h,v $
 *      State       : $State: Exp $
 *
 * Modification History
 * ----------------------
 *
 *  01e,06jun98, fulup change #define to typedef
 *  01e,16may98, fulup make Tornado Compliant
 *  01d,30jun97, fulup removed TEXT for NT4.0
 *  01c,08apr97, fulup Add v_START macro for time stamping
 *  01b,29aug96, fulup made compatible to hexatek.h and to vxWorks.h
 *  01a,20jun95, writen from byte
 */


#ifndef __EASYC
#define __EASYC

/* Dummy routine that force include of v_stamp for each used library */
#define V_CHECK(LIB_STAMP) \
{ \
  extern char * LIB_STAMP; \
  if (LIB_STAMP != NULL) LIB_STAMP = NULL; \
}

#ifdef EASYC_PROTO_ONLY
 #define EASYC_PROTO
#else
 #define EASYC_OPT
 #define EASYC_TYPE
 #define EASYC_BOOL
 #define EASYC_STATUS
 #define EASYC_PROTO
#endif

#ifdef EASYC_BOOL
 /* Operations logiques */
 #ifndef NULL
 #define NULL ((void*) 0)
 #endif
 #define FALSE   0
 #define TRUE	 1
#endif

#ifdef EASYC_STATUS
/* Type Status et status predefinis retournes par les fonctions */
 #define STATUS  int
#ifndef ERROR
 #define ERROR   -1
#endif
 #define OK       0
#endif

#ifdef EASYC_OPT
 #define AND   &&
 #define OT    ||
 #define MOD     %
 #define BAND	&
 #define BOR	|
 #define BXOR	^
 #define BNOT	~
 #define LSHF	<<
 #define RSHF	>>
#endif

#ifdef EASYC_TYPE
 /* Types predefinis */
 typedef   unsigned char  UINT8;
 typedef   unsigned short UINT16;   
 typedef   unsigned int   UINT32;

 typedef   char           SINT8;
 typedef   short          SINT16;
 typedef   int            SINT32;

 typedef   char           CHAR;
 typedef   unsigned long  BOOL;
 typedef   short          SHORT;
 typedef   long           LONG;
#endif


#ifdef EASYC_PROTO
/* conflic with readline and keymap.h */
 #ifndef __FUNCTION_DEF  
/* define some usefull generic type */
  typedef long Function (void*, ...);
 #endif

 #define LOCAL     static  /* define internal function */
 #define STATIC    static  /* define internal function */
 #define PUBLIC            /* define external user function */
 #define RESTRICTED        /* define external but non user function */

 #define EXPORT            /* define Public Variable */
 #define IMPORT    extern  /* define external variable */
#endif

#ifdef EASYC_DOC
 /* needed for sources designed under GSV from Hexale technologies */
 #define _OBJECT(E)
 #define _REMARKS(E)
 #define _INPUT(E)
 #define _OUTPUT(E)
 #define _RETURN(E)
 #define _PROJECT(E)
 #define _RELEASE(E)
 #define _DATE(E)
 #define _FIRM(E)
 #define _SUB_SYSTEM(E)
 #define _REMARKS(E)
 #define _AUTHOR(E)
 #define _EXAMPLE(E)
 #define _DOC1(E)
 #define _DOC2(E)
 #define _DOC3(E)
 #define _FILE(E)
#endif

#endif /* ifndef EASYC */
