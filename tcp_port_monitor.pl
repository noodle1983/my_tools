#!/usr/bin/perl
use Socket;

my @addresses = (
    [ "www.baidu.com", 80,],
);

my $date_str = "";
my $err_str = "";

while(true)
{
	$err_str = "";
	for $ip_port ( @addresses ) 
	{
		$err_str = test_address($$ip_port[0], $$ip_port[1]);
		break if length($err_str) > 0;
	}
	
	$date_str = `date "+%Y-%m-%d %H:%M:%S"`;
	chomp $date_str;
	if (length($err_str) > 0)
	{
		print "[$date_str] test failed! $err_str\n";
	}
	else
	{
		print "[$date_str] test success.\n";
	}
	
	`sleep 5`;
}

sub test_address
{
	my $remote  = shift or return "no ip!";
	my $port    = shift or return "no port!";

	$iaddr = inet_aton($remote) or return "Error[$remote:$port]: $!";
	$paddr = sockaddr_in($port, $iaddr) or return "Error[$remote:$port]: $!";
	$proto = getprotobyname('tcp') or return "Error[$remote:$port]: $!";
	
	socket(SOCK, PF_INET, SOCK_STREAM, $proto) or return "Error[$remote:$port]: $!";
	connect(SOCK, $paddr) or return "Error[$remote:$port]: $!";
	close(SOCK);
	
	return "";
}