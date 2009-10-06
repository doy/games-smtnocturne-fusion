package Games::SMTNocturne::Fusion::Demon::Tyrant;
use Moose;
use namespace::autoclean;
extends 'Games::SMTNocturne::Fusion::Demon';

has '+elemental_fusions' => (
    default => sub { {
        Erthys  => 'down',
        Aeros   => 'down',
        Aquans  => 'down',
        Flameis => 'down',
    } },
);

__PACKAGE__->meta->make_immutable;

1;
