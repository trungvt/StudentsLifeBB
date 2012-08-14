package StudentsLifeForum::Controller::Topic;
use Moose;
use namespace::autoclean;
use StudentsLifeForum::Schema::Result::User;
use StudentsLifeForum::Schema::Result::Thread;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

StudentsLifeForum::Controller::Topic - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub topic :Chained('/'):PathPart('topic'): Args(1) {
    my ( $self, $c, $topic_id ) = @_;
	
	if ($topic_id != 'new_thread') {
		$c->stash(users_rs => $c->model('StudentsLifeDB::User'));
		my @threads_list = [$c->model('StudentsLifeDB::Thread')->search({topic_id => $topic_id})];
		$c->stash(threads => @threads_list);
		
		if ( $c->model('StudentsLifeDB::Thread')->search({topic_id => $topic_id})->count == 0) {
			$c->stash(empty_threads_list => 'No Threads in this topic');
		}
		$c->stash(template => 'Topic.tt2');
	} else {
		$c->stash(template => 'NewThread.tt2');
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
