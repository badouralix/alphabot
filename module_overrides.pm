#!/usr/bin/perl

use warnings;
use strict;

no warnings 'redefine';

use utf8;
binmode (STDOUT, ':utf8');

######################
# Quelques variables #
######################

# Version
my $version = 2.0;

# Maître du bot SavoirInutile
my $master = "AlphaBet";

# Paramètres de temps
my $refresh     = 60;   # répétition de la fonction tick
my $timer_max   = 59;   # un savoir inutile est écrit tout les refresh*(timer_max+1)
my $debut_h     = 9;    # heure de réveil
my $debut_m     = 0;    # minute de réveil
my $fin_h       = 21;   # heure de coucher
my $fin_m       = 0;    # minute de coucher

# Commandes
my @commandes = qw(<3 bonjour help insulte join kill ping quit up);
#my @commandes = qw(<3 bonjour help insulte ping quit tue reload up vdm);


####################################
# Overriding Bot::BasicBot methods #
####################################

our @ISA = ("Bot::BasicBot");


sub new 
{
    my ($class, %table) = @_;
    my $self = $class->SUPER::new(%table);
    $self->{timer} = 0;
    $self->{master} = $master;
    $self->{etat} = "UP";
    bless ($self, $class);
    return $self;
}


sub connected
{
    print "\nConnecté ! ( ".localtime()." )\n\n";
}


sub kicked
{
    my ($self, $hashref) = @_;
    
    if ( $hashref->{kicked} eq $self->{nick} )
    {
        $self->say(
            channel =>  $hashref->{channel},
            body    =>  $hashref->{who}.": c'est méchant de kicker les bots comme ça !",
        );
        
        print "J'ai été kické de ".$hashref->{channel}." par ".$hashref->{who}." ( raison : ".$hashref->{reason}." , date : ".localtime()." )\n";
#        $self->shutdown();
    }
}

sub tick 
{
    my ($self) = @_;
    my ($sec,$min,$heu) = localtime();
     
    # L'état est mis à jour en fonction de l'heure
    # TODO : faire le timecheck en fonction de l'état   
    if ( (($heu > $debut_h) || (($heu == $debut_h) && ($min >= $debut_m))) && (($heu < $fin_h) || (($heu <= $fin_h) && ($min < $fin_m))) )
    {
        $self->{etat} = "UP";
    }
    else
    {
        $self->{etat} = "DOWN";
    }
 
    if ( $self->{etat} eq "UP" )
    {
        if ( $self->{timer} == $timer_max )
        {
            $self->{timer} = 0;
            $self->ecrire($self->{main_channel});
        }
        else
        {
            $self->{timer}++;
        }
    }
    
    return $refresh;       
}


sub help
{
    my ($self,$hashref) = @_;
    
    $self->{timer} = 0;
     
    $self->say(
        channel =>  $hashref->{who},
        body    =>  "Je suis un bot qui sert à animer le chan ".$self->{main_channel}.".",
    );

    my $latence = $refresh * ( $timer_max + 1 );
    my $phrase =  "Quand personne ne parle pendant ";
    if ( int($latence / 3600) != 0 ){ $phrase .= int($latence / 3600)."h"; }
    if ( int($latence / 60) - int($latence / 3600)*60 != 0 ){ $phrase .= int($latence / 60) - int($latence / 3600)*60 ."m"; }
    if ( $latence - 60*int($latence /60) != 0 ){ $phrase .= ($latence-60*int($latence / 60))."s"; }
    $phrase .= ", je vous apprends un savoir inutile.";

    $self->say(
        channel =>  $hashref->{who},
        body    =>  $phrase,
    );

    $phrase = "Mais entre ";
    if ( $fin_h <= 9 ) { $phrase .= "0"; }
    $phrase .= $fin_h."h";
    if ( $fin_m <= 9 ) { $phrase .= "0"; }
    $phrase .= $fin_m." et ";
    if ( $debut_h <= 9 ) { $phrase .= "0"; }
    $phrase .= $debut_h."h";
    if ( $debut_m <= 9 ) { $phrase .= "0"; }
    $phrase .= $debut_m." je dors.";
 
    $self->say(
        channel =>  $hashref->{who},
        body    =>  $phrase." ( Actuellement, je suis ".$self->{etat}." ! )",
    );

#    $self->say(
#        channel =>  $hashref->{who},
#        body    =>  "Actuellement, je suis ".$self->{etat}.".",
#    );

    $self->say(
        channel =>  $hashref->{who},
        body    =>  "Je ne réponds qu'aux ordres de mon maître, qui est ".$self->{master}.".",
    );
    
    $phrase = "Mes commandes sont : ";
    foreach my $commande (@commandes)
    {
        $phrase .= $commande." , ";        
    }
    $phrase =~ s/ , $//;

    $self->say(
        channel =>  $hashref->{who},
        body    =>  $phrase,
    );
}

#sub join
#{
#    my ($self, $chan) = @_;
#    print localtime()." : join $chan\n";
#}

1;
