#!/usr/bin/env perl
use Mojo::Base -strict;

# use local lib (if Contenticious isn't installed)
BEGIN {
    use File::Basename 'dirname';
    my $dir = dirname(__FILE__);
    unshift @INC, "$dir/lib", "$dir/../lib";
}

use lib 'lib';
use Lotus;
#use Contenticious;
use Contenticious::Commands;
use Mojolicious::Commands;

# use Contenticious
$ENV{MOJO_HOME} = dirname(__FILE__);
my $app = Lotus->new;

# Contenticious dump command
if (defined $ARGV[0] and $ARGV[0] eq 'dump') {
    Contenticious::Commands->new(app => $app)->dump;
}

# use Contenticious as mojo app
else {
    $ENV{MOJO_APP} = $app;
    Mojolicious::Commands->start;
}
