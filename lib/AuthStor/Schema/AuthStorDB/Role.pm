package AuthStor::Schema::AuthStorDB::Role;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('roles');
__PACKAGE__->add_columns(qw/role_id rolename/);
__PACKAGE__->set_primary_key('role_id');
__PACKAGE__->has_many(map_user_role => 'AuthStor::Schema::AuthStorDB::UserRole', 'role_id');


=head1 NAME

AuthStorDB::Role - A model object representing a class of access permissions to 
the system.

=head1 DESCRIPTION

This is an object that represents a row in the 'roles' table of your 
application database.  It uses DBIx::Class (aka, DBIC) to do ORM.

For Catalyst, this is designed to be used through MyApp::Model::MyAppDB.
"Offline" utilities may wish to use this class directly.

=cut

1;
