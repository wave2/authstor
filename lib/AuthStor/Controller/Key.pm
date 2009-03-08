package AuthStor::Controller::Key;

use strict;
use warnings;
use base 'Catalyst::Controller';
use File::Temp qw(tempfile);
use IO::Handle;
use GnuPG::Interface;

=head1 NAME

AuthStor::Controller::Key - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index : Private {
    my ( $self, $c ) = @_;

    $c->response->redirect($c->uri_for('/dashboard'));
}


sub gen : Local {
    my ( $self, $c ) = @_;

    my $keyDir = $c->config->{home}.'/keys';
    my $keyName = $c->request->params->{keyName} || "";
    my $keyEmail = $c->request->params->{keyEmail} || "";
    my $keyPassword = $c->request->params->{keyPassword} || "";

    #Form submission?
    if ( $c->request->parameters->{form_submit} ) {

      my $gnupg = GnuPG::Interface->new();
      $gnupg->options->hash_init( homedir => $keyDir );
      my ( $input, $output, $error ) = ( IO::Handle->new(),
                                     IO::Handle->new(),
                                     IO::Handle->new(),
                                   );
      my $handles = GnuPG::Handles->new( stdin      => $input,
                                     stdout     => $output,
                                     stderr     => $error,
                                   );
      my ($fh, $filename) = tempfile(); 
      my $gpgScript = <<END;
Key-Type: DSA
Key-Length: 1024
Subkey-Type: ELG-E
Subkey-Length: 1024
Name-Real: $keyName
Name-Comment: AuthStor Generated Key
Name-Email: $keyEmail
Expire-Date: 0
Passphrase: $keyPassword
%pubring $keyDir/$keyName.pub
%secring $keyDir/$keyName.sec
%commit
END
      print $fh $gpgScript;

      my $pid = $gnupg->wrap_call
      ( commands     => [ qw( --batch --gen-key ) ],
        command_args => [ $filename ],
        handles      => $handles,
      );

      File::Temp::cleanup();
    }

      $c->stash->{title} = 'Key';
      $c->stash->{template} = 'genKey.tt2';
      $c->forward('AuthStor::View::TT');
}


=head1 AUTHOR

Alan Snelson

=head1 LICENSE

See the file LICENSE for details.

=cut

1;
