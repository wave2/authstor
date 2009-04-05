package AuthStor::Schema::AuthStorDB::NotifyGroups;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("notify_groups");
__PACKAGE__->add_columns(
  "group_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "group_name",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 50 },
);
__PACKAGE__->set_primary_key("group_id");
__PACKAGE__->has_many(
  "notify_users_groups",
  "AuthStor::Schema::AuthStorDB::NotifyUsersGroups",
  { "foreign.group_id" => "self.group_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04004 @ 2009-04-04 18:39:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FAJ2Nnt1+GjtE8Hbt7HytA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
