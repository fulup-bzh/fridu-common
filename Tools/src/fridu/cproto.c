/**
 *  Copyright(c) 1996 FRIDU a Free Software Company [fridu@fridu.com]
 *
 * File      :   ProtoBuild.c Extract all proto from a C code
 * Projet    :   Config
 * SubModule :   Proto extraction
 * Auteur    :   Fulup Ar Foll [fulup@fridu.com (bertrand)]
 *
 * Last
 *      Author      : $Author: fulup $
 *      Date        : $Date: 1999/02/16 17:29:46 $
 *      Revision    : $Revision: 3.1 $
 *      Source      : $Source: /Master/Common/Tools/src/fridu/cproto.c,v $
 *      State       : $State: Exp $
 *
 *  Modification History
 *  ---------------------
 *  01f,15feb99, fulup added restricted
 *  01e,19may98, fulup added outFile for NT
 *  01d,20feb98, fulup changed algo in order supporting any indent mode
 *  01c,11feb98, fulup added IMPORT/EXPORT for global variables
 *  01b,22apr97, fulup allowed ) to be on the same line as { for code start
 *  01a,22dec96, fulup written
 *
 */



#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define REMOVE_SPACES                           \
      for (;line [ind]!= '\0';ind++)                           \
      {                                               \
        if ((line[ind] != ' ') && (line[ind] != '\t')) break;  \
      }

/*-----------------------------------------------------------------
 | main
 |      proto routine extract PUBLIC prototype from C source file
 +-----------------------------------------------------------------*/
int main(int argc, char **argv)
 {
 FILE *inFile=NULL;
 FILE *outFile=NULL;
 char line [255];
 int  len;
 int  ind, protoDone;
 

  if (argc != 3) goto errSyntaxe;

 /* check frist parameter is valid file */
 if (!strcmp (argv[1],"stderr")) outFile=stderr;
 if (!strcmp (argv[1],"stdout")) outFile=stdout;

 /* no default output check for file mode */
 if (outFile == NULL) {
   len = strlen (argv[1]);
   if (strcmp (&argv[1][len-2],".i")) goto errDestination; 
   /* check outFile is a .d extention */
   outFile= fopen (argv[1], "w");
   if (outFile == NULL) goto errSyntaxe;
 }

 /* no default output check for file mode */
 if (!strcmp (argv[2],"stdin")) inFile=stdin;
 if (inFile == NULL) {
   len = strlen (argv[2]);
   if ((strcmp (&argv[2][len-2],".c")) && (strcmp (&argv[2][len-4],".cxx")))
      goto errSource; 
   /* check outFile is a .d extention */
   inFile= fopen (argv[2], "ro");
   if (inFile == NULL) goto errSyntaxe;
 }


  /* prepare to support C++ */
  fprintf (outFile,"#ifdef __cplusplus\n extern \"C\" {\n#endif\n");

  /* loop on all file lines */
  while (fgets (line, sizeof (line), inFile))
  {
      ind=0;        /* start a new line */
      REMOVE_SPACES;

      /* Does this line start with PUBLIC keyword */
      if ((!strncmp (&line [ind], "PUBLIC", 6))
          || (!strncmp (&line [ind], "RESTRICTED", 10)))
      {
        protoDone = 0;

        do {  /* extract proto for this routine */
          for (ind=ind; line [ind] != 0; ind++) {
	    if ((line [ind] == '{') || (line [ind] == ';')) {
              line [ind] = '\0';
              fprintf (outFile,"%s;\n", &line [ind]);
              protoDone = 1;
              break;
            } else {
              /* replace all tab with space */
              if (line[ind] == '\t') line[ind] = ' ';
              /* remove double space */
              if ((line [ind] != ' ') || (line[ind-1] != ' ')) {
                 fputc (line [ind],outFile);
              }
            }
          }
          if (protoDone) break;
          ind = 0;
       } while (fgets (line, sizeof (line), inFile));

      } else if (!strncmp (&line [ind], "EXPORT", 6)) {
          fprintf (outFile,"extern ");
          /* extract proto until = or eof */
          for (ind=ind+6; line [ind] != '\0'; ind ++) {
              if ((line [ind] == '=') || (line [ind] == ';'))  {
                 fprintf (outFile,";\n");
                 break;
              } else {
                 fputc (line [ind],outFile);
              }
	  }
          
      }/* end !strncmp */
  } /* end while */

  /* prepare to support C++ */
  fprintf (outFile,"#ifdef __cplusplus\n}\n#endif\n\n");

return 0;
 
errSyntaxe:
  fprintf (stderr,"ERROR: syntaxe is cproto outFile.d inFileName.[c|cxx]\n");
  return -1;

 errDestination:
  fprintf (stderr,"ERROR: cproto destination file should be a .i file\n");
  return -1;

 errSource:
  fprintf (stderr,"ERROR: cproto source file should be [.cxx|.c] file\n");
  return -1;

}


