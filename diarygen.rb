#! /usr/bin/env ruby
# -*- encoding : utf-8 -*-

require 'date'
require 'optparse'

options = {}

opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: diarygen.rb  [OPTIONS]"
  opt.separator  "Script generate sequence of tex strings according to days of calendar for including to calender.tex, after generating table it's possible to make pdf file for printing."
  opt.separator  ""
  opt.separator  "Options"

  opt.on("-s","--startdate  yyyy-mm-dd","First date creating calendar from") do |startdate|
    options[:d] = Date.parse(startdate) 
  end

  opt.on("-f","--finishdate yyyy-mm-dd","Last date creating calendar to") do |finishdate|
    options[:stopdate] = Date.parse(finishdate) 
  end

  opt.on("-w","--weekonpage","Include week on page sheet") do
    options[:weekonpage] = true
  end

  opt.on("-h","--help","help") do
    puts opt_parser
	abort
  end

end

opt_parser.parse!

#Parsing and validate arguments
d = options[:d]
d||= Date.today

stopdate = options[:stopdate]
stopdate||= Date.today + 30

weekonpage = options[:weekonpage]
weekonpage ||= false

raise  'First date must be previous the last datefinishdate' if d > stopdate 

#Define monthes of year starting on january
moy = %w(января февраля марта апреля мая июня июля августа сентября октября ноября декабря)
#Define days of week starting on monday
dow = %w(пн вт ср чт пт сб вс)

while d < stopdate do 

	#Making sequnce for week on page
	if d.wday == 1 and weekonpage then

		puts "%Week on page"
		print "\\weekonpage"

		wd = d 

		for i in 0..6 do 
			print "{",wd.mday," ",moy[wd.mon-1],", ",dow[wd.wday-1],"}"
			wd += 1
		end

		puts "\n%End of week on page\n\n"

	end
	
	#Making sequence fo schedule and sequence list
	if d.wday < 6 then
		day_hash = {:week_number => d.cweek, :day => d.mday, :dow => dow[d.wday-1], :moy => moy[d.mon-1]}
		print "\\ttable{\\#",day_hash[:week_number],"}\n"
		print "\\todolist{",day_hash[:day],"}{",day_hash[:moy],"}{",day_hash[:dow],"}\n"
	else
		#Pairing weekend days 
		dd = d+1

		#If month changed on weekend truncating and pairing monthnames
		if d.mon != dd.mon then
			month = moy[d.mon-1][0..2] + "-" + moy[dd.mon-1][0..2]
		else
			month = moy[d.mon-1]
		end

		day_hash = {
			:week_number => d.cweek, 
			:day => d.mday.to_s + "-" + dd.mday.to_s, 
			:dow => dow[d.wday-1] + "-" + dow[dd.wday-1], 
			:moy => month
		}

		print "\\ttable{\\#",day_hash[:week_number],"}\n"
		print "\\todolistwe{",day_hash[:day],"}{",day_hash[:moy],"}{",day_hash[:dow],"}\n\n"

		d += 1
	end

	d += 1
end

