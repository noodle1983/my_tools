#!/usr/bin/perl

my $dev = "vdb";
my $check_percentage = 98;
my $old_util = 0;
my $util = 0;

while(true)
{
    $util = stat_io();
    if ($old_util > $check_percentage and $util > $check_percentage)
    {
        `iotop -btq --iter=3 | head -20 >> \`date "+%Y%m%d%H%M"\`_iotop.log`;
        $util = 0;
        $old_util = 0;
    }
    $old_util = $util;
    `sleep 2`;
}

sub stat_io
{
    my @iostat_text = `./iostat -x 1 2|tail -9`;
    my $date_str = `date "+%Y%m%d-%H%M%S"`;
    chomp($date_str);

    foreach $line(@iostat_text)
    {
        next if not $line =~ /$dev.*\s([0-9.]+)$/;
	my $util = $1;

	$line =~ s/ +/ /g;
	print("$date_str $util $line");
        return $util + 0.0;
    }
}

