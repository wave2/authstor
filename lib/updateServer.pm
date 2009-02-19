#!/usr/bin/perl -w
use strict;
use Net::SSH::Perl;
package updateServer;

sub linuxUpdate {
        my (@data) = @_;
        my $userName = $data[0];
        my $oldPassword = $data[1];
        my $newPassword = $data[2];
        my $hostname = $data[3];
        my $auth_id = $data[4];
	my $ssh = Net::SSH::Perl->new($hostname);
	$ssh->login($userName, $oldPassword)||return 1;
	my $cmd1 = "cd ~;echo $oldPassword>>temp.txt;echo $newPassword>>temp.txt;echo $newPassword>>temp.txt;";
	my $cmd2 = "passwd <temp.txt;";
	my $cmd3 = "rm temp.txt";
	my $cmd = $cmd1.$cmd2.$cmd3;
    	my($stdout, $stderr, $exit) = $ssh->cmd($cmd);
	if ( $exit eq "0") {
		system("touch pass.txt");
		return 0;
	} else {
		system("touch failed.txt");
		return 1;
	}
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
