#!/usr/bin/perl

use warnings;
use strict;

no warnings 'redefine';

use utf8;
#use Module::Refresh;


sub said 
{
    my ($self, $message) = @_;
    
    if ($message->{channel} eq $self->{main_channel})
    {
        $self->{timer} = 0;
    }


### si le message est adressé au bot
    if ((defined $message->{address}) && ($message->{address} eq $self->{nick}))
    {

####### liste de réponses communes au maître et au quidam
        if ($message->{body} eq "ping")
        {
            $self->say(
                channel =>  $message->{channel},
                body    =>  $message->{who}.": pong",
            );
        }
        elsif ($message->{body} =~ /\bb(on|i|y)?(j(ou)?|s(oi)?)r/oi)
        {
            my ($sec,$min,$heu) = localtime();

            my $phrase = $message->{who}.": ";
            if ( $heu < 18 ){ $phrase .= "Bonjour"; }
            else { $phrase .= "Bonsoir"; }
            $phrase .= " ! Comment vas-tu ?";

            $self->say(
                channel =>  $message->{channel},
                body    =>  $phrase,
            );
        }
        elsif ($message->{body} =~ /coucou(e)?/i)
        {
            $self->say(
                channel =>  $message->{channel},
                body    =>  $message->{who}.": coucou",
            );
        }
        elsif ($message->{body} eq "up")
        {
            $self->ecrire($message->{channel});
        }
        elsif ($message->{body} =~ /^insulte( $self->{nick})?$/)
        {
            $self->insulter($message->{who});
        }
        elsif ($message->{body} =~ /^insulte (.*)/)
        {
            $self->insulter($1, $message->{channel});
        }
        elsif ($message->{body} =~ /^(tue|kill)( $self->{nick})?$/)
        {
            $self->insulter($message->{who}, $message->{channel});
        }
        elsif ($message->{body} =~ /^(tue|kill) (.*)/)
        {
            $self->say(
                channel =>  $message->{channel},
                body    =>  $1.": *PAN*",
            );
#            if ( $1 ne $self->{master} )
#            {
#                $self->kick( "$message->{channel}", "$1", "désomeuf, tu ne plaisais pas à $message->{who}" );
#            }
        }
        elsif ($message->{body} =~ /^join/)
        {
            $self->join("#test-bot");
        }
        
        
        
####### si le message est du maître et adressé au bot
        elsif ( $message->{who} eq $self->{master} )
        {
            if ($message->{body} eq "quit")
            {
                if ($message->{channel} eq $self->{main_channel}) { $self->shutdown( $self->quit_message() ); }
                else { $self->part($message->{channel}, $self->qui_message()); }
            }
            elsif ($message->{body} =~ /^reload/)
            {
                if ( $message->{body} eq "reload *" )
                {
                    delete $INC{'module_overrides.pm'};
                    require module_overrides;
                }
                
                delete $INC{'module_said.pm'};
                require module_said;
 
                delete $INC{'module_methods.pm'};
                require module_methods;
                
                $self->emote(
                    channel =>  $message->{channel},
                    body    =>  "a été mis à jour",
                );

                print localtime()." : mise à jour\n";
            }
            elsif ( ($message->{body} eq "<3") || ($message->{body} eq "E>") )
            {
                $self->say(
                    channel =>  $message->{channel},
                    body    =>  $message->{who}.": ".$message->{body},
                );
            }
            else
            {
                $self->say(
                    channel =>  $message->{channel},
                    body    =>  $message->{who}.": <3",
                );
            }
        }
        
####### si le message est d'un quidam et adressé au bot
        else
        { 
            if ( ($message->{body} eq "<3") || ($message->{body} eq "E>") )
            {
                my $phrase = $message->{who}.": ";
                if ( $message->{who} eq "Manu" || $message->{who} eq "Arth" )
                {
                    $phrase .= "pucelle, va !";
                }
                else
                {
                    $phrase .= "puceau, va !";
                }

                $self->say(
                    channel =>  $message->{channel},
                    body    =>  $phrase,
                );
            }    
            elsif (($message->{body} eq "quit") || ($message->{body} eq "reload"))
            {
                $self->say(
                    channel =>  $message->{channel},
                    body    =>  $message->{who}.": désomeuf, tu n'es pas mon maître",
                );
            }
            else
            {
                $self->say(
                    channel =>  $message->{channel},
                    body    =>  $message->{who}.": retourne t'acheter une vie IRL au lieu de discuter avec un bot, espèce d'asocial !",
                );
            }
        }
    }
    

### si le message n'est pas adressé au bot
    elsif ((defined $message->{address}) && ($message->{address} =~ /$self->{nick}/i) )
    {
        $self->say(
            channel =>  $message->{channel},
            body    =>  $message->{who}.": je m'appelle ".$self->{nick}." !",
        );
    }


    else    
    {
        if ( $message->{body} =~ /(H[AEIOU][! ]*){3}/io )
        {
            $self->say(
                channel =>  $message->{channel},
                body    =>  $message->{who}.": tu trouves ça marrant peut-être ?",
            );
        }
        elsif ( ($message->{body} =~ /([A-Z][! ]*){4}/o) && ($message->{body} !~ /^(\w*:( )?)?(H[AEIOU][! ]*)*([:;xX][\)DpP])?$/o) )
        {
            $self->say(
                channel =>  $message->{channel},
                body    =>  $message->{who}.": arrête de crier, espèce de kikoolol !",
            );
        }

#        elsif ( ($message->{who} eq "er11") && ($message->{body} =~ /ok/i) )
#        {
#            $self->say(
#                channel =>  $message->{channel},
#                body    =>  $message->{who}.": t'es vieux, change de vinyle :p",
#            );
#        }
    }
       
    
    return ;    
}

1;
