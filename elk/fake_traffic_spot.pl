#!/usr/bin/perl

use Modern::Perl;
use Math::Random qw(random_exponential random_uniform_integer);
use Getopt::Long;
use JSON;
use POSIX qw(strftime);
use Time::HiRes qw(gettimeofday);
use List::Util qw(sum);

$| = 1;
my %opt=(rate=>60);
GetOptions(\%opt, "rate|r=i");

my @stations = (
    {station=>"00102", weight=>10,
     name=>"93 Wolston Rd",  geoip=>{location=>{lat=>-27.569566, lon=>152.930895}}},
    {station=>"00103", weight=>15,
     name=>"1 Spine St",     geoip=>{location=>{lat=>-27.570308, lon=>152.937386}}},
    {station=>"00104", weight => 150,
     name=>"Western Fwy Witton Rd",     geoip=>{location=>{lat=>-27.506490, lon=>152.962882}}},
    {station=>"00105", weight=>100,
     name=>"Ipswich Mwy Bullockhead Ck",     geoip=>{location=>{lat=>-27.580044, lon=>152.937335}}},
    {station=>"00106", weight=>50,
     name=>"1 Sherwood Rd",     geoip=>{location=>{lat=>-27.541436, lon=>153.011596}}},
    );
my $total_weight = sum map {$_->{weight}} @stations;

sub pick_station {
    my $weighted_random = random_uniform_integer(1, 1, $total_weight);
    my $sum = 0;
    for (@stations) {
	$sum += $_->{weight};
	return $_ if $sum >= $weighted_random;
    }
    die "pick_station ran off end of list.  This can't happen";
}

while (1) {

    my $interval = random_exponential(1, $opt{rate});
    my $station  = pick_station();
    my $rego = join('-',
		    join('', random_uniform_integer(3, 0, 9)),
		    join('', map {chr(64+$_)} random_uniform_integer(3, 1, 26)));
    my $direction = random_uniform_integer(1, 0, 1);

    say "#delay $interval";
    sleep($interval);
    my ($secs, $usecs) = gettimeofday;
    my $timestamp = join '.',
	strftime("%F %T", gmtime($secs)),
	sprintf("%03d", $usecs/1000);

    my %spot = (event=>'spot',
		timestamp=>$timestamp,
		rego=>$rego,
		direction=>$direction,
		%$station,
	);
    delete $spot{weight};
    say encode_json(\%spot);
}
