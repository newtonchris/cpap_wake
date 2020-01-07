#!/usr/bin/perl
#
use strict;


my $date = `date`;
chop $date;

# number of files older than 120 minutes
my $find_count = `find /var/log/cpap_sounder.touch -cmin +120 -ls | wc -l`;
print "\n\nkicking off after reboot at $date :\n";
print "find_count = >$find_count<\n";
# replace any non digit with ""
$find_count =~ s/\D//g;
print "find_count = >$find_count<\n";
if ( $find_count < 1 )
{
  # sleep for 1 minute to minimize chances of false alarm
  print "sleeping for 1 minute before starting. This is not the first boot of the night\n";
  system ("sleep 60");
  system ("touch /var/log/cpap_sounder.touch");
}
else
{
  # only sleep if this is the first reboot of the night
  print "sleeping for 90 minutes before starting if this is the first start of the night\n";
  system ("sleep 5400");
  system ("touch /var/log/cpap_sounder.touch");
}

while (1)
{
  system ("touch /var/log/cpap_sounder.touch");
  system ("AUDIODEV=hw:1 rec file_size.wav trim 0 600 2>/dev/null ");
  system ("gzip --best -f file_size.wav");
  system ("ls -lh /home/pi/sound_in/file_size.wav.gz");
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
    system ("AUDIODEV=hw:2 play alarm1.mp3 > /dev/null 2>&1");
    system ("sleep 3");
    system ("AUDIODEV=hw:2 play alarm1.mp3 > /dev/null 2>&1");
    system ("sleep 3");
    system ("AUDIODEV=hw:2 play alarm1.mp3 > /dev/null 2>&1");
    system ("sleep 3");
    system ("AUDIODEV=hw:2 play alarm1.mp3 > /dev/null 2>&1");
    system ("sleep 3");
    system ("AUDIODEV=hw:2 play alarm1.mp3 > /dev/null 2>&1");
    system ("sleep 3");
    system ("AUDIODEV=hw:2 play alarm1.mp3 > /dev/null 2>&1");
    print "Playing song at $date size : $size\n";
    system ("sleep 30");
    system ("pkill -9 play");
    print "Rebooting now at: $date size : $size to verify speaker is working\n";
    system ("touch /var/log/cpap_sounder.touch; pkill -9 play; sleep 12; shutdown -rf now");
  }
  elsif ( $size > 69270320 )  
  {
    $date = `date`;
    chop $date;
    print "Possibly off head but still pumping air: $date size : $size\n";
    print "Playing song at $date size : $size\n";
    system ("AUDIODEV=hw:2 play alarm1.mp3 > /dev/null 2>&1");
    system ("AUDIODEV=hw:2 play alarm1.mp3 > /dev/null 2>&1");
    system ("AUDIODEV=hw:2 play alarm1.mp3 > /dev/null 2>&1");
    system ("AUDIODEV=hw:2 play alarm1.mp3 > /dev/null 2>&1");
    system ("sleep 30");
    system ("AUDIODEV=hw:2 play alarm1.mp3 > /dev/null 2>&1");
    system ("sleep 30");
    system ("AUDIODEV=hw:2 play alarm1.mp3 > /dev/null 2>&1");
    print "Playing song at $date size : $size\n";
    system ("sleep 30");
    system ("pkill -9 play");
    print "Rebooting now at: $date size : $size to verify speaker is working\n";
    system ("touch /var/log/cpap_sounder.touch; pkill -9 play; sleep 12; shutdown -rf now");
  }
}
