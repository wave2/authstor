package AuthStorDB::UserTag;

use base qw/DBIx::Class/;

# Load required DBIC stuff
__PACKAGE__->load_components(qw/PK::Auto Core/);
# Set the table name
__PACKAGE__->table('user_tags');
# Set columns in table
__PACKAGE__->add_columns(qw/user_id tag_id/);
# Set the primary key for the table
__PACKAGE__->set_primary_key(qw/user_id tag_id/);


#
# Set relationships:
#

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(user => 'AuthStorDB::User', 'user_id');

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(tag => 'AuthStorDB::Tag', 'tag_id');


=head1 NAME

AuthStorDB::UserTag - A model object representing the JOIN between Auths and Tags.

=head1 DESCRIPTION

This is an object that represents a row in the 'user_roles' table of your application
database.  It uses DBIx::Class (aka, DBIC) to do ORM.

You probably won't need to use this class directly -- it will be automatically
used by DBIC where joins are needed.

For Catalyst, this is designed to be used through MyApp::Model::MyAppDB.
Offline utilities may wish to use this class directly.

=cut

1;
