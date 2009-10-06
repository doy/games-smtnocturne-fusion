package Games::SMTNocturne::Fusion::Demon::Seraph;
use Moose;
use namespace::autoclean;
extends 'Games::SMTNocturne::Fusion::Demon';

has '+self_fusion_element' => (
    default => 'Flameis',
);

__PACKAGE__->meta->make_immutable;

1;
