package Games::SMTNocturne::Fusion;
use Games::SMTNocturne::Fusion::Demon;
use Games::SMTNocturne::Fusion::Chart;
use Sub::Exporter -setup => {
    exports => [
        qw(fuse fusions_for lookup_demon),
    ],
    groups => {
        default => [qw(fuse fusions_for lookup_demon)],
    },
};

=head1 NAME

Games::SMTNocturne::Fusion -

=head1 SYNOPSIS


=head1 DESCRIPTION


=cut

sub fuse {
    return Games::SMTNocturne::Fusion::Chart->fuse(@_);
}

sub fusions_for {
    return Games::SMTNocturne::Fusion::Chart->fusions_for(@_);
}

sub lookup_demon {
    return Games::SMTNocturne::Fusion::Demon->lookup(@_);
}

=head1 BUGS

No known bugs.

Please report any bugs through RT: email
C<bug-games-smtnocturne-fusion at rt.cpan.org>, or browse to
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-SMTNocturne-Fusion>.

=head1 SEE ALSO


=head1 SUPPORT

You can find this documentation for this module with the perldoc command.

    perldoc Games::SMTNocturne::Fusion

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Games-SMTNocturne-Fusion>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Games-SMTNocturne-Fusion>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Games-SMTNocturne-Fusion>

=item * Search CPAN

L<http://search.cpan.org/dist/Games-SMTNocturne-Fusion>

=back

=head1 AUTHOR

  Jesse Luehrs <doy at tozt dot net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Jesse Luehrs.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut

1;
