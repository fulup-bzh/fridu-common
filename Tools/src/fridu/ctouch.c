/**
 *  Copyright(c) 1996 FRIDU a Free Software Company [fridu@fridu.com]
 *
 * File      :   ctouch touch --nocreate enulation for DOS
 * Projet    :   Common
 * SubModule :   Config depend extraction
 * Auteur    :   Fulup Ar Foll [fulup@fridu.com (bertrand)]
 *
 * Last
 *      Author      : $Author: fulup $
 *      Date        : $Date: 1998/07/15 22:00:50 $
 *      Revision    : $Revision: 3.1 $
 *      Source      : $Source: /Master/Common/Tools/src/fridu/ctouch.c,v $
 *      State       : $State: Exp $
 *
 *  Modification History
 *  ---------------------
 *  01a,18may98, fulup written
 *
 */



#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include <sys/types.h>

#ifdef WIN32
#include <sys/utime.h>
#else
#include <utime.h>
#endif

/** --------------------------------------------------------------------------------
 **   ctouch open all file in write append mode
 **   in order changing last write time stamp. Command take [+|-] as first parameter
 **   in order selecting touch and untouch mode. [+=touch] [-=untouch]
 ** --------------------------------------------------------------------------------*/
int main (int argc, char**argv) {

  int    inFile = -1;
  int    opt    = 0;
  int    ind;
  struct utimbuf newTime;

  /* check we have at list one parameter */
  if (argc < 3) goto errSyntaxe;

  if (!strcmp (argv[1],"+")) {
    opt=1;
  }

  if (!strcmp (argv[1],"-")) {
    opt=2;
  }

  if (opt == 0) goto errSyntaxe;
  
  /* build time information either 0 or current time */
  memset (&newTime,0, sizeof (struct utimbuf));

  /* copy all parameter execpt last one destination file */
  for (ind=1; ind <argc; ind ++) {

    /* update time */
    if (opt == 1) {
      utime (argv[ind],NULL);
    } else {
      utime (argv[ind],&newTime);
    }
  }

  return 0;
   

errSyntaxe: 
  fprintf (stderr,"ERROR: ctouch syntaxe:= ctouch [+-] file1 file2 file3  ....\n");
  return -1;

}
