package StudentsLifeForum::Controller::Thread;
use Moose;
use namespace::autoclean;
use StudentsLifeForum::Schema::Result::User;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

StudentsLifeForum::Controller::Thread - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub thread :Chained('/'):PathPart('thread'): Args(1) {
    my ( $self, $c, $thread_id ) = @_;
	
	# Prepare data for thread details
	my $thread = $c->model('StudentsLifeDB::Thread')->find({ id => $thread_id, key => 'primary' });
	my $owner_rs = $c->model('StudentsLifeDB::User');
	my $owner = $owner_rs->find({ id => $thread->owner_id, key => 'primary' });
	$c->stash(thread => $thread);
	$c->stash(owner => $owner);
	
	# Prepare data for all related posts
	my $posts = $thread->posts->all;
	$c->stash(posts => $posts);
    $c->stash(thread_id => $thread_id, template => 'Thread.tt2');
}

sub send_post :Local :Args(0) {
	
}

=head1 AUTHOR

Ubuntu 11.04,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
