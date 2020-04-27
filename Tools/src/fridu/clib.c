/**
 *  Copyright(c) 1996 FRIDU a Free Software Company [fridu@fridu.com]
 *
 * File      :   clib MSDOS lib32 wrapper
 * Projet    :   Common
 * SubModule :   Config depend extraction
 * Auteur    :   Fulup Ar Foll [fulup@fridu.com (bertrand)]
 *
 * Last
 *      Author      : $Author: fulup $
 *      Date        : $Date: 1998/05/30 11:25:53 $
 *      Revision    : $Revision: 3.0.3.1 $
 *      Source      : $Source: /Master/Common/Tools/src/fridu/clib.c,v $
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


/** --------------------------------------------------------------------------------
 **   clib wrap MSVC lib manager in order making lib to look almost like Unix ar.
 **   Before including object file in order not having obj path in library
 **   clib change to obj source directory. Clib also check if lib exist in order
 **   choosing the effective MS syntaxe, it also replace all / by \ before execvp
 **   process.
 **   ex: clib c:/pmaster/msvc-4.2/bin/lib /nologo /verbose -- /dir/libname.lib \
 **            /obj/complex/path/objFile1  /obj/complex/path/objFile2
 **   Bug: Obj source path is compute on first object file also all obj file should
 **        be in the same directory, and be prefixed with same full path direc name.
 ** --------------------------------------------------------------------------------*/
int main (int argc, char**argv) {

  int    outFile= -1;
  int    newLib = 0;
  int    ind,len,prm;
  int    jnd=0;
  char   **argvName;
  char   name[255];

  /* check we have at list one parameter */
  if (argc < 4) goto errSyntaxe;

  // search -- for end of paramter
  for (prm=0; prm <argc; prm++) {
    if (!strcmp ("--",argv[prm])) break;
  }
  if (prm == argc) goto errSyntaxe;

  // start checking destination library exist
  outFile= open (argv[prm+1],O_RDONLY);
  if (outFile == -1) {
    newLib = 1;
  } else {
    close (outFile);
  }

  // Get object directory from first object file
  for (len=strlen(argv[prm+2])-1; argv[prm+2][len] != '\0'; len--) {
    if (argv[prm+2][len] == '/') break;
  }
  if (ind == 0) goto errObjPath;
  argv[prm+2][len] = '\0';
  if (chdir (argv[prm+2])) goto errDirName;

  // Malloc command param array
  argvName = (char**) malloc ((argc+4)*(sizeof(char*)));

  // replace all / with \ for stupid DOS
  for (ind=0; argv[1][ind] != '\0'; ind++) {
    if (argv[1][ind] == '/') argv[1][ind] = '\\';
  }

  // Build lib param array
  argvName[jnd++] = argv[1];
 
  // Loop in all input File to produce lib command file
  for (ind=2; ind <argc; ind ++) {
    // include as it commmand option
    if (ind < prm) {
      argvName [jnd++] = argv[ind];
    }
  
    // lib destination name as to be prefixd if new
    if (ind == prm+1) {
      if (!newLib) {
         argvName [jnd++] = argv[ind];
      } else {
         sprintf (name,"/OUT:%s",argv[ind]);
         argvName [jnd++] = name;
      }
    }

    // object file should have directory name removed
    if (ind > prm+1 ) {
      argvName [jnd++] = &argv[ind] [len+1];
    }
  }

  // Close parameter array
  argvName[jnd++] = NULL;
  
  // Exec command
  execvp (argv[1], argvName);

  // hug
  fprintf (stderr,"ERROR: execvp [%s] failled\n", argv[1]);
  return -1;
   

errSyntaxe: 
  fprintf (stderr,"ERROR: clib syntaxe:= clib lsLib32path op1 opt2 -- libName FILE1.obj FILE2.obj  ....\n");
  return -1;

errObjPath: 
  fprintf (stderr,"ERROR: clib can't extract a directory path from obj file: %s\n",argv[prm+2]);
  return -1;

errDirName: 
  fprintf (stderr,"ERROR: clib can't change to destination dir :%s\n",argv[prm+2]);
  return -1;

}

