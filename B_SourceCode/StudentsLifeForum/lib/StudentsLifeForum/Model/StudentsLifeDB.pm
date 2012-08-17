package StudentsLifeForum::Model::StudentsLifeDB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'StudentsLifeForum::Schema',
    
    connect_info => {
        dsn => 'dbi:SQLite:db/studentslife.db',
        user => '',
        password => '',
    }
);

=head1 NAME

StudentsLifeForum::Model::StudentsLifeDB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<StudentsLifeForum>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<StudentsLifeForum::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.6

=head1 AUTHOR

Ubuntu 11.04

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;