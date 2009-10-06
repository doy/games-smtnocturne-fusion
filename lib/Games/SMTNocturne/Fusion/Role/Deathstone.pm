package Games::SMTNocturne::Fusion::Role::Deathstone;
use Moose::Role;
#use MooseX::ClassAttribute;
use MooseX::Types::Moose qw(HashRef);
use Memoize;
use YAML::Any qw(Load);
use Games::SMTNocturne::Fusion::Types qw(DemonType);
use namespace::autoclean;
with 'Games::SMTNocturne::Fusion::Role::NotNormallyFusable';

=for doesnt_work_yet

class_has required_target_types => (
    traits  => ['Hash'],
    isa     => HashRef[DemonType],
    default => sub {
        local $/ = undef;
        my $data = <DATA>;
        close DATA;
        return Load($data);
    },
    handles => {
        required_target_type_for => 'get',
    },
);

=cut

sub _required_state {
    local $/ = undef;
    my $data = <DATA>;
    close DATA;
    return Load($data);
}
memoize('_required_state', NORMALIZER => sub { "" });

sub required_target_type_for {
    my $class = shift;
    return $class->_required_state->{$_[0]}{type};
}

sub required_time_for {
    my $class = shift;
    my $time = $class->_required_state->{$_[0]}{time};
    return Games::SMTNocturne::Fusion::KagutsuchiPhase->new(
        $time->[0]..$time->[1]
    );
}

sub required_target_type {
    my $self = shift;
    return $self->required_target_type_for($self->name);
}

sub required_time {
    my $self = shift;
    return $self->required_time_for($self->name);
}

1;

__DATA__
---
Black Rider:
  time:
  - 0
  - 0
  type: Night
Daisoujou:
  time:
  - 5
  - 8
  type: Night
Hell Biker:
  time:
  - 4
  - 7
  type: Fairy
Matador:
  time:
  - 1
  - 4
  type: Yoma
Pale Rider:
  time:
  - 0
  - 0
  type: Tyrant
Red Rider:
  time:
  - 0
  - 0
  type: Fairy
The Harlot:
  time:
  - 4
  - 4
  type: Tyrant
Trumpeter:
  time:
  - 8
  - 8
  type: Tyrant
White Rider:
  time:
  - 0
  - 0
  type: Yoma
