#!/usr/bin/perl

#backup.pl - reads a configuration file and runs backups using rsync accordingly
#  (Assumes UNIX system for getting home folder from $ENV, Perl script)
#Copyright (C) 2017  Arc676/Alessandro Vinciguerra <alesvinciguerra@gmail.com>

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

my $cfname = $ENV{"HOME"}."/.arcutillib/backup.conf";
my $alwaysConfirm = 0;
my $askForTasks = 0;
my $debug = 0;
my $updateLink = 0;
my $quiet = 0;
my $upOnly = 0;
my $printIDs = 0;

for my $arg (@ARGV){
	if ($arg =~ /--conf=.+|-f=.+/){
		$arg =~ /.+=(.+)/;
		$cfname = $1;
	} elsif ($arg eq "--alwaysconf"){
		$alwaysConfirm = 1;
	} elsif ($arg eq "--ask"){
		$askForTasks = 1;
	} elsif ($arg eq "--debug"){
		$debug = 1;
	} elsif ($arg eq "--link"){
		$updateLink = 1;
	} elsif ($arg eq "--quiet" || $arg eq "-q"){
		$quiet = 1;
	} elsif ($arg eq "--uponly"){
		$upOnly = 1;
	} elsif ($arg eq "--idtasks"){
		$printIDs = 1;
	} else {
		die "Invalid flag: $arg\n";
	}
}

open my $conffile, "<", $cfname or die "Failed to find configuration file\n";

while ((my $line = <$conffile>)){
	next if ($line =~ /^#/);
	chomp $line;
	if ($line eq "[UPDATE]"){
		print "Update task found\n";
		my $src = "";
		my $dst = "";
		my $file = "";
		my $assumeYes = not $alwaysConfirm;
		while (defined($line = <$conffile>)){
			next if ($line =~ /^#/);
			chomp $line;
			if ($line =~ /SRC=(.+)/){
				$src = $1;
			} elsif ($line =~ /DST=(.+)/){
				$dst = $1;
			} elsif ($line =~ /FIFR=(.+)/){
				$file = $1;
			} elsif ($line eq "[CONFIRM]"){
				$assumeYes = 0;
			} elsif ($line eq "[END]"){
				last;
			} elsif ($printIDs && $line =~ /ID=(.+)/){
				print "Task ID: " . $1 . "\n";
			}
		}
		if ($src eq ""){
			warn "Parse error: update task found but no source path specified\nSkipping...\n";
			next;
		}
		if ($dst eq ""){
			warn "Parse error: update task found but no destination path specified\nSkipping...\n";
			next;
		}
		if (! -d $src || ! -d $dst){
			warn "Error: source directory or destination directory for task does not exist\nSkipping...\n";
			next;
		}
		if ($askForTasks){
			print $src . " -> " . $dst . "\nRun task? [Y/n]: ";
			next if (<STDIN> =~ /^[nN]/);;
		}
		
		my @args = ("rsync", "-ru", "--exclude", "'.*'");
		push(@args, "--verbose", "--progress") 	if (not $quiet);
		push(@args, "--files-from=$file") 	if ($file ne "");
		
		if (not $assumeYes){
			my @tArgs = (@args, "--dry-run", $src, $dst);
			system(@tArgs) == 0 or die "rsync exited with error code " . ($? >> 8) . "\n";
			print "OK? [y/N]: ";
			next unless (<STDIN> =~ /^[yY]/);
		}
		push(@args, $src, $dst);

		if ($debug){
			print join(" ", @args) . "\n";
		} else {
			system(@args) == 0 or die "rsync exited with error code " . ($? >> 8) . "\n";
		}
	} elsif ($line eq "[BACKUP]"){
		if ($upOnly){
			while (defined($line = <$conffile>) && $line ne "[END]\n"){}
			next;
		}
		print "Backup task found\n";
		my $src = "";
		my $dst = `date "+%Y-%m-%d--%H_%M"`;
		chomp $dst;
		my $bPath = "";
		my $confirmFirst = $alwaysConfirm;
		my $latest = "";
		
		my @args = ("rsync","-rt", "--exclude", "'.*'");
		push(@args, "--verbose", "--progress") if (not $quiet);
		while (defined($line = <$conffile>)){
			next if ($line =~ /^#/);
			chomp $line;
			if ($line =~ /SRC=(.+)/){
				$src = $1;
				if ($src !~ /\/$/){
					$src .= '/';
				}
			} elsif ($line =~ /BPATH=(.+)/){
				$bPath = $1;
			} elsif ($line =~ /[LC]DST=(.+)/){
				my $path = $1;
				$latest = $path;
				my $original = `readlink $latest`;
				chomp $original;
				$latest = $bPath . '/' . $original if ($original ne "");
				if ($line =~ /LDST=.+/){
					push @args, "--link-dest=$latest";
				} else {
					push @args, "--compare-dest=$latest";
				}
				if ($original ne ""){
					$latest = $path;
				}
			} elsif ($line =~ /EXFR=(.+)/){
				push @args, "--exclude-from=$1";
			} elsif ($line =~ /INFR=(.+)/){
				push @args, "--include-from=$1";
			} elsif ($line =~ /FIFR=(.+)/){
				push @args, "--files-from=$1";
			} elsif ($line eq "[CONFIRM]"){
				$confirmFirst = 1;
			} elsif ($line eq "[COMPARE BPATH]"){
				for my $prev (split("\n", `ls $bPath`)){
					my $arg = "--compare-dest=" . $bPath . '/' . $prev;
					push @args, $arg;
				}
			} elsif ($line eq "[END]"){
				last;
			} elsif ($printIDs && $line =~ /ID=(.+)/){
				print "Task ID: " . $1 . "\n";
			}

		}
		if ($src eq ""){
			warn "Parse error: backup task found but no source path specified\nSkipping...\n";
			next;
		}
		if ($bPath eq ""){
			warn "Parse error: backup task found but no backup path specified\nSkipping...\n";
			next;
		}
		if (! -d $src || ! -d $bPath){
			warn "Error: source directory or destination directory for task does not exist\nSkipping...\n";
			next;
		}
		$dst = $bPath . '/' . $dst;
		if ($askForTasks){
			print $src . " -> " . $dst . "\nRun task? [Y/n]: ";
			next if (<STDIN> =~ /^[nN]/);;
		}
		if ($confirmFirst){
			my @tArgs = (@args, "--dry-run", $src, $dst);
			system(@tArgs) == 0 or die "rsync exited with error code " . ($? >> 8) . "\n";
			print "OK? [y/N]: ";
			next unless (<STDIN> =~ /^[yY]/);
		}
		push(@args, $src, $dst);
		if ($debug){
			print join(" ", @args) . "\n";
		} else {
			system(@args) == 0 or die "rsync exited with error code " . ($? >> 8) . "\n";
			if ($updateLink && $latest ne ""){
				system("unlink $latest") == 0 or die "unlink failed with error code " . ($? >> 8) . "\n";
				system("ln -s $dst $latest") == 0 or die "ln failed with error code " . ($? >> 8) . "\n";
			}
		}
	}
}
close $conffile;
print "Backup complete\n";
