package Games::SMTNocturne::Fusion::Demon::Foul;
use Moose;
use namespace::autoclean;
extends 'Games::SMTNocturne::Fusion::Demon';

has '+elemental_fusions' => (
    default => sub { {
        Erthys  => 'down',
        Aeros   => 'down',
        Aquans  => 'up',
        Flameis => 'down',
    } },
);

__PACKAGE__->meta->make_immutable;

1;
