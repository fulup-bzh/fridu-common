/**
 *  Copyright(c) 1996 FRIDU a Free Software Company [fridu@fridu.com]
 *
 * File      :   ccat enumate cat Uinx function on stupid Win95
 * Projet    :   Common
 * SubModule :   Config depend extraction
 * Auteur    :   Fulup Ar Foll [fulup@fridu.com (bertrand)]
 *
 * Last
 *      Author      : $Author: fulup $
 *      Date        : $Date: 1998/05/30 11:25:53 $
 *      Revision    : $Revision: 3.0.3.1 $
 *      Source      : $Source: /Master/Common/Tools/src/fridu/ccat.c,v $
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
 **   ccat output file passed in param in forst param file
 **   depending on first option it works in create or append mode
 ** --------------------------------------------------------------------------------*/
int main (int argc, char**argv) {

  int    outFile= -1;
  int    inFile = -1;
  int    opt    = 0;
  char   buffer [4096];
  int    ind;
  int    jnd;
  int    nbRead,nbWrite;

  /* check we have at list one parameter */
  if (argc < 4) goto errSyntaxe;

  if (!strcmp (argv[1],"-")) opt= O_CREAT|O_TRUNC;
  if (!strcmp (argv[1],"+")) opt= O_CREAT|O_APPEND;

  if (opt == -1) goto errSyntaxe;

  /* check frist parameter is valid file */
  if (!strcmp (argv[2],"null"))   return 0;
  if (!strcmp (argv[2],"stderr")) outFile=2;
  if (!strcmp (argv[2],"stdout")) outFile=1;


  /* no default output check for file mode */
  if (outFile == -1) {
    outFile= open (argv[2],O_WRONLY|opt,0770);
    if (outFile == -1) goto errOut;
  }

  /* copy all parameter execpt last one destination file */
  for (ind=3; ind <argc; ind ++) {

    /* Check if we are facing a special char */
    inFile = open (argv[ind],O_RDONLY);
    if (inFile == -1) goto errFile;

    /* copy file until eof */
    nbRead = read (inFile,buffer,sizeof(buffer));
    while (nbRead >0) {
      nbWrite = write (outFile,buffer,(unsigned)nbRead);
      if (nbRead != nbWrite) goto errWrite;
      nbRead = read (inFile,buffer,sizeof(buffer));
    }
    close (inFile); 
  }

  /* make a clean exist */
  write (outFile,"\n",1);
  close (outFile);

  return 0;
   

errSyntaxe: 
  fprintf (stderr,"ERROR: ccat syntaxe:= ccat [+|-] [filename|stdout] FILE1 FILE2  ....\n");
  return -1;

errOut: 
  fprintf (stderr,"ERROR: ccat can't open outfile: %s\n",argv[2]);
  return -1;

errFile: 
  fprintf (stderr,"ERROR: ccat can't open file:%s\n",argv[ind]);
  return -1;

errWrite: 
  fprintf (stderr,"ERROR: ccat writting file:%s to %s\n",argv[ind],argv[2]);
  return -1;

}


