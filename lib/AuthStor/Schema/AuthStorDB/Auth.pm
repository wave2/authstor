package AuthStor::Schema::AuthStorDB::Auth;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('auths');
__PACKAGE__->add_columns(qw/auth_id name username password uri created modified expires group_id description notes/);
__PACKAGE__->set_primary_key('auth_id');
__PACKAGE__->has_many(map_auth_tag => 'AuthStor::Schema::AuthStorDB::AuthTag', 'auth_id');
__PACKAGE__->has_many(map_auth_attachment => 'AuthStor::Schema::AuthStorDB::AuthAtt', 'auth_id');

=head1 NAME

AuthStorDB::Auth - A model object representing a person with access to the system.

=head1 DESCRIPTION

This is an object that represents a row in the 'users' table of your application
database.  It uses DBIx::Class (aka, DBIC) to do ORM.

For Catalyst, this is designed to be used through MyApp::Model::MyAppDB.
Offline utilities may wish to use this class directly.

=cut

1;
