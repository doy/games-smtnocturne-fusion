package Games::SMTNocturne::Fusion::Demon::Divine;
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
    default => 'Aeros',
);

__PACKAGE__->meta->make_immutable;

1;
