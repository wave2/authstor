#!/usr/bin/perl -w
use strict;
package updateServer;

sub mean {
	my (@data) = @_;
	my $sum;
	$sum += $_ foreach(@data);
	return @data ? ($sum / @data) : 0;
}

sub median {
	my (@data)=sort { $a <=> $b} @_;
	if (scalar(@data) % 2) {
		return($data[@data /2]);
	}
	return(mean($data[@data /2],
		$data[@data / 2 -1]));
}
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
