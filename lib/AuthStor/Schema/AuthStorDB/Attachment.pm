package AuthStor::Schema::AuthStorDB::Attachment;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('attachments');
__PACKAGE__->add_columns(qw/att_id filename md5sum/);
__PACKAGE__->set_primary_key('att_id');
__PACKAGE__->has_many(auth_atts => 'AuthStor::Schema::AuthStorDB::AuthAtt', 'att_id');


=head1 NAME

AuthStorDB::Attachment - A model object representing an attachment.

=head1 DESCRIPTION

This is an object that represents a row in the 'users' table of your application
database.  It uses DBIx::Class (aka, DBIC) to do ORM.

For Catalyst, this is designed to be used through MyApp::Model::MyAppDB.
Offline utilities may wish to use this class directly.

=cut

1;
