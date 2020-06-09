#!/usr/bin/perl

use strict;
use warnings;
no warnings 'redefine';

use utf8;
use open IN => ':utf8';


#################################
# Méthodes spéciales à AlphaBot #
#################################

sub ecrire 
{
    my ($self, $chan) = @_;
    my $source = get('http://www.savoir-inutile.com'); # or die "Erreur d'acquisition";
    
    if ( ($source =~ /.*id=\"phrase\".*\">(.*)<.*/) && utf8::valid($1) )
    {  
        my $truc = $1;
        $truc =~ s/<(\/)?u>//g;
        $self->notice(
            channel =>  $chan,
            body    =>  BOLD.BLUE."Le saviez-vous ? ".RESET.$truc,
        );
    }
}


sub insulter
{
    my ($self, $destinataire, $chan) = @_;
    my @liste_fichiers = ("aperitif", "potage", "entree", "plat", "salade", "fromage", "entremets", "dessert", "digestif");
    
    my $insulte = "";
    foreach (@liste_fichiers)
    {
        my $nombre_lignes = 0;
        my @liste_lignes = ();
        
        open (my $fichier, '<', "insultron/".$_);
        while ( <$fichier> =~ /^(.*)\n$/ )
        {
            push(@liste_lignes, $1);
        }
        close $fichier;
        
        my $bout = $liste_lignes[ int(rand($#liste_lignes+1)) ];
        if ( ($insulte =~ / (qu|d)e $/) && ($bout =~ /^[aeiouy]/) ) { $insulte =~ s/..$/'/s }
        $insulte .= $bout;

        if ( $_ eq "entree" ){ $insulte .= ","; }
        elsif ( ($_ eq "fromage") || ($_ eq "digestif") ) { $insulte .= " !"; }
        $insulte .= " ";        
    }
    
    $self->say(
        channel => $chan,
        body    => $destinataire.": ".$insulte,
    );        
}



1;
