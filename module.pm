#!/usr/bin/perl

use warnings;
use strict;

package AlphaBot;

use base qw( Bot::BasicBot );
use LWP::Simple;
use Term::ANSIColor qw(:constants);
#use Module::Refresh;
#use utf8;
#use open IN => ':utf8';
#binmode STDOUT, ':utf8';

use module_overrides;
use module_said;
use module_methods;

#Module::Refresh->new;

1;
