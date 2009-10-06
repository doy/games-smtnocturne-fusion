package Games::SMTNocturne::Fusion::KagutsuchiPhase;
use Moose;
use namespace::clean -except => 'meta';
use overload '""' => sub {
    my $self = shift;
    '<Kagutsuchi: ' . join(', ', map { $_ == 0 ? 'new'
                                     : $_ == 4 ? 'half'
                                     : $_ == 8 ? 'full'
                                     : $_ } $self->phases) . '>';
};
# use namespace::autoclean;

has phases => (
    traits   => ['Array'],
    isa      => 'ArrayRef[Int]',
    required => 1,
    handles  => {
        phases => 'elements',
    },
);

around BUILDARGS => sub {
    my $orig = shift;
    my $class = shift;
    my @phases = @_;
    return $class->$orig(phases => \@phases);
};

__PACKAGE__->meta->make_immutable;

1;
