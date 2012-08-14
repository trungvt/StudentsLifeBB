use strict;
use warnings;
use Test::More;


use Catalyst::Test 'StudentsLifeForum';
use StudentsLifeForum::Controller::Topic;

ok( request('/topic')->is_success, 'Request should succeed' );
done_testing();
