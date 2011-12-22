#!/usr/bin/perl
use strict;
use Calendar::Simple;
use Data::Dumper;
use utf8;
binmode STDOUT, ":utf8";

my $month_start = shift || 1;
my $month_finish = shift || 12;
my $year = shift ||  2012;

if (($month_start > 12) or ($month_finish > 12) or ($month_start > $month_finish)) {die "Wrong month range!\n\n"};

#Create month range array
my @month_range = ($month_start..$month_finish);

my @MonthsOfYear = qw(января февраля марта апреля мая июня июля августа сентября октября ноября декабря);
#my @MonthsOfYear = qw(январь февраль март апрель май июнь июль август сентябрь октябрь ноябрь декабрь);
my @DaysOfWeek = qw(вс пн вт ср чт пт сб);
#my @DaysOfWeek = qw(Вс Пн Вт Ср Чт Пт Сб);

my @sat;
my $weekday=0;

foreach my $m(@month_range){
	my @month = calendar($m, $year);    
	foreach (@month) {
		foreach (@$_){
			if (!$_ eq undef) {
				my $dom = $_;
				my $dow = @DaysOfWeek[$weekday];
				my $moy = @MonthsOfYear[$m-1];
				print "\\ttable\n" if !($weekday == 6);
				#Weekdays on every page
				print "\\todolist{$dom}{$moy}{$dow}" if (($weekday > 0) && ($weekday < 6));


				#Weekend days two on single page and according to special template
				#Cheking saturday and store data till sunday
				if ($weekday == 6){
					@sat = ($dom, $moy, $dow) 
				}

				#Cheking sunday 
				if ($weekday == 0){
					#Chek if month change is on weekend
					if ((@sat[1] eq $moy) or (@sat[1] eq undef)){
						print "\\todolistwe{$dom}{$moy}{$dow}" if (@sat[1] eq undef);
						print "\\todolistwe{@sat[0]-$dom}{$moy}{@sat[2]-$dow}" if (@sat[1] ne undef);
					} else {
						my $combmonth = substr(@sat[1],0,3)."-".substr($moy,0,3);
						print "\\todolistwe{@sat[0]-$dom}{$combmonth}{@sat[2]-$dow}";
					}
				}
				print "\n";
				$weekday++;
				$weekday=0 if $weekday == 7;
			}
		}
	}
}


