#!/usr/bin/perl

my $supervisor_dir = $ARGV[0] || "/etc/ProcessorSupervisor/";

chdir($supervisor_dir) or die "Cannot change directory to $supervisor_dir: $!";
my @command_files = glob "*.command";
if (@command_files == 0) {
    die "No .command files found in $supervisor_dir. Exiting.\n";
}

print "start with supervisor dir: $supervisor_dir\n";
my $file_counter = 0;
my %processed_files = ();
my %last_start_time = ();
while (1)
{
    while (<glob "*.command">)
    {
        my $file = $_;
        next if ($file eq ".");
        next if ($file eq "..");
        next unless ($file =~ /.*\.command/);

        checkProcessor($file);
    }
    print "#";
    flush STDOUT;
    sleep(1);
}

sub get_timestamp {
    my ($sec, $min, $hour, $mday, $mon, $year) = localtime();
    return sprintf("%04d-%02d-%02d %02d:%02d:%02d", 
                   $year + 1900, $mon + 1, $mday, $hour, $min, $sec);
}

sub checkProcessor
{
    my $file = shift;
    return 0 unless $file;

    my $proc_name = $file;
    $proc_name =~ s/\.command//;

    (my $checkCmd, my $startCmd, my $starttime) = parseCommand($file);
    die "Error: checkCmd or startCmd not found in $file" unless ($checkCmd && $startCmd);

     $starttime //= 5;
    if (!$processed_files{$file}) {
        print "File: $file\n";
        print "  checkCmd: $checkCmd\n";
        print "  startCmd: $startCmd\n";
        print "  starttime: $starttime s\n";
        $processed_files{$file} = 1;
    }
    if (exists $last_start_time{$file} && (time() - $last_start_time{$file}) <= $starttime) {
        return;
    }

    `$checkCmd`;
    print ".";

    my $result = $?;
    if ($result != 0)
    {
        my $timestamp = get_timestamp();
        print "\n[$timestamp] $proc_name is down, restart it with cmd: $startCmd\n";
        system("$startCmd &");
        $last_start_time{$file} = time();
    }
}

sub parseCommand
{
    my $file = shift;
    return unless $file;

    my $checkCmd;
    my $startCmd;
    my $starttime;

    open FILE_HANDLE, " < $file" or return;
    while(<FILE_HANDLE>)
    {
        my $line = $_;
        chomp $line;

        if ($line =~ /^check:(.*)$/)
        {
            $checkCmd = $1;
            next;
        }
        if ($line =~ /^start:(.*)$/)
        {
            $startCmd = $1;
            next;
        }
        if ($line =~ /^starttime:(.*)$/)
        {
            $starttime = $1;
            next;
        }
    }
    close FILE_HANDLE;

    $file_counter++;
    return ($checkCmd, $startCmd, $starttime);
}
