#!/usr/bin/perl
#
use strict;


my $date = `date`;
chop $date;

print "\n\nkicking off after reboot at $date :\n";

while (1)
{
  print "here1\n";
  system ("AUDIODEV=hw:1 rec file_size.wav trim 0 6 2>/dev/null ");
  system ("gzip -f file_size.wav");
  my $size = `stat -c %s file_size.wav.gz`;
  print "here2\n";
  chop $size;
  $date = `date`;
  chop $date;
  print "Filesize at $date : $size\n";
  # 10 minute file size on the low end when no sound(cpap going): 
  # 4217427
  print "here3\n";
  if ( $size < 47612996 )
  {
    $date = `date`;
    chop $date;
    print "Playing song at $date size : $size\n";
    #system ("AUDIODEV=hw:2 play Haydn_Adagio.mp3 > /dev/null 2>&1");
  }
}
