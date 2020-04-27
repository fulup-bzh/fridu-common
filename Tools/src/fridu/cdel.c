/**
 *  Copyright(c) 1996 FRIDU a Free Software Company [fridu@fridu.com]
 *
 * File      :   cdel bad unix del emulation for dos
 * Projet    :   Common
 * SubModule :   Config depend extraction
 * Auteur    :   Fulup Ar Foll [fulup@fridu.com (bertrand)]
 *
 * Last
 *      Author      : $Author: fulup $
 *      Date        : $Date: 1998/05/30 11:25:53 $
 *      Revision    : $Revision: 3.0.3.1 $
 *      Source      : $Source: /Master/Common/Tools/src/fridu/cdel.c,v $
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
#include <fcntl.h>
#ifdef LINUX
#include <unistd.h>   
#endif
/** --------------------------------------------------------------------------------
 **   cdel delete filename pass in parameter
 ** --------------------------------------------------------------------------------*/
int main (int argc, char**argv) {
  int ind;

  /* copy all parameter execpt last one destination file */
  for (ind=1; ind <argc; ind ++) {

    /* delete file */
    (void)unlink (argv[ind]);

  }

  return 0;
}


