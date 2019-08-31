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
  # only sleep if this is the first reboot of the night
  system ("sleep 900");
}
{
  # sleep for 2 minutes to minimize chances of false alarm
  system ("sleep 120");
}

  # 10 minute file size on the low end when no sound(cpap going): 
  # 4217427
  # readings where the device was off my head but still pumping air(the ones that are over 6):
  # Filesize at Sat Aug 31 02:22:30 PDT 2019 : 51720078
  # Filesize at Sat Aug 31 02:33:00 PDT 2019 : 54556172
  # Filesize at Sat Aug 31 02:43:31 PDT 2019 : 61970413
  # Filesize at Sat Aug 31 02:54:01 PDT 2019 : 62153278
  # Filesize at Sat Aug 31 03:04:29 PDT 2019 : 63301149
  # Filesize at Sat Aug 31 03:14:58 PDT 2019 : 62941282
  # Filesize at Sat Aug 31 03:25:31 PDT 2019 : 62030976
  # Filesize at Sat Aug 31 03:36:00 PDT 2019 : 62584369
  # Filesize at Sat Aug 31 03:46:29 PDT 2019 : 62722421
  # Filesize at Sat Aug 31 03:57:03 PDT 2019 : 62665817
  # Filesize at Sat Aug 31 04:07:32 PDT 2019 : 62750951
  # Filesize at Sat Aug 31 04:18:01 PDT 2019 : 62739306
  # Filesize at Sat Aug 31 04:28:32 PDT 2019 : 62746465
  # Filesize at Sat Aug 31 04:39:05 PDT 2019 : 62777177
  # Filesize at Sat Aug 31 04:49:34 PDT 2019 : 62936930
  # Filesize at Sat Aug 31 05:00:03 PDT 2019 : 62506056
  # Filesize at Sat Aug 31 05:10:34 PDT 2019 : 55830901
  

while (1)
{
  system ("AUDIODEV=hw:1 rec file_size.wav trim 0 600 2>/dev/null ");
  system ("gzip --best -f file_size.wav");
  my $size = `stat -c %s file_size.wav.gz`;
  chop $size;
  $date = `date`;
  chop $date;
  print "Filesize at $date : $size\n";
  if ( $size < 42612996 )  
  {
    $date = `date`;
    chop $date;
    print "Playing song at $date size : $size\n";
    system ("AUDIODEV=hw:2 play Haydn_Adagio.mp3 > /dev/null 2>&1");
    print "Rebooting now at: $date size : $size to verify speaker is working\n";
    system ("pkill -9 play; sleep 120; shutdown -rf now");
  }
  elsif ( $size > 60000000 )  
  {
    $date = `date`;
    chop $date;
    print "Possibly off head but still pumping air: $date size : $size\n";
    system ("AUDIODEV=hw:2 play Haydn_Adagio.mp3 > /dev/null 2>&1");
    print "Rebooting now at: $date size : $size to verify speaker is working\n";
    system ("pkill -9 play; sleep 120; shutdown -rf now");
  }
}
