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

sub _required_target_types {
    local $/ = undef;
    my $data = <DATA>;
    close DATA;
    return Load($data);
}
memoize('_required_target_types', NORMALIZER => sub { "" });

sub required_target_type_for {
    my $class = shift;
    return $class->_required_target_types->{$_[0]};
}

sub required_target_type {
    my $self = shift;
    return $self->required_target_type_for($self->name);
}

1;

__DATA__
---
Black Rider: Night
Daisoujou: Night
Hell Biker: Fairy
Matador: Yoma
Pale Rider: Tyrant
Red Rider: Fairy
The Harlot: Tyrant
Trumpeter: Tyrant
White Rider: Yoma
