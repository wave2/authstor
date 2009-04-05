package AuthStor::Controller::notify;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Crypt::GPG;
use Data::FormValidator;
use Digest::MD5;
use File::MimeInfo::Magic;
use IO::Scalar;
use FindBin;
use lib "$FindBin::Bin/../../../lib";


=head1 NAME

AuthStor::Controller::notify - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller. This controller is use to handle all the email notification functionality for AuthStor. 
List of functions:
-addition of user to an email group is done
-send emails
-send email notification after an auth has been updated.

=cut

=head1 FUNCTION BREAKDOWN

=cut


=head1 AUTHOR

raul s lasluisa

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
