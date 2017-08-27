#!/usr/bin/perl

#openApps.pl - opens any number of applications with Mac's open(1)
#  (Mac only, Perl script)
#Copyright (C) 2016-2017  Arc676/Alessandro Vinciguerra <alesvinciguerra@gmail.com>

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

sub get{
	my $inp = <STDIN>;
	chomp $inp;
	return $inp;
}

my @apps = ();
print "Enter app names; blank input to stop\n";
do{
	push @apps, get();
}while ($apps[scalar(@apps) - 1] ne "");

if (scalar @apps == 1){
	print "Cancelling...\n";
	exit;
}

print "Opening apps...\n";
pop @apps;

foreach my $app (@apps){
	next if ($app =~ /[\"\']/);
	print `open -a \"$app\"`;
}
