package Games::SMTNocturne::Fusion::Demon::Jirae;
use Moose;
use namespace::autoclean;
extends 'Games::SMTNocturne::Fusion::Demon';

has '+elemental_fusions' => (
    default => sub { {
        Erthys  => 'up',
        Aeros   => 'up',
        Aquans  => 'down',
        Flameis => 'down',
    } },
);

has '+self_fusion_element' => (
    default => 'Erthys',
);

__PACKAGE__->meta->make_immutable;

1;
