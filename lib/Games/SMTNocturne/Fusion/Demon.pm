package Games::SMTNocturne::Fusion::Demon;
use Moose;
use MooseX::ClassAttribute;
use YAML::Any qw(Load);
use Games::SMTNocturne::Fusion::Types;

with 'MooseX::Traits',
     'MooseX::Role::Matcher' => { default_match => 'name' };

class_has _list => (
    is      => 'ro',
    isa     => 'ArrayRef[HashRef]',
    lazy    => 1,
    default => sub {
        local $/ = undef;
        my $data = <DATA>;
        close DATA;
        return Load($data);
    },
);

class_has list => (
    is => 'ro',
    isa => 'ArrayRef[Games::SMTNocturne::Fusion::Demon]',
    lazy => 1,
    default => sub {
        my $meta = shift;
        my $class = $meta->name;
        my %traits = map {
            $_ => ["Games::SMTNocturne::Fusion::Role::" . ucfirst($_)]
        } qw(deathstone evolve special);
        $traits{normal} = [];
        return [ map {
            $class->new_with_traits(traits => $traits{$_->{fusion_type}}, %$_)
        } @{ $class->_list } ];
    },
);

has name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has level => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
);

has type => (
    is       => 'ro',
    isa      => 'Games::SMTNocturne::Fusion::DemonType',
    required => 1,
);

has fusion_type => (
    is       => 'ro',
    isa      => 'Games::SMTNocturne::Fusion::FusionType',
    required => 1,
);

sub lookup {
    my ($class, @props) = @_;
    my @possible = $class->grep_matches($class->list, @props);

    return wantarray ? @possible : (@possible == 1 ? $possible[0] : undef);
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

__DATA__
---
- fusion_type: normal
  level: '38'
  name: Horus
  type: Deity
- fusion_type: normal
  level: '47'
  name: Atavaka
  type: Deity
- fusion_type: special
  level: '56'
  name: Amaterasu
  type: Deity
- fusion_type: normal
  level: '65'
  name: Odin
  type: Deity
- fusion_type: normal
  level: '78'
  name: Mithra
  type: Deity
- fusion_type: normal
  level: '93'
  name: Vishnu
  type: Deity
- fusion_type: normal
  level: '18'
  name: Uzume
  type: Megami
- fusion_type: normal
  level: '30'
  name: Sarasvati
  type: Megami
- fusion_type: normal
  level: '48'
  name: Sati
  type: Megami
- fusion_type: normal
  level: '54'
  name: Laksmi
  type: Megami
- fusion_type: normal
  level: '64'
  name: Scathach
  type: Megami
- fusion_type: normal
  level: '44'
  name: Dionysus
  type: Fury
- fusion_type: evolve
  level: '54'
  name: Wu Kong
  type: Fury
- fusion_type: normal
  level: '61'
  name: Beji Weng
  type: Fury
- fusion_type: special
  level: '95'
  name: Shiva
  type: Fury
- fusion_type: normal
  level: '24'
  name: Kikuri-Hime
  type: Lady
- fusion_type: normal
  level: '41'
  name: Kushinada
  type: Lady
- fusion_type: evolve
  level: '57'
  name: Parvati
  type: Lady
- fusion_type: normal
  level: '67'
  name: Kali
  type: Lady
- fusion_type: evolve
  level: '74'
  name: Skadi
  type: Lady
- fusion_type: normal
  level: '17'
  name: Minakata
  type: Kishin
- fusion_type: normal
  level: '27'
  name: Zouchou
  type: Kishin
- fusion_type: normal
  level: '33'
  name: Koumoko
  type: Kishin
- fusion_type: normal
  level: '39'
  name: Okuninushi
  type: Kishin
- fusion_type: normal
  level: '45'
  name: Mikazuchi
  type: Kishin
- fusion_type: normal
  level: '52'
  name: Jiroku
  type: Kishin
- fusion_type: normal
  level: '63'
  name: Futomimi
  type: Kishin
- fusion_type: normal
  level: '72'
  name: Bishamon
  type: Kishin
- fusion_type: normal
  level: '76'
  name: Thor
  type: Kishin
- fusion_type: normal
  level: '13'
  name: Shiisaa
  type: Holy
- fusion_type: normal
  level: '21'
  name: Unicorn
  type: Holy
- fusion_type: evolve
  level: '27'
  name: Senri
  type: Holy
- fusion_type: normal
  level: '36'
  name: Feng Huang
  type: Holy
- fusion_type: normal
  level: '43'
  name: Baihu
  type: Holy
- fusion_type: normal
  level: '55'
  name: Chimera
  type: Holy
- fusion_type: normal
  level: '7'
  name: Erthys
  type: Element
- fusion_type: normal
  level: '11'
  name: Aeros
  type: Element
- fusion_type: normal
  level: '15'
  name: Aquans
  type: Element
- fusion_type: normal
  level: '20'
  name: Flameis
  type: Element
- fusion_type: normal
  level: '25'
  name: Ara Mitama
  type: Mitama
- fusion_type: normal
  level: '29'
  name: Nigi Mitama
  type: Mitama
- fusion_type: normal
  level: '32'
  name: Kusi Mitama
  type: Mitama
- fusion_type: normal
  level: '35'
  name: Saki Mitama
  type: Mitama
- fusion_type: normal
  level: '8'
  name: Apsaras
  type: Yoma
- fusion_type: normal
  level: '14'
  name: Isora
  type: Yoma
- fusion_type: normal
  level: '19'
  name: Koppa
  type: Yoma
- fusion_type: normal
  level: '23'
  name: Dis
  type: Yoma
- fusion_type: evolve
  level: '28'
  name: Karasu
  type: Yoma
- fusion_type: normal
  level: '37'
  name: Onkot
  type: Yoma
- fusion_type: normal
  level: '44'
  name: Jinn
  type: Yoma
- fusion_type: normal
  level: '48'
  name: Purski
  type: Yoma
- fusion_type: evolve
  level: '52'
  name: Efreet
  type: Yoma
- fusion_type: normal
  level: '2'
  name: Pixie
  type: Fairy
- fusion_type: normal
  level: '7'
  name: Jack Frost
  type: Fairy
- fusion_type: evolve
  level: '10'
  name: High Pixie
  type: Fairy
- fusion_type: normal
  level: '19'
  name: Pyro Jack
  type: Fairy
- fusion_type: normal
  level: '26'
  name: Kelpie
  type: Fairy
- fusion_type: normal
  level: '38'
  name: Troll
  type: Fairy
- fusion_type: normal
  level: '43'
  name: Setanta
  type: Fairy
- fusion_type: normal
  level: '46'
  name: Oberon
  type: Fairy
- fusion_type: normal
  level: '57'
  name: Titania
  type: Fairy
- fusion_type: normal
  level: '11'
  name: Angel
  type: Divine
- fusion_type: normal
  level: '18'
  name: Archangel
  type: Divine
- fusion_type: normal
  level: '28'
  name: Principality
  type: Divine
- fusion_type: normal
  level: '33'
  name: Power
  type: Divine
- fusion_type: normal
  level: '41'
  name: Virtue
  type: Divine
- fusion_type: normal
  level: '50'
  name: Dominion
  type: Divine
- fusion_type: normal
  level: '64'
  name: Throne
  type: Divine
- fusion_type: normal
  level: '20'
  name: Forneus
  type: Fallen
- fusion_type: normal
  level: '29'
  name: Eligor
  type: Fallen
- fusion_type: normal
  level: '37'
  name: Berith
  type: Fallen
- fusion_type: normal
  level: '45'
  name: Ose
  type: Fallen
- fusion_type: normal
  level: '58'
  name: Decarabia
  type: Fallen
- fusion_type: normal
  level: '68'
  name: Flauros
  type: Fallen
- fusion_type: normal
  level: '14'
  name: Nozuchi
  type: Snake
- fusion_type: normal
  level: '28'
  name: Naga
  type: Snake
- fusion_type: normal
  level: '34'
  name: Mizuchi
  type: Snake
- fusion_type: evolve
  level: '37'
  name: Raja Naga
  type: Snake
- fusion_type: normal
  level: '55'
  name: Quetzalcoatl
  type: Snake
- fusion_type: normal
  level: '66'
  name: Yurlungur
  type: Snake
- fusion_type: normal
  level: '13'
  name: Inugami
  type: Beast
- fusion_type: normal
  level: '18'
  name: Nekomata
  type: Beast
- fusion_type: normal
  level: '23'
  name: Badb Catha
  type: Beast
- fusion_type: normal
  level: '34'
  name: Orthrus
  type: Beast
- fusion_type: normal
  level: '54'
  name: Sparna
  type: Beast
- fusion_type: normal
  level: '61'
  name: Cerberus
  type: Beast
- fusion_type: normal
  level: '3'
  name: Kodama
  type: Jirae
- fusion_type: normal
  level: '5'
  name: Hua Po
  type: Jirae
- fusion_type: normal
  level: '13'
  name: Sudama
  type: Jirae
- fusion_type: normal
  level: '35'
  name: Sarutahiko
  type: Jirae
- fusion_type: normal
  level: '49'
  name: Titan
  type: Jirae
- fusion_type: normal
  level: '55'
  name: Gogmagog
  type: Jirae
- fusion_type: normal
  level: '4'
  name: Shikigami
  type: Brute
- fusion_type: normal
  level: '20'
  name: Momunofu
  type: Brute
- fusion_type: normal
  level: '25'
  name: Oni
  type: Brute
- fusion_type: normal
  level: '44'
  name: Ikusa
  type: Brute
- fusion_type: normal
  level: '54'
  name: Shiki-Ouji
  type: Brute
- fusion_type: normal
  level: '59'
  name: Kin-Ki
  type: Brute
- fusion_type: normal
  level: '62'
  name: Sui-Ki
  type: Brute
- fusion_type: normal
  level: '66'
  name: Fuu-Ki
  type: Brute
- fusion_type: special
  level: '81'
  name: Ongyo-Ki
  type: Brute
- fusion_type: normal
  level: '7'
  name: Datsue-Ba
  type: Femme
- fusion_type: normal
  level: '20'
  name: Taraka
  type: Femme
- fusion_type: normal
  level: '32'
  name: Shikome
  type: Femme
- fusion_type: normal
  level: '43'
  name: Yaksini
  type: Femme
- fusion_type: normal
  level: '52'
  name: Dakini
  type: Femme
- fusion_type: normal
  level: '58'
  name: Clotho
  type: Femme
- fusion_type: normal
  level: '63'
  name: Lachesis
  type: Femme
- fusion_type: normal
  level: '67'
  name: Atropos
  type: Femme
- fusion_type: normal
  level: '72'
  name: Rangda
  type: Femme
- fusion_type: normal
  level: '30'
  name: Arahabaki
  type: Vile
- fusion_type: normal
  level: '33'
  name: Baphomet
  type: Vile
- fusion_type: normal
  level: '35'
  name: Pazuzu
  type: Vile
- fusion_type: special
  level: '58'
  name: Girimehkala
  type: Vile
- fusion_type: normal
  level: '65'
  name: Tao Tie
  type: Vile
- fusion_type: special
  level: '73'
  name: Samael
  type: Vile
- fusion_type: normal
  level: '83'
  name: Mada
  type: Vile
- fusion_type: normal
  level: '52'
  name: Loki
  type: Tyrant
- fusion_type: normal
  level: '69'
  name: Abaddon
  type: Tyrant
- fusion_type: normal
  level: '74'
  name: Surt
  type: Tyrant
- fusion_type: evolve
  level: '77'
  name: Aciel
  type: Tyrant
- fusion_type: normal
  level: '84'
  name: Beelzebub
  type: Tyrant
- fusion_type: normal
  level: '91'
  name: Mot
  type: Tyrant
- fusion_type: evolve
  level: '95'
  name: Beelzebub (Fly)
  type: Tyrant
- fusion_type: normal
  level: '8'
  name: Lilim
  type: Night
- fusion_type: normal
  level: '18'
  name: Fomor
  type: Night
- fusion_type: normal
  level: '25'
  name: Incubus
  type: Night
- fusion_type: normal
  level: '37'
  name: Succubus
  type: Night
- fusion_type: normal
  level: '47'
  name: Kaiwan
  type: Night
- fusion_type: normal
  level: '53'
  name: Loa
  type: Night
- fusion_type: evolve
  level: '56'
  name: Queen Mab
  type: Night
- fusion_type: normal
  level: '66'
  name: Black Frost
  type: Night
- fusion_type: normal
  level: '70'
  name: Nyx
  type: Night
- fusion_type: evolve
  level: '80'
  name: Lilith
  type: Night
- fusion_type: normal
  level: '6'
  name: Zhen
  type: Wilder
- fusion_type: normal
  level: '15'
  name: Bicorn
  type: Wilder
- fusion_type: normal
  level: '25'
  name: Raiju
  type: Wilder
- fusion_type: normal
  level: '31'
  name: Nue
  type: Wilder
- fusion_type: normal
  level: '43'
  name: Mothman
  type: Wilder
- fusion_type: normal
  level: '75'
  name: Hresvelgr
  type: Wilder
- fusion_type: normal
  level: '4'
  name: Preta
  type: Haunt
- fusion_type: normal
  level: '11'
  name: Choronzon
  type: Haunt
- fusion_type: normal
  level: '17'
  name: Yaka
  type: Haunt
- fusion_type: normal
  level: '20'
  name: Chatterskull
  type: Haunt
- fusion_type: normal
  level: '28'
  name: Pisaca
  type: Haunt
- fusion_type: normal
  level: '49'
  name: Legion
  type: Haunt
- fusion_type: normal
  level: '63'
  name: Rakshasa
  type: Haunt
- fusion_type: normal
  level: '1'
  name: Will O' Wisp
  type: Foul
- fusion_type: normal
  level: '6'
  name: Slime
  type: Foul
- fusion_type: normal
  level: '7'
  name: Mou-Ryo
  type: Foul
- fusion_type: normal
  level: '16'
  name: Blob
  type: Foul
- fusion_type: normal
  level: '28'
  name: Black Ooze
  type: Foul
- fusion_type: normal
  level: '42'
  name: Phantom
  type: Foul
- fusion_type: special
  level: '45'
  name: Sakahagi
  type: Foul
- fusion_type: normal
  level: '52'
  name: Shadow
  type: Foul
- fusion_type: evolve
  level: '73'
  name: Uriel
  type: Seraph
- fusion_type: special
  level: '84'
  name: Raphael
  type: Seraph
- fusion_type: special
  level: '87'
  name: Gabriel
  type: Seraph
- fusion_type: special
  level: '90'
  name: Michael
  type: Seraph
- fusion_type: special
  level: '95'
  name: Metatron
  type: Seraph
- fusion_type: evolve
  level: '33'
  name: Valkyrie
  type: Wargod
- fusion_type: evolve
  level: '58'
  name: Ganesha
  type: Wargod
- fusion_type: evolve
  level: '38'
  name: Kurama
  type: Genma
- fusion_type: evolve
  level: '46'
  name: Hanuman
  type: Genma
- fusion_type: evolve
  level: '52'
  name: Cu Chulainn
  type: Genma
- fusion_type: evolve
  level: '24'
  name: Gui Xian
  type: Dragon
- fusion_type: evolve
  level: '44'
  name: Long
  type: Dragon
- fusion_type: evolve
  level: '22'
  name: Makami
  type: Avatar
- fusion_type: normal
  level: '26'
  name: Cai-Zhi
  type: Avatar
- fusion_type: normal
  level: '46'
  name: Yatagarasu
  type: Avatar
- fusion_type: normal
  level: '60'
  name: Barong
  type: Avatar
- fusion_type: evolve
  level: '63'
  name: Garuda
  type: Avian
- fusion_type: special
  level: '63'
  name: Gurr
  type: Raptor
- fusion_type: evolve
  level: '64'
  name: Albion
  type: Entity
- fusion_type: deathstone
  level: '30'
  name: Matador
  type: Fiend
- fusion_type: deathstone
  level: '37'
  name: Daisoujou
  type: Fiend
- fusion_type: deathstone
  level: '42'
  name: Hell Biker
  type: Fiend
- fusion_type: deathstone
  level: '52'
  name: White Rider
  type: Fiend
- fusion_type: deathstone
  level: '55'
  name: Red Rider
  type: Fiend
- fusion_type: deathstone
  level: '61'
  name: Black Rider
  type: Fiend
- fusion_type: deathstone
  level: '63'
  name: Pale Rider
  type: Fiend
- fusion_type: deathstone
  level: '69'
  name: The Harlot
  type: Fiend
- fusion_type: deathstone
  level: '77'
  name: Trumpeter
  type: Fiend
