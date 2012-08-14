use strict;
use warnings;
use Test::More;


use Catalyst::Test 'StudentsLifeForum';
use StudentsLifeForum::Controller::Thread;

ok( request('/thread')->is_success, 'Request should succeed' );
done_testing();
