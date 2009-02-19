#!/usr/bin/perl -w
use strict;
package updateServer;

sub linuxUpdate {
        my (@data) = @_;
        my $userName = $data[0];
        my $oldPassword = $data[1];
        my $newPassword = $data[2];
        my $hostname = $data[3];
        my $auth_id = $data[4];
	#my $cmd = "ssh $hostname" . '"' . "touch temp.txt; echo -e '$oldPassword

}

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
		return "1";
	} else {
		return "0";
	}
	#return "1";
}
1;
