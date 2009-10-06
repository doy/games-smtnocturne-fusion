package Games::SMTNocturne::Fusion::Chart;
use Moose;
use MooseX::ClassAttribute;
use MooseX::Mangle;
use MooseX::MultiMethods;
use List::MoreUtils qw(firstval);
use YAML::Any qw(Load);
use Games::SMTNocturne::Fusion::Types
    qw(DemonType SMTDemon Element Mitama
       DeathstoneDemon EvolveDemon SpecialDemon);
use MooseX::Types::Moose qw(HashRef Maybe);
use constant Demon => 'Games::SMTNocturne::Fusion::Demon';
use namespace::autoclean;

class_has _type_chart => (
    is      => 'ro',
    isa     => HashRef[HashRef[Maybe[DemonType]]],
    lazy    => 1,
    default => sub {
        local $/ = undef;
        my $data = <DATA>;
        close DATA;
        return Load($data);
    },
);

my %element_fusions = (
    Erthys => {
        Aeros   => 'Nigi',
        Aquans  => 'Ara',
        Flameis => 'Kusi',
    },
    Aeros => {
        Erthys  => 'Nigi',
        Aquans  => 'Kusi',
        Flameis => 'Ara',
    },
    Aquans => {
        Erthys  => 'Ara',
        Aeros   => 'Kusi',
        Flameis => 'Saki',
    },
    Flameis => {
        Erthys  => 'Kusi',
        Aeros   => 'Ara',
        Aquans  => 'Saki',
    },
);

multi method fuse (ClassName $class: SMTDemon $demon1 is coerce,
                                     SMTDemon $demon2 is coerce) {
    return Demon->next_demon_above_level(
        $class->_type_chart->{$demon1->type}{$demon2->type},
        ($demon1->level + $demon2->level) / 2,
    );
}

multi method fuse (ClassName $class: Element $demon1 is coerce,
                                     SMTDemon $demon2 is coerce) {
    my $direction = $demon2->elemental_fusion_direction($demon1->name);
    return unless defined $direction;

    if ($direction eq 'down') {
        return $demon2->level_down;
    }
    else {
        return $demon2->level_up;
    }
}

multi method fuse (ClassName $class: Mitama $demon1 is coerce,
                                     SMTDemon $demon2 is coerce) {
    return $demon2;
}

multi method fuse (ClassName $class: SMTDemon $demon1 is coerce,
                                     Element $demon2 is coerce) {
    return $class->fuse($demon2, $demon1);
}

multi method fuse (ClassName $class: SMTDemon $demon1 is coerce,
                                     Mitama $demon2 is coerce) {
    return $class->fuse($demon2, $demon1);
}

multi method fuse (ClassName $class: Element $demon1 is coerce,
                                     Element $demon2 is coerce) {
    my $mitama = $element_fusions{$demon1->name}{$demon2->name};
    return unless $mitama;
    return Demon->lookup("$mitama Mitama");
}

multi method fuse (ClassName $class: Mitama $demon1 is coerce,
                                     Mitama $demon2 is coerce) {
    return;
}

multi method fusions_for (ClassName $class: SMTDemon $demon is coerce) {
    my $type = $demon->type;
    my @type_combos;
    for my $type1 (keys %{ $class->_type_chart }) {
        for my $type2 (grep { defined }
                            keys %{ $class->_type_chart->{$type1} }) {
            my $fusion_type = $class->_type_chart->{$type1}{$type2};
            push @type_combos, [$type1, $type2]
                if defined $fusion_type && $type eq $fusion_type;
        }
    }

    my @found;
    for my $combo (@type_combos) {
        my @type1_demons = Demon->lookup(type => $combo->[0]);
        my @type2_demons = Demon->lookup(type => $combo->[1]);
        for my $demon1 (@type1_demons) {
            for my $demon2 (@type2_demons) {
                my $fusion = $class->fuse($demon1, $demon2);
                push @found, [$demon1, $demon2]
                    if defined $fusion && $fusion->name eq $demon->name;
            }
        }
    }

    return @found;
}

multi method fusions_for (ClassName $class: SpecialDemon $demon is coerce) {
    # XXX: fix
    return;
}

multi method fusions_for (ClassName $class: EvolveDemon $demon is coerce) {
    return;
}

multi method fusions_for (ClassName $class: DeathstoneDemon $demon is coerce) {
    # XXX: fix
    return;
}

multi method fusions_for (ClassName $class: Element $demon is coerce) {
    my @demons = Demon->lookup(self_fusion_element => $demon->name);
    my @found;
    for my $demon1 (@demons) {
        for my $demon2 (grep { $demon1->type eq $_->type } @demons) {
            next if $demon1->name eq $demon2->name;
            push @found, [$demon1, $demon2];
        }
    }
    return @found;
}

multi method fusions_for (ClassName $class: Mitama $demon is coerce) {
    my @found;
    for my $demon1 (keys %element_fusions) {
        for my $demon2 (keys %{ $element_fusions{$demon1} }) {
            next unless $demon->name eq "$element_fusions{$demon1}{$demon2} Mitama";
            my ($found1, $found2) = (Demon->lookup($demon1), Demon->lookup($demon2));
            push @found, [$found1, $found2];
        }
    }
    return @found;
}

mangle_return fusions_for => sub {
    my $class = shift;
    @_ = grep { $_->[0]->level <= $_->[1]->level } @_;
    return @_;
};

__PACKAGE__->meta->make_immutable;

1;

__DATA__
---
Avatar:
  Avatar: ~
  Avian: Holy
  Beast: Snake
  Brute: Kishin
  Deity: Megami
  Divine: Megami
  Dragon: Fury
  Element: ~
  Entity: Fury
  Fairy: Divine
  Fallen: Divine
  Femme: Kishin
  Fiend: ~
  Foul: ~
  Fury: Holy
  Genma: Kishin
  Haunt: ~
  Holy: Megami
  Jirae: Kishin
  Kishin: Holy
  Lady: Fury
  Megami: Deity
  Mitama: Avatar
  Night: Holy
  Raptor: Wilder
  Seraph: Deity
  Snake: Lady
  Tyrant: ~
  Vile: Deity
  Wargod: Deity
  Wilder: ~
  Yoma: Divine
Avian:
  Avatar: Holy
  Avian: ~
  Beast: Femme
  Brute: Kishin
  Deity: Megami
  Divine: Snake
  Dragon: Fury
  Element: ~
  Entity: Deity
  Fairy: Night
  Fallen: Snake
  Femme: Brute
  Fiend: ~
  Foul: ~
  Fury: Kishin
  Genma: Megami
  Haunt: ~
  Holy: Lady
  Jirae: Kishin
  Kishin: Lady
  Lady: ~
  Megami: Deity
  Mitama: Avian
  Night: Femme
  Raptor: Megami
  Seraph: Megami
  Snake: Kishin
  Tyrant: ~
  Vile: ~
  Wargod: Kishin
  Wilder: ~
  Yoma: Night
Beast:
  Avatar: Snake
  Avian: Femme
  Beast: Element
  Brute: Femme
  Deity: Avatar
  Divine: Holy
  Dragon: Snake
  Element: Beast
  Entity: Holy
  Fairy: Divine
  Fallen: Night
  Femme: Foul
  Fiend: Night
  Foul: Wilder
  Fury: Avatar
  Genma: Fairy
  Haunt: Wilder
  Holy: Avatar
  Jirae: Yoma
  Kishin: Holy
  Lady: Snake
  Megami: Holy
  Mitama: Beast
  Night: Fairy
  Raptor: Wilder
  Seraph: ~
  Snake: Brute
  Tyrant: Night
  Vile: Foul
  Wargod: Holy
  Wilder: Jirae
  Yoma: Fallen
Brute:
  Avatar: Kishin
  Avian: Kishin
  Beast: Femme
  Brute: Element
  Deity: Kishin
  Divine: Yoma
  Dragon: Night
  Element: Brute
  Entity: Fury
  Fairy: Night
  Fallen: Jirae
  Femme: Beast
  Fiend: Haunt
  Foul: Wilder
  Fury: Lady
  Genma: Divine
  Haunt: Foul
  Holy: Femme
  Jirae: Fairy
  Kishin: Snake
  Lady: Fury
  Megami: Femme
  Mitama: Brute
  Night: Kishin
  Raptor: Fury
  Seraph: ~
  Snake: Beast
  Tyrant: Haunt
  Vile: Haunt
  Wargod: ~
  Wilder: Fairy
  Yoma: Femme
Deity:
  Avatar: Megami
  Avian: Megami
  Beast: Avatar
  Brute: Kishin
  Deity: ~
  Divine: Megami
  Dragon: ~
  Element: Deity
  Entity: Megami
  Fairy: Night
  Fallen: Fury
  Femme: Lady
  Fiend: ~
  Foul: ~
  Fury: ~
  Genma: Megami
  Haunt: ~
  Holy: Megami
  Jirae: Brute
  Kishin: Fury
  Lady: ~
  Megami: ~
  Mitama: Deity
  Night: Vile
  Raptor: Tyrant
  Seraph: ~
  Snake: Kishin
  Tyrant: ~
  Vile: ~
  Wargod: Kishin
  Wilder: ~
  Yoma: Megami
Divine:
  Avatar: Megami
  Avian: Snake
  Beast: Holy
  Brute: Yoma
  Deity: Megami
  Divine: Element
  Dragon: Megami
  Element: Divine
  Entity: Megami
  Fairy: Megami
  Fallen: Vile
  Femme: Beast
  Fiend: Vile
  Foul: Fairy
  Fury: Deity
  Genma: Megami
  Haunt: Jirae
  Holy: Fairy
  Jirae: Night
  Kishin: Vile
  Lady: Megami
  Megami: Holy
  Mitama: Divine
  Night: Snake
  Raptor: Foul
  Seraph: Megami
  Snake: Fairy
  Tyrant: Vile
  Vile: Fallen
  Wargod: Holy
  Wilder: Fallen
  Yoma: Snake
Dragon:
  Avatar: Fury
  Avian: Fury
  Beast: Snake
  Brute: Night
  Deity: ~
  Divine: Megami
  Dragon: ~
  Element: ~
  Entity: Lady
  Fairy: Snake
  Fallen: Snake
  Femme: Night
  Fiend: ~
  Foul: Snake
  Fury: ~
  Genma: Holy
  Haunt: ~
  Holy: Snake
  Jirae: Kishin
  Kishin: Fury
  Lady: ~
  Megami: Avatar
  Mitama: Dragon
  Night: Femme
  Raptor: ~
  Seraph: Holy
  Snake: Lady
  Tyrant: ~
  Vile: Snake
  Wargod: Lady
  Wilder: ~
  Yoma: Avatar
Element:
  Avatar: ~
  Avian: ~
  Beast: Beast
  Brute: Brute
  Deity: Deity
  Divine: Divine
  Dragon: ~
  Element: Mitama
  Entity: ~
  Fairy: Fairy
  Fallen: Fallen
  Femme: Femme
  Fiend: ~
  Foul: Foul
  Fury: Fury
  Genma: ~
  Haunt: Haunt
  Holy: Holy
  Jirae: Jirae
  Kishin: Kishin
  Lady: Lady
  Megami: Megami
  Mitama: Element
  Night: Night
  Raptor: ~
  Seraph: ~
  Snake: Snake
  Tyrant: Tyrant
  Vile: Vile
  Wargod: ~
  Wilder: Wilder
  Yoma: Yoma
Entity:
  Avatar: Fury
  Avian: Deity
  Beast: Holy
  Brute: Fury
  Deity: Megami
  Divine: Megami
  Dragon: Lady
  Element: ~
  Entity: ~
  Fairy: Megami
  Fallen: Kishin
  Femme: Lady
  Fiend: ~
  Foul: Brute
  Fury: Lady
  Genma: Fury
  Haunt: Brute
  Holy: Kishin
  Jirae: Fury
  Kishin: Fury
  Lady: Fury
  Megami: Deity
  Mitama: Entity
  Night: Brute
  Raptor: Vile
  Seraph: Deity
  Snake: Fury
  Tyrant: ~
  Vile: ~
  Wargod: Fury
  Wilder: Brute
  Yoma: Megami
Fairy:
  Avatar: Divine
  Avian: Night
  Beast: Divine
  Brute: Night
  Deity: Night
  Divine: Megami
  Dragon: Snake
  Element: Fairy
  Entity: Megami
  Fairy: Element
  Fallen: Yoma
  Femme: Haunt
  Fiend: Night
  Foul: Haunt
  Fury: Brute
  Genma: ~
  Haunt: Night
  Holy: Megami
  Jirae: Yoma
  Kishin: Brute
  Lady: Yoma
  Megami: Fallen
  Mitama: Fairy
  Night: Snake
  Raptor: Haunt
  Seraph: Holy
  Snake: Yoma
  Tyrant: Night
  Vile: Night
  Wargod: ~
  Wilder: Yoma
  Yoma: Holy
Fallen:
  Avatar: Divine
  Avian: Snake
  Beast: Night
  Brute: Jirae
  Deity: Fury
  Divine: Vile
  Dragon: Snake
  Element: Fallen
  Entity: Kishin
  Fairy: Yoma
  Fallen: Element
  Femme: Wilder
  Fiend: Fury
  Foul: Vile
  Fury: Vile
  Genma: Lady
  Haunt: Night
  Holy: Beast
  Jirae: Brute
  Kishin: Night
  Lady: Fury
  Megami: Divine
  Mitama: Fallen
  Night: Haunt
  Raptor: Foul
  Seraph: Lady
  Snake: Beast
  Tyrant: Fury
  Vile: Brute
  Wargod: Lady
  Wilder: Night
  Yoma: Jirae
Femme:
  Avatar: Kishin
  Avian: Brute
  Beast: Foul
  Brute: Beast
  Deity: Lady
  Divine: Beast
  Dragon: Night
  Element: Femme
  Entity: Lady
  Fairy: Haunt
  Fallen: Wilder
  Femme: Element
  Fiend: Lady
  Foul: Wilder
  Fury: Lady
  Genma: Night
  Haunt: Foul
  Holy: Lady
  Jirae: Wilder
  Kishin: Lady
  Lady: Kishin
  Megami: Fairy
  Mitama: Femme
  Night: Jirae
  Raptor: Foul
  Seraph: ~
  Snake: Kishin
  Tyrant: Lady
  Vile: Brute
  Wargod: ~
  Wilder: Fallen
  Yoma: Brute
Fiend:
  Avatar: ~
  Avian: ~
  Beast: Night
  Brute: Haunt
  Deity: ~
  Divine: Vile
  Dragon: ~
  Element: ~
  Entity: ~
  Fairy: Night
  Fallen: Fury
  Femme: Lady
  Fiend: ~
  Foul: Haunt
  Fury: Deity
  Genma: Yoma
  Haunt: Foul
  Holy: ~
  Jirae: Wilder
  Kishin: ~
  Lady: ~
  Megami: ~
  Mitama: Fiend
  Night: Lady
  Raptor: Fury
  Seraph: Fallen
  Snake: Brute
  Tyrant: ~
  Vile: Fury
  Wargod: ~
  Wilder: Night
  Yoma: Night
Foul:
  Avatar: ~
  Avian: ~
  Beast: Wilder
  Brute: Wilder
  Deity: ~
  Divine: Fairy
  Dragon: Snake
  Element: Foul
  Entity: Brute
  Fairy: Haunt
  Fallen: Vile
  Femme: Wilder
  Fiend: Haunt
  Foul: ~
  Fury: ~
  Genma: ~
  Haunt: Brute
  Holy: ~
  Jirae: Femme
  Kishin: ~
  Lady: Vile
  Megami: ~
  Mitama: Foul
  Night: Brute
  Raptor: Vile
  Seraph: Fallen
  Snake: Fallen
  Tyrant: Haunt
  Vile: Haunt
  Wargod: ~
  Wilder: Beast
  Yoma: Snake
Fury:
  Avatar: Holy
  Avian: Kishin
  Beast: Avatar
  Brute: Lady
  Deity: ~
  Divine: Deity
  Dragon: ~
  Element: Fury
  Entity: Lady
  Fairy: Brute
  Fallen: Vile
  Femme: Lady
  Fiend: Deity
  Foul: ~
  Fury: ~
  Genma: Lady
  Haunt: ~
  Holy: Kishin
  Jirae: Femme
  Kishin: Lady
  Lady: Vile
  Megami: Deity
  Mitama: Fury
  Night: Lady
  Raptor: Tyrant
  Seraph: Vile
  Snake: Kishin
  Tyrant: Deity
  Vile: Tyrant
  Wargod: Deity
  Wilder: ~
  Yoma: Holy
Genma:
  Avatar: Kishin
  Avian: Megami
  Beast: Fairy
  Brute: Divine
  Deity: Megami
  Divine: Megami
  Dragon: Holy
  Element: ~
  Entity: Fury
  Fairy: ~
  Fallen: Lady
  Femme: Night
  Fiend: Yoma
  Foul: ~
  Fury: Lady
  Genma: ~
  Haunt: ~
  Holy: Yoma
  Jirae: Lady
  Kishin: Megami
  Lady: Femme
  Megami: Divine
  Mitama: Genma
  Night: Holy
  Raptor: Lady
  Seraph: Megami
  Snake: Femme
  Tyrant: Yoma
  Vile: Yoma
  Wargod: Holy
  Wilder: Yoma
  Yoma: ~
Haunt:
  Avatar: ~
  Avian: ~
  Beast: Wilder
  Brute: Foul
  Deity: ~
  Divine: Jirae
  Dragon: ~
  Element: Haunt
  Entity: Brute
  Fairy: Night
  Fallen: Night
  Femme: Foul
  Fiend: Foul
  Foul: Brute
  Fury: ~
  Genma: ~
  Haunt: ~
  Holy: ~
  Jirae: Vile
  Kishin: ~
  Lady: Vile
  Megami: ~
  Mitama: Haunt
  Night: Yoma
  Raptor: Vile
  Seraph: Fallen
  Snake: Brute
  Tyrant: Foul
  Vile: Foul
  Wargod: ~
  Wilder: Jirae
  Yoma: Jirae
Holy:
  Avatar: Megami
  Avian: Lady
  Beast: Avatar
  Brute: Femme
  Deity: Megami
  Divine: Fairy
  Dragon: Snake
  Element: Holy
  Entity: Kishin
  Fairy: Megami
  Fallen: Beast
  Femme: Lady
  Fiend: ~
  Foul: ~
  Fury: Kishin
  Genma: Yoma
  Haunt: ~
  Holy: Element
  Jirae: Beast
  Kishin: Lady
  Lady: Avatar
  Megami: Divine
  Mitama: Holy
  Night: Fairy
  Raptor: Wilder
  Seraph: Divine
  Snake: Kishin
  Tyrant: ~
  Vile: ~
  Wargod: Kishin
  Wilder: ~
  Yoma: Divine
Jirae:
  Avatar: Kishin
  Avian: Kishin
  Beast: Yoma
  Brute: Fairy
  Deity: Brute
  Divine: Night
  Dragon: Kishin
  Element: Jirae
  Entity: Fury
  Fairy: Yoma
  Fallen: Brute
  Femme: Wilder
  Fiend: Wilder
  Foul: Femme
  Fury: Femme
  Genma: Lady
  Haunt: Vile
  Holy: Beast
  Jirae: Element
  Kishin: Snake
  Lady: Beast
  Megami: Lady
  Mitama: Jirae
  Night: Foul
  Raptor: Foul
  Seraph: ~
  Snake: Fallen
  Tyrant: Wilder
  Vile: Haunt
  Wargod: Kishin
  Wilder: Brute
  Yoma: Beast
Kishin:
  Avatar: Holy
  Avian: Lady
  Beast: Holy
  Brute: Snake
  Deity: Fury
  Divine: Vile
  Dragon: Fury
  Element: Kishin
  Entity: Fury
  Fairy: Brute
  Fallen: Night
  Femme: Lady
  Fiend: ~
  Foul: ~
  Fury: Lady
  Genma: Megami
  Haunt: ~
  Holy: Lady
  Jirae: Snake
  Kishin: ~
  Lady: Fury
  Megami: Lady
  Mitama: Kishin
  Night: Femme
  Raptor: Tyrant
  Seraph: Divine
  Snake: Femme
  Tyrant: ~
  Vile: ~
  Wargod: Fury
  Wilder: ~
  Yoma: Femme
Lady:
  Avatar: Fury
  Avian: ~
  Beast: Snake
  Brute: Fury
  Deity: ~
  Divine: Megami
  Dragon: ~
  Element: Lady
  Entity: Fury
  Fairy: Yoma
  Fallen: Fury
  Femme: Kishin
  Fiend: ~
  Foul: Vile
  Fury: Vile
  Genma: Femme
  Haunt: Vile
  Holy: Avatar
  Jirae: Beast
  Kishin: Fury
  Lady: ~
  Megami: Fury
  Mitama: Lady
  Night: Kishin
  Raptor: Kishin
  Seraph: Deity
  Snake: Femme
  Tyrant: ~
  Vile: ~
  Wargod: Kishin
  Wilder: Haunt
  Yoma: Night
Megami:
  Avatar: Deity
  Avian: Deity
  Beast: Holy
  Brute: Femme
  Deity: ~
  Divine: Holy
  Dragon: Avatar
  Element: Megami
  Entity: Deity
  Fairy: Fallen
  Fallen: Divine
  Femme: Fairy
  Fiend: ~
  Foul: ~
  Fury: Deity
  Genma: Divine
  Haunt: ~
  Holy: Divine
  Jirae: Lady
  Kishin: Lady
  Lady: Fury
  Megami: ~
  Mitama: Megami
  Night: Fallen
  Raptor: Tyrant
  Seraph: Deity
  Snake: Fairy
  Tyrant: ~
  Vile: Fury
  Wargod: Deity
  Wilder: Vile
  Yoma: Kishin
Mitama:
  Avatar: Avatar
  Avian: Avian
  Beast: Beast
  Brute: Brute
  Deity: Deity
  Divine: Divine
  Dragon: Dragon
  Element: Element
  Entity: Entity
  Fairy: Fairy
  Fallen: Fallen
  Femme: Femme
  Fiend: Fiend
  Foul: Foul
  Fury: Fury
  Genma: Genma
  Haunt: Haunt
  Holy: Holy
  Jirae: Jirae
  Kishin: Kishin
  Lady: Lady
  Megami: Megami
  Mitama: Mitama
  Night: Night
  Raptor: Raptor
  Seraph: Seraph
  Snake: Snake
  Tyrant: Tyrant
  Vile: Vile
  Wargod: Wargod
  Wilder: Wilder
  Yoma: Yoma
Night:
  Avatar: Holy
  Avian: Femme
  Beast: Fairy
  Brute: Kishin
  Deity: Vile
  Divine: Snake
  Dragon: Femme
  Element: Night
  Entity: Brute
  Fairy: Snake
  Fallen: Haunt
  Femme: Jirae
  Fiend: Lady
  Foul: Brute
  Fury: Lady
  Genma: Holy
  Haunt: Yoma
  Holy: Fairy
  Jirae: Foul
  Kishin: Femme
  Lady: Kishin
  Megami: Fallen
  Mitama: Night
  Night: Element
  Raptor: Vile
  Seraph: Fallen
  Snake: Fallen
  Tyrant: Lady
  Vile: Lady
  Wargod: ~
  Wilder: Beast
  Yoma: Divine
Raptor:
  Avatar: Wilder
  Avian: Megami
  Beast: Wilder
  Brute: Fury
  Deity: Tyrant
  Divine: Foul
  Dragon: ~
  Element: ~
  Entity: Vile
  Fairy: Haunt
  Fallen: Foul
  Femme: Foul
  Fiend: Fury
  Foul: Vile
  Fury: Tyrant
  Genma: Lady
  Haunt: Vile
  Holy: Wilder
  Jirae: Foul
  Kishin: Tyrant
  Lady: Kishin
  Megami: Tyrant
  Mitama: Raptor
  Night: Vile
  Raptor: ~
  Seraph: ~
  Snake: Foul
  Tyrant: Fury
  Vile: Fury
  Wargod: ~
  Wilder: Vile
  Yoma: Haunt
Seraph:
  Avatar: Deity
  Avian: Megami
  Beast: ~
  Brute: ~
  Deity: ~
  Divine: Megami
  Dragon: Holy
  Element: ~
  Entity: Deity
  Fairy: Holy
  Fallen: Lady
  Femme: ~
  Fiend: Fallen
  Foul: Fallen
  Fury: Vile
  Genma: Megami
  Haunt: Fallen
  Holy: Divine
  Jirae: ~
  Kishin: Divine
  Lady: Deity
  Megami: Deity
  Mitama: Seraph
  Night: Fallen
  Raptor: ~
  Seraph: Element
  Snake: ~
  Tyrant: Fallen
  Vile: Divine
  Wargod: Kishin
  Wilder: ~
  Yoma: Megami
Snake:
  Avatar: Lady
  Avian: Kishin
  Beast: Brute
  Brute: Beast
  Deity: Kishin
  Divine: Fairy
  Dragon: Lady
  Element: Snake
  Entity: Fury
  Fairy: Yoma
  Fallen: Beast
  Femme: Kishin
  Fiend: Brute
  Foul: Fallen
  Fury: Kishin
  Genma: Femme
  Haunt: Brute
  Holy: Kishin
  Jirae: Fallen
  Kishin: Femme
  Lady: Femme
  Megami: Fairy
  Mitama: Snake
  Night: Fallen
  Raptor: Foul
  Seraph: ~
  Snake: Element
  Tyrant: Brute
  Vile: Kishin
  Wargod: Kishin
  Wilder: Night
  Yoma: Night
Tyrant:
  Avatar: ~
  Avian: ~
  Beast: Night
  Brute: Haunt
  Deity: ~
  Divine: Vile
  Dragon: ~
  Element: Tyrant
  Entity: ~
  Fairy: Night
  Fallen: Fury
  Femme: Lady
  Fiend: ~
  Foul: Haunt
  Fury: Deity
  Genma: Yoma
  Haunt: Foul
  Holy: ~
  Jirae: Wilder
  Kishin: ~
  Lady: ~
  Megami: ~
  Mitama: Tyrant
  Night: Lady
  Raptor: Fury
  Seraph: Fallen
  Snake: Brute
  Tyrant: ~
  Vile: Fury
  Wargod: ~
  Wilder: Night
  Yoma: Night
Vile:
  Avatar: Deity
  Avian: ~
  Beast: Foul
  Brute: Haunt
  Deity: ~
  Divine: Fallen
  Dragon: Snake
  Element: Vile
  Entity: ~
  Fairy: Night
  Fallen: Brute
  Femme: Brute
  Fiend: Fury
  Foul: Haunt
  Fury: Tyrant
  Genma: Yoma
  Haunt: Foul
  Holy: ~
  Jirae: Haunt
  Kishin: ~
  Lady: ~
  Megami: Fury
  Mitama: Vile
  Night: Lady
  Raptor: Fury
  Seraph: Divine
  Snake: Kishin
  Tyrant: Fury
  Vile: ~
  Wargod: Kishin
  Wilder: Foul
  Yoma: Jirae
Wargod:
  Avatar: Deity
  Avian: Kishin
  Beast: Holy
  Brute: ~
  Deity: Kishin
  Divine: Holy
  Dragon: Lady
  Element: ~
  Entity: Fury
  Fairy: ~
  Fallen: Lady
  Femme: ~
  Fiend: ~
  Foul: ~
  Fury: Deity
  Genma: Holy
  Haunt: ~
  Holy: Kishin
  Jirae: Kishin
  Kishin: Fury
  Lady: Kishin
  Megami: Deity
  Mitama: Wargod
  Night: ~
  Raptor: ~
  Seraph: Kishin
  Snake: Kishin
  Tyrant: ~
  Vile: Kishin
  Wargod: ~
  Wilder: ~
  Yoma: ~
Wilder:
  Avatar: ~
  Avian: ~
  Beast: Jirae
  Brute: Fairy
  Deity: ~
  Divine: Fallen
  Dragon: ~
  Element: Wilder
  Entity: Brute
  Fairy: Yoma
  Fallen: Night
  Femme: Fallen
  Fiend: Night
  Foul: Beast
  Fury: ~
  Genma: Yoma
  Haunt: Jirae
  Holy: ~
  Jirae: Brute
  Kishin: ~
  Lady: Haunt
  Megami: Vile
  Mitama: Wilder
  Night: Beast
  Raptor: Vile
  Seraph: ~
  Snake: Night
  Tyrant: Night
  Vile: Foul
  Wargod: ~
  Wilder: Element
  Yoma: Beast
Yoma:
  Avatar: Divine
  Avian: Night
  Beast: Fallen
  Brute: Femme
  Deity: Megami
  Divine: Snake
  Dragon: Avatar
  Element: Yoma
  Entity: Megami
  Fairy: Holy
  Fallen: Jirae
  Femme: Brute
  Fiend: Night
  Foul: Snake
  Fury: Holy
  Genma: ~
  Haunt: Jirae
  Holy: Divine
  Jirae: Beast
  Kishin: Femme
  Lady: Night
  Megami: Kishin
  Mitama: Yoma
  Night: Divine
  Raptor: Haunt
  Seraph: Megami
  Snake: Night
  Tyrant: Night
  Vile: Jirae
  Wargod: ~
  Wilder: Beast
  Yoma: Element
