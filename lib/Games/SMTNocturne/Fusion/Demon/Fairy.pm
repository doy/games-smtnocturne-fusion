package Games::SMTNocturne::Fusion::Demon::Fairy;
use Moose;
use namespace::autoclean;
extends 'Games::SMTNocturne::Fusion::Demon';

has '+elemental_fusions' => (
    default => sub { {
        Erthys  => 'up',
        Aeros   => 'down',
        Aquans  => 'up',
        Flameis => 'down',
    } },
);

has '+self_fusion_element' => (
    default => 'Aeros',
);

__PACKAGE__->meta->make_immutable;

1;
