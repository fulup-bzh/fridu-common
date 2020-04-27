/**
 *  Copyright(c) 1996 FRIDU a Free Software Company [fridu@fridu.com]
 *
 * File      :   cecho display a message on console and redirect it in a file
 * Projet    :   Common
 * SubModule :   Config depend extraction
 * Auteur    :   Fulup Ar Foll [fulup@fridu.com (bertrand)]
 *
 * Last
 *      Author      : $Author: fulup $
 *      Date        : $Date: 1998/05/30 11:25:53 $
 *      Revision    : $Revision: 3.0.3.1 $
 *      Source      : $Source: /Master/Common/Tools/src/fridu/cecho.c,v $
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

typedef struct {
  char* symbol;
  char  value;
} SpecialChars;

static  SpecialChars specialChar [] = {
  {"+ampersand",'&'},
  {"+quote",'"'},
  {"+aster",'*'},
  {"+semicolon",';'},
  {"+backslack",'\\'},
  {"+space",' '},
  {"+plus",'+'},
  {"+slash",'/'},
  {"+newline",'\n'},
  {"+diese",'#'},
  {"+raw",'\0'},
  {NULL,'\0'}
};

/** --------------------------------------------------------------------------------
 **   cecho print all paramter is get iin output file, some option allow
 **   to append in file, or to create a new one, paramter can be any valid
 **   string + some special character NT is not able to pass thru makefile
 **   Note than special char start with + in order not interfacing with NT path.
 **   and not & fr not interferring with unix background
 ** --------------------------------------------------------------------------------*/
int main (int argc, char**argv) {

  FILE * outFile= NULL;
  char   *opt   = NULL;
  int    ind;
  int    jnd;

  /* check we have at list one parameter */
  if (argc < 4) goto errSyntaxe;

  if (!strcmp (argv[1],"-")) opt="w";
  if (!strcmp (argv[1],"+")) opt="a";

  if (opt == NULL) goto errSyntaxe;

  /* check frist parameter is valid file */
  if (!strcmp (argv[2],"null"))   return 0;
  if (!strcmp (argv[2],"stderr")) outFile=stderr;
  if (!strcmp (argv[2],"stdout")) outFile=stdout;


  /* no default output check for file mode */
  if (outFile == NULL) {
    outFile= fopen (argv[2], opt);
    if (outFile == NULL) goto errSyntaxe;
  }

  /* copy all parameter execpt last one destination file */
  for (ind=3; ind <argc; ind ++) {

    /* Check if we are facing a special char */
    if (argv[ind] [0] != '+') {
      fprintf (outFile,"%s ", argv[ind]);
    } else {
      for (jnd=0; specialChar [jnd].symbol != NULL; jnd++) {
        if (!strcmp (specialChar [jnd].symbol, argv[ind])) {
	  if (specialChar [jnd].value != '\0') {
            fprintf (outFile,"%c",specialChar [jnd].value);
          } else {
            /* Ne are facing a raw directective */
            ind ++;
            fprintf (outFile,"%s", argv[ind]);
          } 
          break;
	}
      }
      if (specialChar [jnd].symbol == NULL) goto errUnkToken;
     
    }
  }

  /* make a clean exist */
  fprintf (outFile,"\n");
  fclose (outFile);

  return 0;
   

errUnkToken:
  fprintf (stderr,"Unknow token: %s\n",  argv[ind]);
  return -1;

errSyntaxe: 
  fprintf (stderr,"ERROR: cecho syntaxe:= cecho [+|-] [filename|stdout] P2 P2  ....\n");
  fprintf (stderr,"List of special characters\n");
  for (jnd=0; specialChar [jnd].symbol != NULL; jnd++) {
      fprintf (stderr,"  %s=\'%c\'\n",specialChar [jnd].symbol,specialChar [jnd].value);
  } 
  fprintf (stderr,"-----\n");
  return -1;

}


