package Games::SMTNocturne::Fusion::Demon::Brute;
use Moose;
use namespace::autoclean;
extends 'Games::SMTNocturne::Fusion::Demon';

has '+elemental_fusions' => (
    default => sub { {
        Erthys  => 'up',
        Aeros   => 'down',
        Aquans  => 'up',
        Flameis => 'up',
    } },
);

has '+self_fusion_element' => (
    default => 'Erthys',
);

__PACKAGE__->meta->make_immutable;

1;
