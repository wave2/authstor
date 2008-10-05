package AuthStor::Schema::AuthStorDB::AuthAtt;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('auth_atts');
__PACKAGE__->add_columns(qw/auth_id att_id/);
__PACKAGE__->set_primary_key(qw/auth_id att_id/);
__PACKAGE__->belongs_to(auth => 'AuthStor::Schema::AuthStorDB::Auth', 'auth_id');
__PACKAGE__->belongs_to(attachment => 'AuthStor::Schema::AuthStorDB::Attachment', 'att_id');

=head1 NAME

AuthStorDB::AuthAtt - A model object representing the JOIN between Auths and Tags.

=head1 DESCRIPTION

This is an object that represents a row in the 'user_roles' table of your application
database.  It uses DBIx::Class (aka, DBIC) to do ORM.

You probably won't need to use this class directly -- it will be automatically
used by DBIC where joins are needed.

For Catalyst, this is designed to be used through MyApp::Model::MyAppDB.
Offline utilities may wish to use this class directly.

=cut

1;
