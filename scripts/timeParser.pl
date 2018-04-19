#!/usr/bin/perl

#timeParser.pl - Reads the output from BSD time(1) and converts it into a single CSV line
#	(Designed to work with BSD time(1), Perl script)
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

use strict;
use warnings;

my $data = "";
foreach my $i (0 .. 3){
	my $time = <STDIN>;
	next if $i == 0;
	chomp $time;
	$time =~ /(\d+)m([0-9\.]+)s$/;
	$data .= $1 . ":" . $2 . ",";
}
print $data . "\n";
