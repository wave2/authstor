package AuthStor::Schema::AuthStorDB;

use strict;
use warnings;

use base 'DBIx::Class::Schema';

#__PACKAGE__->load_classes;
__PACKAGE__->load_classes(qw/Auth AuthTag Attachment AuthAtt AuthGroup Tag User UserRole UserTag Role NotifyGroups/);



# Created by DBIx::Class::Schema::Loader v0.04004 @ 2009-04-04 18:39:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0JtIw1GrFfJRts6pCpoKag


# You can replace this text with custom content, and it will be preserved on regeneration
1;
