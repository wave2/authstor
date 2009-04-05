package AuthStor::Controller::notificationCenter;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

AuthStor::Controller::notificationCenter - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 FUNCTION BREAKDOWN

 Function: creategroup
 Last Modification and reason: 2/23/09: Began to add comments.
 Purpose: Used as the controller for any webpage auth<number>/updateserver. Uses basic catalyst conventions.
 Description:  This function is used to 


=cut


sub index : Private {
        my ( $self, $c ) = @_;
        $c->stash->{title} = 'Notification Center';
        $c->stash->{template} = 'notificationCenter.tt2';
        $c->forward('AuthStor::View::TT');

}

sub creategroup :  Regex('^notificationcenter/creategroup$') {
        my ( $self, $c ) = @_;
	my $someText="hello";
	my $auth = $c->model('AuthStorDB::NotifyGroups')->create( { group_name => "test" } );
        $c->stash->{title} = 'Notification Center';
        $c->stash->{template} = 'notificationCenterCreateGroup.tt2';
        $c->forward('AuthStor::View::TT');

}


sub editgroupproperties :  Regex('^notificationcenter/editgroupproperties$') {
        my ( $self, $c ) = @_;
        $c->stash->{title} = 'Notification Center';
        $c->stash->{template} = 'notificationCenter.tt2';
        $c->forward('AuthStor::View::TT');

}



sub sendemail : Regex('^notificationcenter/sendemail$') {
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
        $c->stash->{template} = 'notificationCenterSendEmail.tt2';
        $c->forward('AuthStor::View::TT');

}


=head1 AUTHOR

raul s lasluisa

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
