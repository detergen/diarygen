#!/usr/bin/perl
#!/usr/bin/perl
use strict;
use Calendar::Simple;
use Date::Calc qw(Week_of_Year Day_of_Week);
use Data::Dumper;
use utf8;

	my @month = calendar(2,2012);    
	#print Dumper(@month)

	foreach (@month) {
		foreach (@$_){
			print "Day # $_";
			print " dow=";
			print Day_of_Week(2012,2,$_) if defined $_;
			print "\n";
		}
	}
