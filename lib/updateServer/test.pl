#!/usr/bin/perl -w

use updateServer;
use strict;

my $userName = $ARGV[0];
my $oldPassword = $ARGV[1];
my $newPassword = $ARGV[2];
updateServer::mysqlUpdate("$userName", "$oldPassword", "$newPassword");
