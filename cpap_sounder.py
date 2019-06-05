#!/usr/bin/perl
#
use strict;

print "kicking off after reboot:\n";

while (1)
{
  system ("AUDIODEV=hw:1 rec file_size.wav trim 0 600 2>/dev/null ");
  system ("gzip -f file_size.wav");
  my $size = `stat -c %s file_size.wav.gz`;
  chop $size;
  print "$size\n";
  # 10 minute file size on the low end when no sound(cpap going): 
  # 4217427
  if ( $size < 47612996 )
  {
    system ("AUDIODEV=hw:2 play Haydn_Adagio.mp3 > /dev/null 2>&1");
  }
}
