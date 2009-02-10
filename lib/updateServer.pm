#!/usr/bin/perl -w
use strict;
package updateServer;

sub mysqlUpdate {

        my (@data) = @_;
	my $userName = $data[0];
	my $oldPassword = $data[1];
	my $newPassword = $data[2];
	my $cmd = "mysql --user=$userName --password=$oldPassword --execute=" . '"' . "UPDATE mysql.user SET Password=PASSWORD('$newPassword') WHERE User='$userName'; FLUSH PRIVILEGES;" . '"';
	print "$cmd\n";
	system("$cmd");

	return "$userName $oldPassword $newPassword \n";
}
1;
