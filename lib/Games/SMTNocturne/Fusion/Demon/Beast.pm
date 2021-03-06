package Games::SMTNocturne::Fusion::Demon::Beast;
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
    default => 'Aeros',
);

__PACKAGE__->meta->make_immutable;

1;
