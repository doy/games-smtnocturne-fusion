package Games::SMTNocturne::Fusion::Types;
use MooseX::Types -declare => [qw(DemonType FusionType SMTDemon DemonList)];
use MooseX::Types::Moose qw(ArrayRef Str);

# XXX: make each demon type a subtype of Demon
my @demon_types =
    qw(Deity Megami Fury Lady Kishin Holy Element Mitama Yoma Fairy Divine
       Fallen Snake Beast Jirae Brute Femme Vile Tyrant Night Wilder Haunt
       Foul Seraph Wargod Genma Dragon Avatar Avian Raptor Entity Fiend);

enum DemonType, @demon_types;
enum FusionType, qw(deathstone evolve normal special);

class_type SMTDemon, { class => 'Games::SMTNocturne::Fusion::Demon' };
coerce SMTDemon, from Str,
    via { Games::SMTNocturne::Fusion::Demon->lookup($_) };
subtype DemonList, as ArrayRef[SMTDemon];
coerce DemonList, from ArrayRef[Str],
    via { [map { to_SMTDemon($_) } @$_] };

1;
