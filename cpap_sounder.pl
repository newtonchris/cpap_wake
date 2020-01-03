#!/usr/bin/perl
#
use strict;


my $date = `date`;
chop $date;

print "\n\nkicking off after reboot at $date :\n";
print "sleeping for 15 minutes before starting if this is the first start of the night\n";
my $find_count = `find /var/log/cpap_sounder.log -cmin -110 -ls| wc -l`;
if ( $find_count eq 1 )
{
  # sleep for 1 minute to minimize chances of false alarm
  system ("sleep 60");
}
else
{
  # only sleep if this is the first reboot of the night
  system ("sleep 5400");
}

while (1)
{
  system ("AUDIODEV=hw:1 rec file_size.wav trim 0 600 2>/dev/null ");
  system ("gzip --best -f file_size.wav");
  system ("ls -alt /home/pi/sound_in/file_size.wav.gz");
  my $size = `stat -c %s file_size.wav.gz`;
  chop $size;
  $date = `date`;
  chop $date;
  print "Filesize at $date : $size\n";
  if ( $size < 42612996 )  
  #if ( $size < 25306498 )
  {
    $date = `date`;
    chop $date;
    print "Playing song at $date size : $size\n";
    system ("AUDIODEV=hw:2 play bigmikeydread_2013-05-27T11_25_52-07_00.mp3& > /dev/null 2>&1");
    print "Playing song at $date size : $size\n";
    system ("sleep 30");
    system ("pkill -9 play");
    #system ("AUDIODEV=hw:2 play Haydn_Adagio.mp3 > /dev/null 2>&1");
    #print "Playing song at $date size : $size\n";
    #system ("AUDIODEV=hw:2 play Haydn_Adagio.mp3 > /dev/null 2>&1");
    #print "Playing song at $date size : $size\n";
    #system ("AUDIODEV=hw:2 play Haydn_Adagio.mp3 > /dev/null 2>&1");
    #system ("sleep 90");
    #system ("pkill -9 play");
    print "Rebooting now at: $date size : $size to verify speaker is working\n";
    system ("pkill -9 play; sleep 12; shutdown -rf now");
  }
  elsif ( $size > 9960000000 )  
  #elsif ( $size > 4980000000 )  
  {
    $date = `date`;
    chop $date;
    print "Possibly off head but still pumping air: $date size : $size\n";
    print "Playing song at $date size : $size\n";
    system ("AUDIODEV=hw:2 play bigmikeydread_2013-05-27T11_25_52-07_00.mp3& > /dev/null 2>&1");
    print "Playing song at $date size : $size\n";
    system ("sleep 30");
    system ("pkill -9 play");
    #system ("AUDIODEV=hw:2 play Haydn_Adagio.mp3 > /dev/null 2>&1");
    #print "Playing song at $date size : $size\n";
    #system ("AUDIODEV=hw:2 play Haydn_Adagio.mp3 > /dev/null 2>&1");
    #system ("sleep 60");
    #system ("pkill -9 play");
    print "Rebooting now at: $date size : $size to verify speaker is working\n";
    system ("pkill -9 play; sleep 12; shutdown -rf now");
  }
}
