package AuthStor::Schema::AuthStorDB::UserRole;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('user_roles');
__PACKAGE__->add_columns(qw/user_id role_id/);
__PACKAGE__->set_primary_key(qw/user_id role_id/);
__PACKAGE__->belongs_to(user => 'AuthStor::Schema::AuthStorDB::User', 'user_id');
__PACKAGE__->belongs_to(role => 'AuthStor::Schema::AuthStorDB::Role', 'role_id');


=head1 NAME

AuthStorDB::UserRole - A model object representing the JOIN between Users and Roles.

=head1 DESCRIPTION

This is an object that represents a row in the 'user_roles' table of your application
database.  It uses DBIx::Class (aka, DBIC) to do ORM.

You probably won't need to use this class directly -- it will be automatically
used by DBIC where joins are needed.

For Catalyst, this is designed to be used through MyApp::Model::MyAppDB.
Offline utilities may wish to use this class directly.

=cut

1;
