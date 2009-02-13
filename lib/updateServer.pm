#!/usr/bin/perl -w
use strict;
package updateServer;

sub mysqlUpdate {
        my (@data) = @_;
	my $userName = $data[0];
	my $oldPassword = $data[1];
	my $newPassword = $data[2];
	my $hostname = $data[3];
	my $auth_id = $data[4];
	my $cmd = "mysql --user=$userName --password=$oldPassword --host=$hostname --execute=" . '"' . "UPDATE mysql.user SET Password=PASSWORD('$newPassword') WHERE User='$userName'; FLUSH PRIVILEGES;" . '"';
	my $returnMySQL=`$cmd 2>&1`;
	if ( $returnMySQL ne ''  ) {
	#something happened
		$cmd = "mysql --user=$userName --password=$newPassword --host=$hostname --execute=" . '"' . "UPDATE authstor.auths SET updating_server = '0', failed_attempt = '1' WHERE auths.auth_id =$auth_id LIMIT 1;" . '"'; 
		system("$cmd");
	} else {
		$cmd = "mysql --user=$userName --password=$newPassword --host=$hostname --execute=" . '"' . "UPDATE authstor.auths SET updating_server = '0', failed_attempt = '0' WHERE auths.auth_id =$auth_id LIMIT 1;" . '"'; 
		system("$cmd");
	}
	return "$userName $oldPassword $newPassword \n";
}
1;
