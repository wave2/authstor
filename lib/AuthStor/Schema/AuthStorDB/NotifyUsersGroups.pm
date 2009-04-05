package AuthStor::Schema::AuthStorDB::NotifyUsersGroups;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("notify_users_groups");
__PACKAGE__->add_columns(
  "entry",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "user_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "group_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
);
__PACKAGE__->set_primary_key("entry");
__PACKAGE__->belongs_to(
  "user_id",
  "AuthStor::Schema::AuthStorDB::Users",
  { user_id => "user_id" },
);
__PACKAGE__->belongs_to(
  "group_id",
  "AuthStor::Schema::AuthStorDB::NotifyGroups",
  { group_id => "group_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04004 @ 2009-04-04 18:39:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XWydsPlYzx++JqkR+R/DTA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
