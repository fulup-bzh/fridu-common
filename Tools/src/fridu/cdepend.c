/**
 *  Copyright(c) 1996 FRIDU a Free Software Company [fridu@fridu.com]
 *
 * File      :   cdepend.c get paramter build include path list
 * Projet    :   Common
 * SubModule :   Config depend extraction
 * Auteur    :   Fulup Ar Foll [fulup@fridu.com (bertrand)]
 *
 * Last
 *      Author      : $Author: fulup $
 *      Date        : $Date: 1999/02/17 10:53:52 $
 *      Revision    : $Revision: 3.1 $
 *      Source      : $Source: /Master/Common/Tools/src/fridu/cdepend.c,v $
 *      State       : $State: Exp $
 *
 *  Modification History
 *  ---------------------
 *  01b,17feb99, fulup added support for dos end of line
 *  01a,18may98, fulup written
 *
 */



#include <stdlib.h>
#include <string.h>
#include <stdio.h>

/* default verbose mode is off */
static int verbose = 0;

/* we save dependencies in a linked list */
typedef struct cdepends {
  char* fullName;
  struct cdepends *next;
} cdepends;

static cdepends *depHead = NULL;

/**-------------------------------------------------------------------
 ** Add a new dependency in linked list
 ** ------------------------------------------------------------------*/
static void addDep (char *fullName) {

 static cdepends *currentDep;
 cdepends *dep;


 /* search is fil is not already iin dep list */
 if (depHead != NULL) {
   for (dep = depHead; dep != NULL; dep = dep->next) {
     if (!strcmp (fullName,dep->fullName)) return;
   }
 }  
 
 dep = (cdepends*) malloc (sizeof(cdepends));
 dep->fullName = strdup(fullName);
 dep->next     = NULL;

 if (depHead == NULL) {
   depHead    = dep;
   currentDep = dep;
 } else {
   currentDep->next = dep;
   currentDep = dep;
 }
}


/**-------------------------------------------------------------------
 ** Each Include are printed in a gmake compliant format 
 ** ------------------------------------------------------------------*/
static int searchIncl (char *inName, char **inPath) {
 int      ind;
 FILE     *inFile  = NULL;
 char     line     [255];
 char     fullName [255];
 int      lineNum = 0;
 char     *newName;
 
 /* search file in path list  */
 for (ind=0; inPath [ind] != NULL; ind++) {

   /* build filepath */
   sprintf (fullName, "%s%s",inPath [ind], inName );

   /* try to open file */
   inFile= fopen (fullName, "r");
   if (inFile != NULL) break ;
 }
 /* no file found return an error for caller to display a usefull warning */
 if (inFile == NULL) return -1;


 /* we got a valid file we search in for #include "path" lines */
 if (verbose) fprintf (stderr,"searching: %s\n", fullName);

 /* loop on file until end ignore any line bigger then 255 characters */
 while (fgets (line,sizeof(line),inFile)) {
   lineNum ++;

   /* remove leading space */
   for (ind=0; line [ind]!= '\0'; ind++) {
     if ((line[ind] != ' ') && (line[ind] != '\t')) break;
   }

   /* check we are facing an include */
   if (!strncmp (&line [ind],"#include",8)) {

     /* remove space and check for " or < */
     ind = ind +8;
     for (; line [ind]!= '\0'; ind++) {
       if ((line[ind] != ' ') && (line[ind] != '\t')) break;
     }

     /* if we facing a " include we get the name  */
     if (line [ind] == '"') {

       /* get new name remove trailing " and loop in search */
       newName = &line [ind+1];

       /* move back in line to findtout trailing \" */
       for (ind=strlen (newName); newName [ind] != '"'; ind --); 
       newName [ind] = '\0';
       
       /* printout dependencie */
       addDep (fullName);
       if (searchIncl (newName,inPath) == -1)  {
          fprintf (stderr,"cdepend include not found [line:%d]\n  file:%s\n  include:%s\n"
                  , lineNum, fullName, newName); 
       }
     }
   }  
 }
 return 0;
}

/**--------------------------------------------------------------------
 | main
 |      depend extract only include with "" system include with <>
 |      are ignored. cdepend as been written for dos, under Unix
 |      gcc -MM provide a beter include analysis, cdepend is a very
 |      basic C in order beeing very easy to port even on dos (burk..)
 +---------------------------------------------------------------------*/
int main(const unsigned int argc, char *argv[])
 {
 FILE *inFile=NULL;
 FILE *outFile=NULL;
 int  jnd=1;
 char *inName;
 unsigned int  ind,knd;
 unsigned int  len;
 cdepends *dep;
 char objName [255];
 char **inPath; 

 /* This is surelly to big but we dont care */
 inPath = (char**)malloc (argc*sizeof (char*));

 /* Defautl include search is current directory  */
 inPath[0] = "";
 inPath[1] = NULL;

 /* check we have at list one parameter */
 if (argc < 2) goto errSyntaxe;

 /* check frist parameter is valid file */
 if (!strcmp (argv[1],"stderr")) outFile=stderr;
 if (!strcmp (argv[1],"stdout")) outFile=stdout;

 /* no default output check for file mode */
 if (outFile == NULL) {
   len = strlen (argv[1]);
   if (strcmp (&argv[1][len-2],".d")) goto errDestination; 
   /* check outFile is a .d extention */
   outFile= fopen (argv[1], "w");
   if (outFile == NULL) goto errSyntaxe;
 }

 /* check last parameter is valid file */
 inName = argv[2];
 inFile= fopen (inName, "r");
 if (inFile == NULL) goto errSyntaxe;

 /* compute objFile from fileName */
 for (ind=strlen(inName)-1; inName [ind] != '\0'; ind --) {
   if (inName [ind] == '.') break;
 } 
 if (inName [ind] == '\0')     goto errNotSource;
 if (ind > sizeof (objName)-5) goto errToBig;

 /* remove directory name */
 for (knd = ind; inName [knd]!= '\0'; knd--) {
   if ((inName [knd] == '/') ||  (inName [knd] == '\\')) {
     knd --;
     break;
   }
 }
 knd ++;

 inName [ind] = '\0';
 sprintf (objName,"%s$(OBJ_SFX)",&inName [knd]);
 inName [ind] = '.'; 

 if (verbose) fprintf (stderr,"Obj file: %s\n", objName);

 /* Build inputPath List with all -I option given in cmd line opt */
 for (ind=2; ind < argc; ind ++) {
  if (!(strncmp ("-I", argv[ind], 2))) {
    len = strlen (&argv[ind] [2]);
    inPath [jnd] = &argv[ind] [2];

    /* check include path end with / or add it */
    if (inPath [jnd] [len-1] != '/') {
     inPath [jnd] = (char*)malloc (len+2);
     memcpy (inPath [jnd], &argv[ind] [2], len);
     inPath [jnd] [len] = '/';
     inPath [jnd] [len+1]   = '\0';
    }
    jnd ++;
  }
  if ((!(strncmp ("--v", argv[ind], 3)))) {
    verbose=1;
  }
  if ((!(strncmp ("--h", argv[ind], 3)))) {
    goto errSyntaxe;
  }
 }

 /* close input include path list */
 inPath [jnd] = NULL;

 if (verbose) {
   fprintf (stderr,"Include path list:\n");
   for (ind=0; inPath[ind] != NULL; ind++) {
     fprintf (stderr,"  %d: %s\n",ind, inPath[ind]);
   }
 }


 /* Scan recusivelly file in order finding dependencies */
 (void)searchIncl (inName,inPath);

 /* printout dependencies ist */
 if (depHead != NULL) {
   fprintf (outFile, "$(OBJDIR)/%s: ", objName);
   for (dep = depHead; dep != NULL; dep = dep->next) {
     fprintf (outFile,"\t%s \\\n", dep->fullName);
   }
   fprintf (outFile,"\n");
 }  

return 0;
 
errSyntaxe: 
  fprintf (stderr,"ERROR: cdepend syntaxe is cdepend outFile.d fileName.[c|cxx] -IPATH1 ... -IpathN\n");
  return -1;

errNotSource:
  fprintf (stderr,"ERROR: cdepend input file is not .c,.cxx,.h,... terminated\n");
  return -1;

errToBig:
  fprintf (stderr,"ERROR: cdepend input file name is bigger than 255 (hug!!!)\n");
  return -1;

errDestination:
  fprintf (stderr,"ERROR: cdepend outfile should be stdout or .d file\n");
  return -1;
}



