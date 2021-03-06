package Games::SMTNocturne::Fusion::Demon::Snake;
use Moose;
use namespace::autoclean;
extends 'Games::SMTNocturne::Fusion::Demon';

has '+elemental_fusions' => (
    default => sub { {
        Erthys  => 'down',
        Aeros   => 'down',
        Aquans  => 'up',
        Flameis => 'up',
    } },
);

has '+self_fusion_element' => (
    default => 'Aquans',
);

__PACKAGE__->meta->make_immutable;

1;
