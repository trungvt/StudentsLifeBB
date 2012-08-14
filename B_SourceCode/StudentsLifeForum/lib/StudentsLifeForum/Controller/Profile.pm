package StudentsLifeForum::Controller::Profile;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

StudentsLifeForum::Controller::Profile - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub base :Chained('/'):PathPart('profile'): Args(1) {
    my ( $self, $c, $user_id ) = @_;
	my $user = $c->model('StudentsLifeDB::User')->find({ id => $user_id, key => 'primary' });
	$c->stash(user => $user);
    $c->stash(template => 'Profile.tt2');
}

sub after_register :Chained('/'):PathPart('profile'): Args(2) {
    my ( $self, $c, $user_id, $status ) = @_;
    if ($status == 'register_succeeded') {
    	my $user = $c->model('StudentsLifeDB::User')->find({ id => $user_id, key => 'primary' });
		$c->stash(user => $user);
    	$c->stash(template => 'Profile.tt2');
    }
}


=head1 AUTHOR

Ubuntu 11.04,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
