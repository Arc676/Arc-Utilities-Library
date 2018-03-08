." Manpage for BACKUP.PL.
.Dd 7 Aug 2017
.Dt "BACKUP.PL" "67" "Arc Utilities Library"
.Sh NAME
.Nm backup.pl
.Nd performs backups using rsync based on a configuration file
.Pp
.Sh SYNOPSIS
.Nm
.Op Ar OPTIONS...
.Pp
.Sh DESCRIPTION
The
.Nm
Perl script parses a configuration file for backup tasks and then uses
\fBrsync\fP(1) to back up the contents of specified source directories to
specified destination directories.
.Pp
The script also allows for incremental updates to be configured. See the man
page for the configuration file for more details.
.Pp
.Sh OPTIONS
.Bl -tag -width flag
.It Fl f=\fIfile\fP, -conf=\fIfile\fP
Specifies a configuration file to be used. If none is given, ~/.arcutillib/backup.conf is used.
.It Fl -alwaysconf
Always perform a dry run of \fBrsync\fP and prompt the user to confirm the backup
task before copying any files, regardless of what the configuration file says.
.It Fl -ask
Prompt for confirmation before each task, allowing the user to run only a subset of
the backup tasks specified in the configuration file. This implies \fB--idtasks\fP.
.It Fl -debug
Print shell commands before running them to aid debugging/troubleshooting.
.It Fl -link
When creating non-incremental backups, delete symbolic links to the previous backup and
create new links to the new backup.
.It Fl q, -quiet
Reduce \fBrsync\fP verbosity. By default, all calls to \fBrsync\fP include the \fB--verbose\fP flag.
.It Fl -uponly
Only run update tasks and skip all backup tasks. See backup.conf(66) for more details.
.It Fl -idtasks
Output the ID of each task as it is run.
.It Fl s, -safe, -qof
Tells
.Nm
to terminate if any shell command exits with a non-zero error code (quit on fail mode). By default
this is disabled and in the event of a failed command, the user will be prompted to determine whether
the backup should be canceled.
.El
.Sh SEE ALSO
perl(1), rsync(1), backup.conf(66)
.Sh AUTHOR
Written by Arc676/Alessandro Vinciguerra
.Sh COPYRIGHT
Copyright (C) 2017 Arc676/Alessandro Vinciguerra.
.Pp
Source code and man page available under GPLv3, see program
file and gpl.txt file for details.
