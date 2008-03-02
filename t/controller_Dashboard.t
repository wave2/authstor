use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'AuthStor' }
BEGIN { use_ok 'AuthStor::Controller::Dashboard' }

ok( request('/dashboard')->is_success, 'Request should succeed' );


