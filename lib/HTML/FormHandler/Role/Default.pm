package HTML::FormHandler::Role::Default;

use 5.006;
use strict;
use warnings;

=pod

    package MyApp::Form::Help;

    with 'HTML::FormHandler::Role::Default'

=cut


use Moose::Role;

has 'dbic_column_spec' => (
    trait => ['Hash'],
    is => 'ro',
    isa => 'HashRef',
    lazy_build => 1,
    handles => {
        field_spec => 'kv',
    }
); 

sub _build_dbic_column_spec {
    return  $_[0]->item->result_source->columns_info;
}

has 'default_column_spec' => (
    trait => ['Hash'],
    is => 'ro',
    isa => 'HashRef',
    lazy_build => 1,
    handles => {
        column_spec => 'kv',
    }
);

sub _build_default_column_spec {
    my $default_column_spec;
    for my $field ($_[0]->field_spec) {
        $_[0]->field_exists($field->[0]) && exists $field->[1]->{default_value} 
            && $field->[1]->{data_type} ne 'timestamp' or next;
        $default_column_spec->{$field->[0]} = $field->[1]->{default_value};
    }
    return $default_column_spec;
}

sub _field_exists {
    $_[0]->field($_[1]) or 0;
}

before render => sub {
    for my $column ( $_[0]->column_spec ) {
        unless ($_[0]->field($column->[0])->value) {
            $_[0]->field($column->[0])->value($column->[1]);
        }
    }
};        

no Moose::Role;

1;
__END__

=head1 AUTHOR

lnation, C<< <thisusedtobeanemail at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-html-formhandler-role-default at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=HTML-FormHandler-Role-Default>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc HTML::FormHandler::Role::Default


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=HTML-FormHandler-Role-Default>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/HTML-FormHandler-Role-Default>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/HTML-FormHandler-Role-Default>

=item * Search CPAN

L<http://search.cpan.org/dist/HTML-FormHandler-Role-Default/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2016 lnation.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

