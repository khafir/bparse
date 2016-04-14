#!/usr/bin/perl -w
use strict;

if (!$ARGV[0]){print "\nUse: ./bparse.pl full_path_to_battleye_scripts_log_file\nex:  ./barse.pl /home/steam/steamcmd/arma3/battleye/scripts.log\n\n";exit;}
my $file = "$ARGV[0]";

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

my $clt = 0;


foreach my $line (@udat)
{
	my ($date,$user,$ip,$guid);
	my $pre = "";
	if ($ARGV[1])
	{
		if ($ARGV[1] =~ m/\-d.*d.*/i){($date,$user,$ip,$guid) = split(/,/,$udat[$line]);$pre = "$pre"."$date,";}
		if ($ARGV[1] =~ m/\-d.*i.*/i){($date,$user,$ip,$guid) = split(/,/,$udat[$line]);$pre = "$pre"."$ip,";}
		if ($ARGV[1] =~ m/\-d.*u.*/i){($date,$user,$ip,$guid) = split(/,/,$udat[$line]);$pre = "$pre"."$user,";}
		if ($ARGV[1] =~ m/\-d.*g.*/i){($date,$user,$ip,$guid) = split(/,/,$udat[$line]);$pre = "$pre"."$guid,";}
		if ($ARGV[1] =~ m/\-d.*a.*/i){($date,$user,$ip,$guid) = split(/,/,$udat[$line]);$pre = "$date,"."$ip,"."$user,"."$guid,";}
		$chopped[$clt] = "$pre"."$chopped[$clt]";
	}
	$clt++;
}

foreach (@chopped){print "$_\n";}
my $pct = scalar(@chopped);print "\nTotal Entries parsed from $file: $pct\n\n";