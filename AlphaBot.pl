#!/usr/bin/perl

use strict;
use warnings;

use module;

# Configuration de la connexion (serveur, login, channel)

my $server = 'irc.viarmonie.via.ecp.fr';
my $nick = 'AlphaBot';
my $main_channel = '#p2017-2018';
my @channels = ( '#p2016-2017' , '#p2018', '#p2017-2018' ); #, '#savoir-inutile' ); #, '#test-bot' );
my $ircname = 'alphabot';
my $username = 'Bot d\'AlphaBet';
my $quit_message = "Bon, c'est nul ici... Je me casse !";

my $bot = AlphaBot->new(
    server          =>  $server,
    port            =>  "6697",
    ssl             =>  1,

    channels        =>  [ @channels ],
    main_channel    =>  $main_channel,

    nick            =>  $nick,
    alt_nicks       =>  [ "SavoirInutile" ],
    username        =>  $ircname,
    name            =>  $username,

    quit_message    =>  $quit_message,
);

$bot->run();

