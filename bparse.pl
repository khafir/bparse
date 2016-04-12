#!/usr/bin/perl -w
use strict;

if (!$ARGV[0]){print "\nUse: ./bparse.pl full_path_to_battleye_scripts_log_file\nex:  ./barse.pl /home/steam/steamcmd/arma3/battleye/scripts.log\n\n";exit;}
my $file = "$ARGV[0]";

my $str;
my (@parsed,@chopped);
my @raw = `cat $file`;
foreach (@raw)
{
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

foreach (@chopped){$_=~ s/\s+|\t+\\n/\\n/g;}

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

foreach (@chopped){print "$_\n";}
my $pct = scalar(@chopped);print "\nTotal Entries parsed from $file: $pct\n\n";

