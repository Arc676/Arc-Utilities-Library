#!/usr/bin/awk -f

#timeParser.awk - Works with the output of timeParser.pl to give the total and average times
#	(Designed to work with BSD time(1), AWK script)
#Copyright (C) 2018  Arc676/Alessandro Vinciguerra <alesvinciguerra@gmail.com>

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation (version 3)

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.

BEGIN {
		FS = "[:,]"
		real = 0
		user = 0
		sys = 0
	}
	{
		real += $1 * 60 + $2
		user += $3 * 60 + $4
		sys  += $5 * 60 + $6
	}
END {
		print "Total real: " real
		print "Average real: " real/NR
		print "Total user: " user
		print "Average user: " user/NR
		print "Total sys: " sys
		print "Average sys: " sys/NR
	}
