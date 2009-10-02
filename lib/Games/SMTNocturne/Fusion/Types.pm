package Games::SMTNocturne::Fusion::Types;
use strict;
use warnings;
use Moose::Util::TypeConstraints;

enum 'Games::SMTNocturne::Fusion::DemonType' =>
    qw(Deity Megami Fury Lady Kishin Holy Element Mitama Yoma Fairy Divine
       Fallen Snake Beast Jirae Brute Femme Vile Tyrant Night Wilder Haunt
       Foul Seraph Wargod Genma Dragon Avatar Avian Raptor Entity Fiend);
enum 'Games::SMTNocturne::Fusion::FusionType' =>
    qw(deathstone evolve normal special);
subtype 'Games::SMTNocturne::Fusion::DemonList',
    as 'ArrayRef[Games::SMTNocturne::Fusion::Demon]';
coerce 'Games::SMTNocturne::Fusion::DemonList',
    from 'ArrayRef[Str]',
    via { [map { Games::SMTNocturne::Fusion::Demon->lookup($_) } @$_] };

1;
