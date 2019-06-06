#!/usr/bin/perl
#
use strict;


my $date = `date`;
chop $date;

print "\n\nkicking off after reboot at $date :\n";

while (1)
{
  system ("AUDIODEV=hw:1 rec file_size.wav trim 0 600 2>/dev/null ");
  system ("gzip -f file_size.wav");
  my $size = `stat -c %s file_size.wav.gz`;
  chop $size;
  $date = `date`;
  chop $date;
  print "Filesize at $date : $size\n";
  # 10 minute file size on the low end when no sound(cpap going): 
  # 4217427
  if ( $size < 47612996 )
  {
    $date = `date`;
    chop $date;
    print "Playing song at $date size : $size\n";
    system ("AUDIODEV=hw:2 play Haydn_Adagio.mp3 > /dev/null 2>&1");
    print "Rebooting now at: $date size : $size to verify speaker is working\n";
    system ("pkill -9 play; sleep 120; shutdown -rf now");
  }
}
