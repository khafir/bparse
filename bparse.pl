#!/usr/bin/perl -w
use strict;

if (!$ARGV[0]){print "\nUse: ./bparse.pl full_path_to_battleye_scripts_log_file\nex:  ./bparse.pl /home/steam/steamcmd/arma3/battleye/scripts.log\n\n";exit;}
my $file = "$ARGV[0]";chomp($file);

if (!-e $file)
{
	print "\n\%\% WARNING: $file does not exist!\n\%\% Verify that the filename you specified is valid.\n\n";exit;
}

my $str;
my (@parsed,@chopped,@udat);
my @raw = `cat $file`;
foreach (@raw)
{
	push @udat, "$1,$2,$3,$4" if ($_ =~ m/^(.*)\:\s+(.*)\s+\((.*)\)\s+(.*)\s+\-\s+\#/);
	if ($_ =~ m/\s(\#\d+)\s+(.*\")$/){chomp($_);push @parsed, "$1,$2";next;}
	if ($_ =~ m/\s(\#\d+)\s+(.*)$/){chomp($_);$str = "$1,$2";next;}
	if ($_ =~ m/^\n|\r$/)
	{
		$str = "$str".'\n';
	}
	else
	{
		chomp($_);$str = "$str".'\n'."$_";
	}
	if ($_ =~ m/\"$/){push @parsed, "$str";$str = "";}
}

my $ct = 0;
my $sct = scalar(@parsed);
foreach (@parsed)
{
	if ($_ =~ m/^\#\d+\,/)
	{
		if ($parsed[$ct+1] and $parsed[$ct+1] =~ m/^\#\d+\,/)
		{
			push @chopped, "$_";
		}
		elsif ($_ =~ m/^\#\d+\,/ and $ct+1 eq $sct)
		{
			push @chopped, "$_";
		}
		else
		{
			push @chopped, "$_"."$parsed[$ct+1]";
		}	
	}
	$ct++;
}

foreach (@chopped){$_=~ s/(\s+\\n)|(\t+\\n)/\\n/g;}

foreach (@chopped)
{
	if ($_ =~ m/^(\#\d+\,\")(.*)(\")$/)
	{
		my ($first,$second,$third) = ("$1","$2","$3");
		my $a = '"';
		my $b = '\"';
		$second =~ s/$a/$b/g;
		$_ = "$first"."$second"."$third";
	}
}

foreach (@chopped)
{
	if ($_ =~ m/^(\#\d+\,)(\".*\")$/)
	{
		my ($a,$b) = ("$1","$2");
		$_ = "$a".'!='."$b";
	}
}

my @unique;
my $leroy  = "null";
my $leroy1 = "null";
if($ARGV[1] and $ARGV[1] =~ m/\-d.*U.*/)
{
	my %seen =() ;
	@unique = grep { ! $seen{$_}++ } @chopped;

	my $clt = 1;
	print "\n";
	foreach (@unique){print "\[$clt\]  $_\n";$clt++;}
	my $uct = scalar(@unique);print "\nTotal Unique Entries parsed from $file: $uct\n\n";	
}
elsif($ARGV[1] =~ m/^\-d1337$/)
{
	until ($leroy =~ m/^1337$|^no$/i)
	{
		print "\%\% Confirm addition of all projected exceptions (1337/no): ";	
		$leroy = <STDIN>;chomp($leroy);
	}
	if ($leroy eq "1337")
	{
		until ($leroy1 =~ m/^1337$|^no$/i)
		{
			print "\%\% Confirm you really want to do this (1337/no): ";	
			$leroy1 = <STDIN>;chomp($leroy1);
		}	
		if ($leroy1 eq "1337")
		{
			print "\nTHIS FUNCTIONALITY NOT YET IMPLEMENTED!!!\n\n";exit;
		}
		else
		{
			print "\nVERY WISE CHOICE.\n\n";exit;
		}
	}
	else
	{
		print "\nWISE CHOICE.\n\n";exit;
	}
}
else
{
	foreach my $line (@udat)
	{
		my ($date,$user,$ip,$guid);
		my $pre = "";
		my $clt = 1;
		if ($ARGV[1])
		{
			if ($ARGV[1] =~ m/\-d.*d.*/){($date,$user,$ip,$guid) = split(/,/,$udat[$line]);$pre = "$pre"."$date,";}
			if ($ARGV[1] =~ m/\-d.*i.*/){($date,$user,$ip,$guid) = split(/,/,$udat[$line]);$pre = "$pre"."$ip,";}
			if ($ARGV[1] =~ m/\-d.*u.*/){($date,$user,$ip,$guid) = split(/,/,$udat[$line]);$pre = "$pre"."$user,";}
			if ($ARGV[1] =~ m/\-d.*g.*/){($date,$user,$ip,$guid) = split(/,/,$udat[$line]);$pre = "$pre"."$guid,";}
			if ($ARGV[1] =~ m/\-d.*a.*/){($date,$user,$ip,$guid) = split(/,/,$udat[$line]);$pre = "$date,"."$ip,"."$user,"."$guid,";}
			$chopped[$clt] = "$pre"."$chopped[$clt]";
		}
		$clt++;
	}
	my $clt = 1;
	print "\n";
	foreach (@chopped){print "\[$clt\]  $_\n";$clt++;}
	my $pct = scalar(@chopped);print "\nTotal Entries parsed from $file: $pct\n\n";
}

my $ucon = "null";
until ($ucon =~ m/^yes$|^no$/i)
{
	print "Do you wish to add suggested exceptions (yes/no): ";
	$ucon = <STDIN>;
}
if ($ucon =~ m/yes/i)
{
	my $slog = backup();
	print "Backup Location: $slog\n\n";
	my $umod = "null";
	print "\tOption 1:   Add ALL exceptions.\n\tOption 2:   Add SPECIFIC exception by reference ID.\n\tOption 3:   ABORT FILTER MODIFICATION!\n\n";
	until ($umod =~ m/^[0-4]$/)
	{
		print "Select one of the above options [1-3]: ";
		$umod = <STDIN>;chomp($umod);
	}
	if ($umod == 1)
	{
		print "\nYou have selected: Option 1:   Add ALL exceptions.\n\nTHIS FUNCTIONALITY NOT YET IMPLEMENTED!!!\n\n";
	}
	elsif($umod == 2)
	{
		print "\nYou have selected: Option 2:   Add SPECIFIC exception by reference ID.\n\nTHIS FUNCTIONALITY NOT YET IMPLEMENTED!!!\n\n";
	}
	elsif ($umod == 3)
	{
		print "\nYou have selected: Option 3:   ABORT FILTER MODIFICATION!\n\n";
	}
}
else
{
	print "Thank you for using BPARSE! Exiting...\n\n";
}

sub backup
{
	my $ubk = "";
	until ($ubk =~ m/^yes$|^no$/i)
	{
		print "Do you want to backup your battleye/scripts.txt (yes/no)?: ";
		$ubk = <STDIN>;
	}
	if ($ubk =~ m/^yes$/)
	{
		my $sfile = "null";
		until ($sfile ne "null")
		{
			print "Enter the direct path to your battleye/scripts.txt file: ";
			$sfile = <STDIN>;chomp($sfile);
			if (!-e $sfile)
			{
				print "\n\%\% WARNING: $sfile does not exist!\n\%\% Verify that the filename you specified is valid.\n\n";
				$sfile = "null";
			}
		}
		print "Backing up $sfile: ";
		my $dts = `date +\%m\%d\%Y_\%T`;chomp($dts);
		`cp $sfile $sfile.$dts.bkup`;		
		print "COMPLETE\n";
		return("$sfile".'.'."$dts".'.'."bkup");
	}
	else
	{
		print "\n\%\% WARNING: You have chosen not to backup your battleye filters!\n";
		return("WARN");
	}
}