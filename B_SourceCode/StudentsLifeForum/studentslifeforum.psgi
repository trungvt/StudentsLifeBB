use strict;
use warnings;

use StudentsLifeForum;

my $app = StudentsLifeForum->apply_default_middlewares(StudentsLifeForum->psgi_app);
$app;

