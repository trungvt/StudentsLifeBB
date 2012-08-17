package StudentsLifeForum::Controller::Index;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

StudentsLifeForum::Controller::Index - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    
    my $result = $c->model('StudentsLifeDB::Topic')->search( undef );
    $c->stash(topics => [$c->model('StudentsLifeDB::Topic')->all]);
    
    # Check NEW
		my $now = DateTime->now(time_zone=>'local');
		my $epoch = $now->epoch;
		$epoch -= 24*60*60;
		my $yesterday = DateTime->from_epoch(epoch => $epoch, time_zone=>'local');
		$c->stash->{yesterday} = $yesterday;
    $c->stash(template => 'Index.tt2');
}

=head1 AUTHOR

Ubuntu 11.04,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
