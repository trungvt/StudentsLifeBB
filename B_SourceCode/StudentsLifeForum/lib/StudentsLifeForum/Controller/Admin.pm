package StudentsLifeForum::Controller::Admin;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

StudentsLifeForum::Controller::Admin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub admin :Chained('/'):PathPart('administrator'): Args(0) {
    my ( $self, $c ) = @_;
	
	$c->stash(users_rs => $c->model('StudentsLifeDB::User'));
	$c->stash(roles_rs => $c->model('StudentsLifeDB::Role'));
	$c->stash(topics_rs => $c->model('StudentsLifeDB::Topic'));
	$c->stash(topics_threads_rs => $c->model('StudentsLifeDB::Topic'));
    $c->stash(template => 'Admin.tt2');
}

sub login :Local :Args(0) {
	my ( $self, $c ) = @_;	
		
	my $username = $c->request->params->{username};
    my $password = $c->request->params->{password};
    my $dt = DateTime->now;
    my $today = $dt->ymd.' '.$dt->hms;
    
    if ( $username && $password ) {
		if ($c->authenticate({ username => $username, password => $password, expiration => { '>=' => $today }} ) ) {
	    	## user is signed in
	    	$c->response->redirect("/administrator");
	     	return;
		}
    	else {
    	     $c->stash(error_msg => "Bad username or password.");
    	}
    } else {
		$c->stash(error_msg => "Empty username or password.")
                unless ($c->user_exists);
    }
}

sub set_roles :Chained('administrator'): PathPath('set_roles'): Args() {
	my ($self, $c) = @_;
	
	my $user = $c->stash->{user};
	if(lc $c->req->method eq 'post') {
		## Fetch all role ids submitted as a list
		my @roles = $c->req->param('role');
		$user->set_all_roles(@roles);
	}
	
	$c->res->redirect("/administrator");
}

sub set_all_roles {
	my ($self, @roleids) = @_;
	## Remove any existing roles, we're replacing them:
	$self->user_roles->delete;
	## Add new roles:
	foreach my $role_id (@roleids) {
		$self->user_roles->create({ role_id => $role_id });
	}
	return $self;
}

sub delete_user :Local :Args(0) {
	my ($self, $c) = @_;
	
	my $user_id = $c->request->params->{user_id};
	if ( $c->request->parameters->{form_submit} eq 'yes' ) {
		my $user = $c->model('StudentsLifeDB::User')->find({ id => $user_id }, { key => 'primary' });
		$user->user_roles->delete;
		$user->delete;
	}
	
	$c->response->redirect("/administrator");
}

sub make_admin :Local :Args(0) {
	my ($self, $c) = @_;
	
	my $user_id = $c->request->params->{user_id};
	if ( $c->request->parameters->{form_submit} eq 'yes' ) {
		my $user = $c->model('StudentsLifeDB::User')->find({ id => $user_id }, { key => 'primary' });
		$user->user_roles->create({ role_id => 1 });
	}
	
	$c->response->redirect("/administrator");
}

sub delete_topic :Local :Args(0) {
	my ($self, $c) = @_;
	
	my $topic_id = $c->request->params->{topic_id};
	if ( $c->request->parameters->{form_submit} eq 'yes' ) {
		my $topic = $c->model('StudentsLifeDB::Topic')->find({ id => $topic_id }, { key => 'primary' });
		$topic->threads->delete;
		$topic->delete;
	}
	
	$c->response->redirect("/administrator");
}

sub delete_thread :Local :Args(0) {
	my ($self, $c) = @_;
	
	my $thread_id = $c->request->params->{thread_id};
	if ( $c->request->parameters->{form_submit} eq 'yes' ) {
		my $thread = $c->model('StudentsLifeDB::Thread')->find({ id => $thread_id }, { key => 'primary' });
		$thread->posts->delete;
		$thread->delete;
	}
	
	$c->response->redirect("/administrator");
}

sub lock_thread :Local :Args(0) {
	my ($self, $c) = @_;
	
	my $thread_id = $c->request->params->{thread_id};
	if ( $c->request->parameters->{form_submit} eq 'yes' ) {
		my $thread = $c->model('StudentsLifeDB::Thread')->find({ id => $thread_id }, { key => 'primary' });
		$thread->update({
			is_activated => 0,
		});
	}
	$c->stash(status_msg => "Succeeded!");
	$c->response->redirect("/administrator");
}

=head1 AUTHOR

Ubuntu 11.04,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
