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

my @outcomes = (
    {name=>"succeeded", weight=>90},
    {name=>"failed", weight=>5},
    {name=>"required-retry", weight=>10},
    {name=>"timed-out", weight=>8}
);

my @gateways = (
    {name=>"PayPal", weight=>40},
    {name=>"Stripe", weight=>60}
);

sub pick_event {
    my $table = shift;

    my $total_weight = sum map {$_->{weight}} @$table;
    my $weighted_random = random_uniform_integer(1, 1, $total_weight);
    my $sum = 0;
    for (@$table) {
	$sum += $_->{weight};
	return $_ if $sum >= $weighted_random;
    }
    die "pick_event ran off end of list.  This can't happen";
}

while (1) {

    my $interval = random_exponential(1, $opt{rate});
    my $gateway  = pick_event(\@gateways)->{name};
    my $outcome = pick_event(\@outcomes)->{name};
    my $value = 10 + random_exponential(1, 10);

    my $msg = "$gateway transaction for \$$value $outcome";

    say "#delay $interval";
    sleep($interval);
    my ($secs, $usecs) = gettimeofday;
    my $timestamp = join '.',
	strftime("%F %T", gmtime($secs)),
	sprintf("%03d", $usecs/1000);

    say "$timestamp $msg";

}
