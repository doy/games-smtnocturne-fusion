package Games::SMTNocturne::Fusion::Demon::Fallen;
use Moose;
use namespace::autoclean;
extends 'Games::SMTNocturne::Fusion::Demon';

has '+elemental_fusions' => (
    default => sub { {
        Erthys  => 'down',
        Aeros   => 'up',
        Aquans  => 'down',
        Flameis => 'up',
    } },
);

has '+self_fusion_element' => (
    default => 'Erthys',
);

__PACKAGE__->meta->make_immutable;

1;
