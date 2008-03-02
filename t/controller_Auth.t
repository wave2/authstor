use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'AuthStor' }
BEGIN { use_ok 'AuthStor::Controller::Auth' }

ok( request('/auth')->is_success, 'Request should succeed' );


