package WWW::Google::Places::Params;

$WWW::Google::Places::Params::VERSION = '0.05';

use 5.006;
use strict; use warnings;
use parent 'Exporter';
use Data::Dumper;

our @EXPORT_OK = qw(validate $FIELDS);

use WWW::Google::Places::CONSTANTS qw($PLACE_TYPES $MORE_PLACE_TYPES);

my $_check_location = sub {
    my $location = shift;

    my ($latitude, $longitude);
    die "ERROR: Invalid location type data found [$_]"
        unless (($location =~ /\,/)
                &&
                ((($latitude, $longitude) = split/\,/,$location,2)
                 &&
                 (($latitude =~ /^\-?\d+\.?\d+$/)
                  &&
                  ($longitude =~ /^\-?\d+\.?\d+$/)
                 )
                ))
};

my $_check_types = sub {
    my $types = shift;

    my @types = ();
    die "ERROR: Invalid search type data [$types]"
        unless (defined($types)
                &&
                (@types = split/\|/,$types)
                &&
                (map { exists($PLACE_TYPES->{lc($_)})
                           ||
                           exists($MORE_PLACE_TYPES->{lc($_)})
                 } @types ));
};

my $_check_num = sub {
    my $num = shift;

    die "ERROR: Invalid NUM data type [$num]"
        unless ($num =~ /^\d+$/);
};

my $_check_str = sub {
    my $str = shift;

    die "ERROR: Invalid STR data type [$str]"
        if ($str =~ /^\d+$/);
};

=head1 NAME

WWW::Google::Places::Params - Placeholder for parameters for WWW::Google::Places

=head1 VERSION

Version 0.05

=cut

our $FIELDS = {
    'location' => { optional => 0, check => $_check_location, type => 's' },
    'radius'   => { optional => 0, check => $_check_num,      type => 'd' },
    'name'     => { optional => 1, check => $_check_str,      type => 's' },
    'types'    => { optional => 1, check => $_check_types,    type => 's' },
};

sub validate {
    my ($fields, $values) = @_;

    die "ERROR: Missing params list."
        unless (defined $values && ref($values) eq 'HASH');

    foreach my $field (@{$fields}) {
        die "ERROR: Invalid param received [$field]"
            unless (exists $FIELDS->{$field});

        unless ($FIELDS->{$field}->{optional}) {
            die "ERROR: Parameter [$field] undefined."
                unless (defined $values->{$field});
        }

        $FIELDS->{$field}->{check}->($values->{$field});
    }
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-google-places at rt.cpan.org>,
or through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Google-Places>.
I will be notified, and then you'll automatically be notified of progress on your
bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Google::Places::Params

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Google-Places>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-Google-Places>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-Google-Places>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-Google-Places/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2014 Mohammad S Anwar.

This  program  is  free software; you can redistribute it and/or modify it under
the  terms  of the the Artistic License (2.0). You may obtain a copy of the full
license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any  use,  modification, and distribution of the Standard or Modified Versions is
governed by this Artistic License.By using, modifying or distributing the Package,
you accept this license. Do not use, modify, or distribute the Package, if you do
not accept this license.

If your Modified Version has been derived from a Modified Version made by someone
other than you,you are nevertheless required to ensure that your Modified Version
 complies with the requirements of this license.

This  license  does  not grant you the right to use any trademark,  service mark,
tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge patent license
to make,  have made, use,  offer to sell, sell, import and otherwise transfer the
Package with respect to any patent claims licensable by the Copyright Holder that
are  necessarily  infringed  by  the  Package. If you institute patent litigation
(including  a  cross-claim  or  counterclaim) against any party alleging that the
Package constitutes direct or contributory patent infringement,then this Artistic
License to you shall terminate on the date that such litigation is filed.

Disclaimer  of  Warranty:  THE  PACKAGE  IS  PROVIDED BY THE COPYRIGHT HOLDER AND
CONTRIBUTORS  "AS IS'  AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES. THE IMPLIED
WARRANTIES    OF   MERCHANTABILITY,   FITNESS   FOR   A   PARTICULAR  PURPOSE, OR
NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY YOUR LOCAL LAW. UNLESS
REQUIRED BY LAW, NO COPYRIGHT HOLDER OR CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL,  OR CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE
OF THE PACKAGE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

1; # End of WWW::Google::Places::Params
