use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'AuthStor' }
BEGIN { use_ok 'AuthStor::Controller::Login' }

ok( request('/login')->is_success, 'Request should succeed' );


