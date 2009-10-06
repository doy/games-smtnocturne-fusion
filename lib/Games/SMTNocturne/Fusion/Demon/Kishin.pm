package Games::SMTNocturne::Fusion::Demon::Kishin;
use Moose;
use namespace::autoclean;
extends 'Games::SMTNocturne::Fusion::Demon';

has '+elemental_fusions' => (
    default => sub { {
        Erthys  => 'up',
        Aeros   => 'down',
        Aquans  => 'down',
        Flameis => 'down',
    } },
);

__PACKAGE__->meta->make_immutable;

1;
