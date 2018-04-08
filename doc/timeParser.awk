." Manpage for TIMEPARSER.AWK.
.Dd 8 Apr 2018
.Dt "TIMEPARSER.AWK" "67" "Arc Utilities Library"
.Sh NAME
.Nm timeParser.awk
.Nd Parses CSV output from \fBtimeParser.pl\fP(67)
.Pp
.Sh SYNOPSIS
.Nm
.Ar data.csv
.Pp
.Sh DESCRIPTION
.Nm
reads the CSV output from \fBtimeParser.pl\fP(67) and outputs the
total and average time for the three types of process time provided
by \fBtime\fP(1).
.Pp
.Sh SEE ALSO
awk(1), timeParser.pl(67)
.Sh AUTHOR
Written by Arc676/Alessandro Vinciguerra
.Sh COPYRIGHT
Copyright (C) 2018 Arc676/Alessandro Vinciguerra.
.Pp
Source code and man page available under GPLv3, see program
file and gpl.txt file for details.
