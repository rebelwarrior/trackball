#!/usr/bin/env ruby

###########################################
## Pick the file you want to write below ##
###########################################


#How do I get tempdirectory?? 
tempdirectory = "/tmp"

=begin
###########################################
#Puts Small Left Button as Middle
#     Right Left Buttton as Scroll
###########################################
default_text = <<EOM
Section "InputClass" 
  Identifier      "Marble Mouse" 
  MatchProduct    "Logitech USB Trackball" 
  MatchIsPointer  "on" 
  MatchDevicePath "/dev/input/event*" 
  Driver          "evdev" 
  Option          "SendCoreEvents" "true"
# Physical buttons come from the mouse as: 
# Big: 13
# Small: 8 9
# This makes left small button (8) into the middle, 
# and puts scrolling on the right small button (9).
  Option "Buttons"             "9" 
  Option "ButtonMapping"       "1 8 3 4 5 6 7 2 9" 
  Option "EmulateWheel"        "true"
  Option "EmulateWheelButton"  "9"
  Option "YAxisMapping"        "4 5"
  Option "XAxisMapping"        "6 7"
EndSection
EOM
=end
=begin
###########################################
#Puts Small Left Button as Middle, hold to Scroll
#     Right Left Buttton as Forward
###########################################
default_text = <<EOM
Section "InputClass" 
  Identifier      "Marble Mouse" 
  MatchProduct    "Logitech USB Trackball" 
  MatchIsPointer  "on" 
  MatchDevicePath "/dev/input/event*" 
  Driver          "evdev" 
  # Option          "SendCoreEvents" "true"
  # Option "Buttons"             "8" 
  Option "ButtonMapping"       "1 8 3 4 5 6 7 2 9" 
  Option "EmulateWheel"        "true"
  Option "EmulateWheelButton"  "8"
  Option "YAxisMapping"        "4 5"
  Option "XAxisMapping"        "6 7"
  Option "Emulate3Buttons" "true"
EndSection
EOM
=end
=begin
###########################################
#Puts Small Left Button as 
#     Right Left Buttton as 
###########################################
default_text = <<EOM
Section "InputClass"
  Identifier "Marble Mouse"
  MatchProduct "Logitech USB Trackball"
  MatchIsPointer "on"
  MatchDevicePath "/dev/input/event*"
  Driver "evdev"
  Option "ButtonMapping" "1 2 3 4 5 6 7 8 9"
  Option "EmulateWheel" "true"
  Option "EmulateWheelButton" "8"
  Option "ZAxisMapping" "4 5"
  Option "XAxisMapping" "6 7"
  Option "Emulate3Buttons" "true"
EndSection
EOM
=end

default_text = <<EOM
Section "InputClass" 
  Identifier      "Marble Mouse" 
  MatchProduct    "Logitech USB Trackball" 
  MatchIsPointer  "on" 
  MatchDevicePath "/dev/input/event*" 
  Driver          "evdev" 
  # Option          "SendCoreEvents" "true"
  Option "Buttons"             "9" 
  Option "ButtonMapping"       "1 8 3 4 5 6 7 2 9" 
  Option "EmulateWheel"        "true"
  Option "EmulateWheelButton"  "8"
  Option "YAxisMapping"        "4 5"
  Option "XAxisMapping"        "6 7"
  Option "Emulate3Buttons" "true"
EndSection
EOM

zombie =  `locate xorg.conf.d | grep d$`
zombie.chomp! #BRAINS!!

#How do I get tempdirectory?? 
tempdirectory = "/tmp"

f = File.new((tempdirectory + "/50-marblemouse.conf"), "w")
f.puts default_text
f.close

puts `echo #{zombie}`

if FileTest.exists?(zombie + "/50-marblemouse.conf")
	File.open((zombie + "/50-marblemouse.conf"), 'r') do |file|
     #this block is not iterating (confusing!) only opening the file
     if (file.read  =~ /Section\s*\"InputClass\"/i) 
      @dont_append = true
     end
	end
 
	if @dont_append
		puts "Manual Action needed. \nTrackball config file exists with an Input Class already defined. \nOverwrite existing file? WARNING you may loose data! (Y/N)"
		overwrite = gets
		if (overwrite.to_s =~ /y/i) 
			puts "Overwriting existing Trackball conf file."
			puts `sudo cp /tmp/50-marblemouse.conf #{zombie}/50-marblemouse.conf`
		else
			puts "Generated Config file is at /tmp/50-marblemouse.conf existing config file is at #{zombie}."
		end	
	else 
		puts "Trackball Conf file exits but doesn't contain Input Class.\nAppending Input Class to config file." 
    #Hail Seitan! 666 -- Won't cat the file without it.
    puts `sudo chmod 666 #{zombie + "/50-marblemouse.conf"}`
		puts `sudo cat #{tempdirectory + "/50-marblemouse.conf"} >> #{zombie + "/50-marblemouse.conf"}` 
    puts `sudo chmod 644 #{zombie + "/50-marblemouse.conf"}`
	end
	
else
	puts "Config file doesn't exist. Creating one."
  puts `sudo cp /tmp/50-marblemouse.conf #{zombie}/50-marblemouse.conf`
end


#puts `sudo cp /tmp/50-marblemouse.conf #{zombie}/50-marblemouse.conf` 

#else open marblemouse.conf check for section input and add new txt
# try using append. How do I so a sudo write though?
# `sudo echo '#{text}' >> #{zombie}/filename.txt`
# is there a way of loading the contents of txt to clipboard and open the file on text editor.
#else puts "file is already there overwrite? (Y/N)" gets etc.


