#!/usr/bin/perl
#
use strict;


my $date = `date`;
chop $date;

# number of files older than 120 minutes
my $ls1 = `ls -lt /var/log/cpap_sounder.touch`;
chop $ls1;
my $date1 = `date`;
chop $date1;
my $find_count = `find /var/log/cpap_sounder.touch -cmin +120 -ls | wc -l`;
chop $find_count;
# replace any non digit with ""
$find_count =~ s/\D//g;


print "\n\nkicking off after reboot at $date1 :\n";
print ">$ls1<\n";
print ">$find_count<\n\n";
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
  system ("AUDIODEV=hw:1 rec file_size.wav trim 0 600 > /dev/null 2>&1 ");
  system ("gzip --best -f file_size.wav");
  #system ("ls -l /home/pi/sound_in/file_size.wav.gz");
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
    my $return_value = play_song(10,60);
    next if ( $return_value eq 1 );
    print "Rebooting now at: $date size : $size to verify speaker is working\n";
    system ("touch /var/log/cpap_sounder.touch; pkill -9 play; sleep 12; shutdown -rf now");
  }
  elsif ( $size > 69270320 )  
  {
    $date = `date`;
    chop $date;
    print "Possibly off head but still pumping air: $date size : $size\n";
    my $return_value = play_song(10,60);
    next if ( $return_value eq 1 );
    print "Rebooting now at: $date size : $size to verify speaker is working\n";
    system ("touch /var/log/cpap_sounder.touch; pkill -9 play; sleep 12; shutdown -rf now");
  }
}

sub play_song
{
  my ($times_to_play,$seconds_between_play) = @_;
  my $count = 1;
  while ($count < $times_to_play)
  {
    my $date = `date`;
    chop $date;
    print "Playing song time # $count at $date\n";
    system ("AUDIODEV=hw:2 play alarm1.mp3 > /dev/null 2>&1");
    system ("sleep 10");
    # record $seconds_between_play of audio and check if cpap is back on
    system ("AUDIODEV=hw:1 rec small_file_size.wav trim 0 $seconds_between_play > /dev/null 2>&1 ");
    system ("gzip --best -f small_file_size.wav");
    my $size = `stat -c %s file_size.wav.gz`;
    chop $size;
    $count++;
    my $file_size_calculated = 42612996 * ($seconds_between_play / 60 / 10);
    print "$date: Small file size: $size seconds_between_play:$seconds_between_play file_size_calculated: $file_size_calculated\n";

    if ( $size < $file_size_calculated )  
    {
      # Will next out of while above if cpap is back on to save the reboot
      # This makes it so we don't have to turn off/on the rasberry pi
      return 1;
    }
  }
  return 0;
}
