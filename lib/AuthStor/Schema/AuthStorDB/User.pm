package AuthStor::Schema::AuthStorDB::User;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('users');
__PACKAGE__->add_columns(qw/user_id username password email_address first_name last_name mobile active description/);
__PACKAGE__->set_primary_key('user_id');
__PACKAGE__->has_many(map_user_role => 'AuthStor::Schema::AuthStorDB::UserRole', 'user_id');
__PACKAGE__->has_many(map_auth_history => 'AuthStor::Schema::AuthStorDB::AuthHistory', 'user_id');
__PACKAGE__->many_to_many(roles => 'map_user_role', 'role');

=head1 NAME

AuthStorDB::User - A model object representing a person with access to the system.

=head1 DESCRIPTION

This is an object that represents a row in the 'users' table of your application
database.  It uses DBIx::Class (aka, DBIC) to do ORM.

For Catalyst, this is designed to be used through MyApp::Model::MyAppDB.
Offline utilities may wish to use this class directly.

=cut

1;
