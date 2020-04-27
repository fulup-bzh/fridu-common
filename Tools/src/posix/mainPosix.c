 /* $Header: /Master/Common/Tools/src/posix/mainPosix.c,v 3.0.3.1 1998/05/30 11:25:53 fulup Exp $
 *
 *  Copyright(c) 1997 FRIDU a Free Software Company [fridu@fridu.com]
 *
 * File      :   mainDaPosix test getopt posix function
 * Projet    :   Posix getopt test
 * Module    :   Bench Posixhrone
 * Auteur    :   Fulup Ar Foll [fulup@fridu.com]
 *
 * Last
 *      Author      : $Author: fulup $
 *      Date        : $Date: 1998/05/30 11:25:53 $
 *      Revision    : $Revision: 3.0.3.1 $
 *      Source      : $Source: /Master/Common/Tools/src/posix/mainPosix.c,v $
 *      State       : $State: Exp $
 *
 * Modification History
 * --------------------
 * 01a,26jun97,fulup,written
 */


#include <getopt.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <sys/types.h> 
#include <easyc.h>

#define VERBOSE   1
#define VERSION   2
#define HELP      3
#define DEBUG     4
#define OUTFILE   5
#define BLKSIZE   6
#define FILESIZE  7
#define TIMESLICE 8
#define INFILE    9

// EXAMPLE:long_options starting option for GNU lib getopt
static struct option const long_options[] =
 {
  {"debug"    , (int)"DebugLevel" ,0, DEBUG},
  {"outFile"  , (int)"Output File Name [outFile= -]" ,0, OUTFILE},
  {"inFile"   , (int)"Input  File Name [inFile= ./asynBench]" ,0, INFILE},
  {"blkSize"  , (int)"I/O BlockSize [blkSize=4096B]" ,0, BLKSIZE},
  {"fileSize" , (int)"I/O File size [fileSize=100M]" ,0, FILESIZE},
  {"timeSlice", (int)"I/O Sleep time [timeSlice=100ms]" ,0, TIMESLICE},
  {"verbose"  , 0,0, VERBOSE},
  {"version"  , 0,0, VERSION},
  {"help"     , 0,0, HELP},
  {0, 0, 0, 0}
 };

EXPORT BOOL    verbose=FALSE;
EXPORT UINT32  debugLevel=0; 




#include <stdio.h>
#include <string.h>

// C can't switch on string this impose using TOKEN
#define TOKEN_B  ((UINT32)'b' <<8) BOR ((UINT32) ' ')
#define TOKEN_KB ((UINT32)'k' <<8) BOR ((UINT32)'b')
#define TOKEN_MB ((UINT32)'m' <<8) BOR ((UINT32)'b')

#define TOKEN_S  ((UINT32)'s' <<8) BOR ((UINT32) ' ')
#define TOKEN_MS ((UINT32)'m' <<8) BOR ((UINT32)'s')
#define TOKEN_US ((UINT32)'u' <<8) BOR ((UINT32)'s')

/*----------------------------------------------------------------------
 | utilsUnitGet: translate string in a valid interger depending on unit
 | if no unit found or if and invalid unit is given return 0
 +----------------------------------------------------------------------*/
LOCAL UINT32 utilsUnitGet (char *value)
{

  UINT32   size;
  UINT32   unit;
  UINT32   number;
  int      ind;

  if (debugLevel>9) fprintf (stderr, "utilsUnitGet |%s|=", value);
  // split value in interger and unit
  for (ind = 0; ((value[ind] >='0') AND (value[ind] <='9')); ind ++);

  // lowercase unit and tokenized unit
  unit =  (UINT32) (value [ind] BOR (UINT32) ('a' - 'A')) << 8;
  unit =  unit BOR ((UINT32)value [ind+1] BOR (UINT32) ('a' - 'A'));
  
  // remove unit from value
  value [ind] = '\0';
  sscanf (value, "%ld",&number);

  // switch on unitToken
  switch (unit) {

    case TOKEN_B: 
      size = number;
      break;

    case TOKEN_KB: 
      size = number * 1024;
      break;

    case TOKEN_MB: 
      size = number * 1024 * 1024;
      break;

    case TOKEN_US: 
      size = number;
      break;

    case TOKEN_MS: 
      size = number * 1000;
      break;

    case TOKEN_S: 
      size = number * 1000000;
      break;

    default: 
      fprintf (stderr, "Unknow |%s| Unit should be (B|KB|MB) (S|MS)\n",value);
      size = 0;

  } // end switch 

  if (debugLevel>9) fprintf (stderr, "%ld\n", size);
  return size;
} // end utilsUnitGet

/*----------------------------------------------------------
 | printVersion
 |   print all version module 
 +--------------------------------------------------------- */
 LOCAL void printVersion (void)
 {
 IMPORT char* vStampBin_posix;

   fprintf (stderr,"Symbolic Version %s\n", "$Name:  $");
   fprintf (stderr,"--------------------------------------\n");
   fprintf (stderr,"%s\n", vStampBin_posix);
 } // end printVersion

void printHelp(char *name)
{
  int ind;
  
  fprintf (stderr,"%s:\nallowed options\n", name);
  for (ind=0; long_options [ind].name != NULL;ind++)
  {
    // display options
    if (long_options [ind].has_arg == 0)
    {
       fprintf (stderr,"  --%-10s\n", long_options [ind].name);
    } else {
       fprintf (stderr,"  --%-10s=?? [%s]\n", long_options [ind].name, (char*)long_options [ind].has_arg);
    }
  }

  fprintf (stderr,"Example:\n  %s\\\n  --verbose inFile=/tmp/swapFile --timeSlice=100ms --blkSize=40KB \n", name);
} // end printHelp

/* ---------------------------------------------------------
 | Posixhrone Bench main entry routine
 | Parse parameters in order calling lex/yacc associated
 | routines.
 + -------------------------------------------------------- */
STATUS main 
  ( int argc     // Number of argument
   ,char **argv  // Array of  argument LINK:long_options
  )
{
 IMPORT   char* yyFileName;
 IMPORT   FILE* yyin;

 int            optionIndex = 0;
 int 		optc;
 int            currentArgv=0;
 char           *programName;
 int            inFileId=0;             // standard input
 FILE           *outFileFd=stdout;      // standard output
 UINT32         blockSize=40960;        // 40KB
 UINT32         timeSlice=10000;        // 10 millisecond
 UINT32         fileSize=100*1024*1024; // 100MByte

  // get option with GNU lib
  programName = argv[0];

  // get all options from command line 
  while ((optc = getopt_long (argc, argv, "vsp?", long_options, &optionIndex))
        != EOF)
  {
    switch (optc) 
    {
     case VERBOSE:
       verbose = TRUE;
       break;

     case DEBUG:
       verbose = TRUE;
       if (optarg == 0) goto invalidValue;
       if (!sscanf (optarg, "%ld", &debugLevel)) goto notAnInteger;
       break;

     case VERSION:
       printVersion();
       break;

     case OUTFILE:
       if (optarg == 0) goto invalidValue;
       outFileFd = fopen (optarg,"w"); 
       if (outFileFd == NULL) goto invalidFileName;
       break;

     case INFILE:
       if (optarg == 0) goto invalidValue;
       inFileId = open (optarg,O_RDONLY); 
       if (inFileId < 0) goto invalidFileName;
       break;

     case BLKSIZE:
       if (optarg == 0) goto invalidValue;
       blockSize = utilsUnitGet (optarg);
       if (blockSize == 0) goto notValidUnit;
       break;

     case FILESIZE:
       if (optarg == 0) goto invalidValue;
       fileSize = utilsUnitGet (optarg);
       if (fileSize == 0) goto notValidUnit;
       break;

     case TIMESLICE:
       if (optarg == 0) goto invalidValue;
       timeSlice = utilsUnitGet (optarg);
       if (timeSlice == 0) goto notValidUnit;
       break;

     case HELP:
     default:
       printHelp(programName);
       return (ERROR);
    }
    currentArgv ++;
  }

  if (argc < 2) goto errorSyntax;

    if ((verbose) AND (inFileId == 0)) 
    {
      fprintf (stderr,"Warning: --inFile=stdin\n");
    }

    // Place here any program entry point
    
    if (verbose) fprintf (stderr,"Msg: Main terminated normaly\n");
    return OK;

invalidFileName:
  fprintf (stderr,"Can't open file:%s\n",optarg);
  return ERROR;
  
invalidValue:
  fprintf (stderr,"Value should be set with \'=\'\n");
  return ERROR;

notAnInteger:
  fprintf (stderr,"Value should be a valid integer:%s\n",optarg);
  return ERROR;

notValidUnit:
  fprintf (stderr,"Value should be an integer+Unit:%s\n",optarg);
  return ERROR;

errorSyntax: 
  fprintf (stderr,"\nERROR: no or invalide parameters parameters\n\n");
  printHelp (programName);
  return (ERROR);
} // end main
