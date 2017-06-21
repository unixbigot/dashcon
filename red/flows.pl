#!/usr/bin/perl
use autodie;
use Modern::Perl;
use Spawn::Safe;
use File::Slurp qw(read_file write_file); 
use JSON;
use URI::Escape;

# Read in the flow configuration file and interpet it as JSON
#
my $codec = JSON->new->canonical(1);
my $input = $ARGV[0]//'flows.json';
my $json = $codec->decode(read_file $input);


#
# Iterate over the nodes looking for function nodes, and write
# the function body to a seperate file, which we pretty-print
#
system("rm -rf functions ; mkdir functions");
for my $node (@$json) {
    if ($node->{type} eq 'function') {
       my $jsname = sprintf "functions/%s.js", uri_escape $node->{name};
       write_file $jsname, map {"$_\n"} split(/\\n/, $node->{func});
       say spawn_safe(argv=>['prettier', '--write', $jsname])->{stdout};
    }			    
}

#
# Write the pretty-printed JSON to a new file
#
write_file $input."-pretty", $codec->pretty->encode($json);

exit 0;