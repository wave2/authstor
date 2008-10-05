package AuthStor::Model::AuthStorDB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'AuthStor::Schema::AuthStorDB',
    connect_info => [
        'dbi:mysql:authstor',
        'authuser',
        'YoMagnum',
        
    ],
);

=head1 NAME

AuthStor::Model::AuthStorDB - Catalyst DBIC Schema Model
=head1 SYNOPSIS

See L<AuthStor>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<BinaryStorDB>

=head1 AUTHOR

Charlie &

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
