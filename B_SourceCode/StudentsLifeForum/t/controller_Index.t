use strict;
use warnings;
use Test::More;


use Catalyst::Test 'StudentsLifeForum';
use StudentsLifeForum::Controller::Index;

ok( request('/index')->is_success, 'Request should succeed' );
done_testing();
