package Games::SMTNocturne::Fusion::Demon::Haunt;
use Moose;
use namespace::autoclean;
extends 'Games::SMTNocturne::Fusion::Demon';

has '+elemental_fusions' => (
    default => sub { {
        Erthys  => 'down',
        Aeros   => 'up',
        Aquans  => 'down',
        Flameis => 'down',
    } },
);

__PACKAGE__->meta->make_immutable;

1;
