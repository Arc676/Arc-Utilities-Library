." Manpage for TIMEPARSER.pl.
.Dd 8 Apr 2018
.Dt "TIMEPARSER.pl" "67" "Arc Utilities Library"
.Sh NAME
.Nm timeParser.pl
.Nd Converts the output of \fBtime\fP to CSV
.Pp
.Sh SYNOPSIS
.Nm
.Pp
.Sh DESCRIPTION
.Nm
reads the output from \fBtime\fP(1) and converts it to a CSV line.
.Nm
expects only output from \fBtime\fP, so if the timed program provides
any output, it must be piped to \fB/dev/null\fP. The
.Nm
utility can be used in the following ways:
.Pp
{ time program arguments > /dev/null; } 2>&1 | timeParser.pl >> data.csv
.Pp
{ time program arguments > /dev/null; } 2 > output
.br
timeParser.pl < output > data.csv
.Pp
.Sh SEE ALSO
time(1), perl(1), timeParser.awk(67)
.Sh AUTHOR
Written by Arc676/Alessandro Vinciguerra
.Sh COPYRIGHT
Copyright (C) 2018 Arc676/Alessandro Vinciguerra.
.Pp
Source code and man page available under GPLv3, see program
file and gpl.txt file for details.
