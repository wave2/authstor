package AuthStor::Schema::AuthStorDB::Group;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('groups');
__PACKAGE__->add_columns(qw/group_id description name parent_id/);
__PACKAGE__->set_primary_key('group_id');

=head1 NAME

AuthStorDB::Group - A model object representing a person with access to the system.

=head1 DESCRIPTION

This is an object that represents a row in the 'users' table of your application
database.  It uses DBIx::Class (aka, DBIC) to do ORM.

For Catalyst, this is designed to be used through MyApp::Model::MyAppDB.
Offline utilities may wish to use this class directly.

=cut

1;
