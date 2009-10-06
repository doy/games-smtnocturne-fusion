package Games::SMTNocturne::Fusion::Types;
my @demon_types;
BEGIN {
    @demon_types =
        qw(Deity Megami Fury Lady Kishin Holy Element Mitama Yoma Fairy Divine
           Fallen Snake Beast Jirae Brute Femme Vile Tyrant Night Wilder Haunt
           Foul Seraph Wargod Genma Dragon Avatar Avian Raptor Entity Fiend);
}
use MooseX::Types
    -declare => [qw(DemonType FusionType SMTDemon DemonList
                    DeathstoneDemon EvolveDemon SpecialDemon),
                 @demon_types];
use MooseX::Types::Moose qw(ArrayRef Str);

enum DemonType, @demon_types;
enum FusionType, qw(deathstone evolve normal special);

class_type SMTDemon, { class => 'Games::SMTNocturne::Fusion::Demon' };
coerce SMTDemon, from Str,
    via { Games::SMTNocturne::Fusion::Demon->lookup($_) };
subtype DemonList, as ArrayRef[SMTDemon];
coerce DemonList, from ArrayRef[Str],
    via { [map { to_SMTDemon($_) } @$_] };

for my $typename (@demon_types) {
    my $type = __PACKAGE__->can($typename)->();
    class_type $type,
        { class => "Games::SMTNocturne::Fusion::Demon::$typename" };
    coerce $type, from Str,
        via { Games::SMTNocturne::Fusion::Demon->lookup($_) };
}

for my $typename (qw(Deathstone Evolve Special)) {
    my $type = __PACKAGE__->can("${typename}Demon")->();
    subtype $type, as SMTDemon,
        where { $_->does("Games::SMTNocturne::Fusion::Role::$typename") };
    coerce $type, from Str,
        via { Games::SMTNocturne::Fusion::Demon->lookup($_) };
}

1;
