#!/usr/bin/perl -w
use strict;
package updateServer;

sub mysqlUpdate {
        my (@data) = @_;
	my $userName = $data[0];
	my $oldPassword = $data[1];
	my $newPassword = $data[2];
	my $hostname = $data[3];
	my $cmd = "mysql --user=$userName --password=$oldPassword --host=$hostname --execute=" . '"' . "UPDATE mysql.user SET Password=PASSWORD('$newPassword') WHERE User='$userName'; FLUSH PRIVILEGES;" . '"';
	system("$cmd");
	return "$userName $oldPassword $newPassword \n";
}
1;
