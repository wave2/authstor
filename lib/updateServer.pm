#!/usr/bin/perl -w
#use strict;
use Net::SSH::Perl;
use Exception::Class::TryCatch;
use warnings;
use FindBin;
package updateServer;

=head1 NAME

updateServer

=head1 DESCRIPTION

package create to update a varity of different severs.
As of 2/23/09
Linux, MySQL servers can be updated

=head1 METHODS

=cut

#########################################################################################################
#Function: linuxUpdate                                                                                  #
#Purpose: Used to upate Linux servers.                                                                  #
#Description:  This function is used to linux servers. The funtion reads a file named checkFileTime.sh  #
#Last Modification and reason:                                                                          #
#       2/23/09: Began to add comments.                                                                 #
#########################################################################################################

sub linuxUpdate {
#Set variables with input from the Auth updateServer controller
        my (@data) = @_;
        my $userName = $data[0];
        my $oldPassword = $data[1];
        my $newPassword = $data[2];
        my $hostname = $data[3];
        my $auth_id = $data[4];
#Location of linux update script. Read in the file and save it to a variable
	my $linuxscript="./lib/checkFileTime.sh";
	open(FILEREAD, "< $linuxscript");
	$line = <FILEREAD>;
	close FILEREAD;

	my $returnEval= '';
	$returnEval=eval
	{
	#Ssh into the linux box and execute 2 scripts. 1 to update the password. The 2nd to see if the update was sucessful.
		my $ssh = Net::SSH::Perl->new($hostname);
		$ssh->login($userName, $oldPassword);
		my($stdout, $stderr, $exit) = $ssh->cmd("cd ~;echo $oldPassword >>temp.txt;echo $newPassword >>temp.txt;echo $newPassword >>temp.txt;passwd <temp.txt;mv temp.txt temp1.txt");
    		my($stdout2, $stderr2, $exit2) = $ssh->cmd($line);
#		system("echo $stdout2");
        	if ( $stdout2 eq "successful\n" )
        	{
			return 0;
        	}
		else
		{
			return 1;
		}
	};
	if($@)
	{
		return 1;
	}
	if($returnEval==1)
	{
		return 1;
	}
	return 0;
}


#########################################################################################################
#Function: mysqlUpdate                                                                                  #
#Purpose: Used as the controller for any webpage auth<number>/updateserver. Uses basic catalyst         #
#       conventions.                                                                                    #
#Description:  This function is used to determine how to handle different type of server updates. Inside#
#       this funtion a different module named updateServer.pm to do the actual execution of updating    #
#       the server.                                                                                     #
#Last Modification and reason:                                                                          #
#       2/23/09: Began to add comments.                                                                 #
#########################################################################################################


sub mysqlUpdate {
#Set variables with input from the Auth updateServer controller
        my (@data) = @_;
	my $userName = $data[0];
	my $oldPassword = $data[1];
	my $newPassword = $data[2];
	my $hostname = $data[3];
	my $auth_id = $data[4];
#Set the sql script to update a users password
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

=head1 Author

Raul S Lasluisa

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
