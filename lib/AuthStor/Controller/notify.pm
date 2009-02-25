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

sub index :Path :Args(0) {
	my ( $self, $c ) = @_;
	if ( $c->request->parameters->{form_submit} ) 
	{
		my $dfv_profile =
		{
			field_filters => {
			tags => [qw/trim strip/],
		},
			required => [ qw(touser subject bodyofemail ) ],
		};
		my $results = Data::FormValidator->check($c->req->parameters, $dfv_profile);
		if ($results->has_invalid or $results->has_missing) {
		# do something with $results->invalid, $results->missing
			$c->stash->{errormsg} = $results->msgs;
		} 
		else 
		{
			my $to=$c->request->parameters->{touser};
			my $from= 'EMAIL@YOURDOMAIN.COM';
			my $subject=$c->request->parameters->{subject};
			my $body=$c->request->parameters->{bodyofemail};
			open(MAIL, "|/usr/sbin/sendmail -t");
		#Mail Header
			print MAIL "To: $to\n";
			print MAIL "From: $from\n";
			print MAIL "Subject: $subject\n\n";
		#Mail Body
			print MAIL "$body \n";
			close(MAIL);
		}
	}
	$c->stash->{title} = 'Notification Center';
	$c->stash->{template} = 'notificationCenter.tt2';
	$c->forward('AuthStor::View::TT');
}


=head1 AUTHOR

raul s lasluisa

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
