/* $Header: /Master/Common/Tools/src/fridu/shadow.c,v 3.0.3.1 1998/05/30 11:25:53 fulup Exp $
 *
 *  Copyright(c) 1996 FRIDU a Free Software Company [fridu@fridu.com]
 *
 * File      :   shadow.c
 * Projet    :   rtWeb
 * SubModule :   tools
 * Auteur    :   Unknow, may be some student in some University
 *
 * Last
 *      Modification: Corrected help function
 *      Author      : $Author: fulup $
 *      Date        : $Date: 1998/05/30 11:25:53 $
 *      Revision    : $Revision: 3.0.3.1 $
 *      Source      : $Source: /Master/Common/Tools/src/fridu/shadow.c,v $
 *      State       : $State: Exp $
 *
 * Modification History
 * ---------------------
 *  Revision 1.2  1997/06/02 fulup corrected warning under linux
 *  Revision 1.1  1996/11/18 fulup written
 *
 *
 */

#include <sys/types.h>
#include <limits.h>
#include <stdio.h>
#include <sys/stat.h>
#include <dirent.h>
#include <unistd.h>
#include <errno.h>
#include <easyc.h>

#include <string.h>

#ifndef PATH_MAX
#define PATH_MAX 1024
#endif

/*
 *    -r             do not make links to RCS directories
 *    -v             print verbose running commentary
 *    -f             force lynx when file exist
 *    -v             warn when a link replace the old one
 *    -x directory   ignore directory in old-path
 */
int rflag   = 1;
int enable  = 1;
int verbose = 0;
int force   = 0;

int dodir( char *name, char *head);

void main( int argc, char *argv[])
{
    extern char *optarg;
    extern int optind;
    int c;
    int errflg = 0;

    while ((c = getopt(argc, argv, "svfrn")) != -1)
	switch (c)
	{
	case 'f':
	    force = 1;
	    break;
	case 'r':
	    rflag = 0;
	    break;
	case 'v':
	    verbose = 1;
	    break;
	case '?':
	    errflg++;
	}
    if ((errflg) || (optind + 1 != argc))
	{
	fprintf(stderr, "usage: shadow -frv dir\n");
	exit(1);
	}

    dodir(argv[optind], ".");
    exit(0);
}

/* check if filename finish by upper case only */
int tailUpper(char *p)
{
    int  ind;
    int  status = TRUE;

    for (ind= strlen(p)-1; ind >= 0; ind --)
    {
	if ( p[ind] == '/') break;
        if ( p[ind] > 'Z')
        {
		status = FALSE;
		break;
        }

    }
    return status;
}

/* build a link and display warning is asked */
void buildLink (char *oldpath, char *newpath)
{
  int    oldShadowFile;
  struct stat sbuf;
  int    status;

  /* check if we have to replace shadow file */
  if (lstat(newpath, &sbuf) == ERROR)
  {
	if (verbose) printf ("create new link %s -> %s\n", newpath, oldpath);
  } else {
	if (S_ISREG(sbuf.st_mode))
        {
		if (verbose) printf ("leaved %s [is a plain file]\n", newpath);
		return;
        }
        else if (S_ISLNK(sbuf.st_mode))
        {
                if (force) 
                {
		    if (verbose) printf ("forced %s -> %s\n", newpath, oldpath);
		    unlink (newpath);
                } else {
		    if (verbose) printf ("leaved %s old link\n", oldpath);
                    return;
                }
        } else 
        {
		printf ("WARNING: %s is neither is link or a plain file\n", newpath);
                return;
        }
  }

  /* now we should create the file with no trouble */
  status = symlink (oldpath, newpath);
  if (status == ERROR)
  {
	perror ("symlink");
  }
} /* end buildLink */

int dodir( char *name, char *head)
{
    DIR *dirp;
    struct dirent *dp;
    struct stat sbuf;
    char path[PATH_MAX];
    char path2[PATH_MAX];
    char path3[PATH_MAX];
    char *cp;

    if ((dirp = opendir(name)) == NULL)
	{
	perror("opendir");
	return -1;
	}
    for (dp = readdir(dirp); dp != NULL; dp = readdir(dirp))
	{
	if (*dp->d_name == '.')
	    {
	    if (strcmp(dp->d_name, ".") == 0 || strcmp(dp->d_name, "..") == 0)
		continue;
	    fprintf(stderr, "Warning: file `%s/%s' ignored (hidden)\n",
		name, dp->d_name);
	    continue;
	    }
	if (strlen(name) + strlen(dp->d_name) + 2 > PATH_MAX)
	    {
	    fprintf(stderr, "Warning: file `%s/%s' ignored (name to long)\n",
		name, dp->d_name);
	    continue;
	    }
	strcpy(path2, head);
	strcat(path2, "/");
	strcat(path2, dp->d_name);

	strcpy(path, name);
	strcat(path, "/");
	strcat(path, dp->d_name);

	*path3 = 0;
	if (*name != '/')
	    {
	    for (cp = path2; strncmp(cp, "./", 2) == 0; cp += 2)
		;
	    for (; *cp != 0; cp++)
		if (*cp == '/')
		    strcat(path3, "../");
	    }
	strcat(path3, name);
	strcat(path3, "/");
	strcat(path3, dp->d_name);

        /* if we can not stat master file we just ignore it */
	if (stat(path, &sbuf) == -1)
	    {
	    perror(path);
	    continue;
	    }

        /* we make direct link on upper case directoties */
	if (tailUpper(path) && S_ISDIR(sbuf.st_mode))
	    {
	    if (rflag)
		{
		if (enable) buildLink(path3, path2);
	        continue;
                }
	    }
	if (S_ISDIR(sbuf.st_mode))
	    {
	    if (enable)
		if (mkdir(path2, (mode_t) 0777) == -1 && errno != EEXIST)
		    perror("mkdir");
	    if (verbose)
		printf("mkdir %s\n", path2);
	    dodir(path, path2);
	    }
	else if (S_ISREG(sbuf.st_mode))
	    {
	    if (enable) buildLink(path3, path2);
	    }
	else
	    {
	    fprintf(stderr, "Warning: file `%s/%s' ignored (unknown type)\n",
		name, dp->d_name);
	    }
	}
    closedir(dirp);
    return 0;
    }
