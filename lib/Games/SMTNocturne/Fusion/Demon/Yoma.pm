package Games::SMTNocturne::Fusion::Demon::Yoma;
use Moose;
use namespace::autoclean;
extends 'Games::SMTNocturne::Fusion::Demon';

has '+elemental_fusions' => (
    default => sub { {
        Erthys  => 'down',
        Aeros   => 'up',
        Aquans  => 'up',
        Flameis => 'down',
    } },
);

has '+self_fusion_element' => (
    default => 'Aquans',
);

__PACKAGE__->meta->make_immutable;

1;
