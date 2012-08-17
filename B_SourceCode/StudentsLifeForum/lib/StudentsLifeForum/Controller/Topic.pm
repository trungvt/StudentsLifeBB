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
		#$c->stash(topics_rs => $c->model('StudentsLifeDB::Topic'));
		my $topic = $c->model('StudentsLifeDB::Topic')->find({ id => $topic_id }, { key => 'primary' });
		$c->stash(topic => $topic);
		$c->stash(users_rs => $c->model('StudentsLifeDB::User'));
		
		if ( $c->model('StudentsLifeDB::Thread')->search({topic_id => $topic_id})->count == 0) {
			$c->stash(empty_threads_list => 'No Threads in this topic');
		}
		
		# Paging
		my $page = $c->request->param('page');
  		$page = 1 if($page !~ /^\d+$/);
  		my $threads_list = $c->model('StudentsLifeDB::Thread')->search({ topic_id => $topic_id }, 
  																	   { order_by => 'created_date DESC'},
  																	   { page => $page, rows => 5, });
  		$c->stash->{pager} = $threads_list->pager;
		$c->stash(threads => [$threads_list->all]);
		
		# Check NEW
		my $now = DateTime->now(time_zone=>'local');
		my $epoch = $now->epoch;
		$epoch -= 24*60*60;
		my $yesterday = DateTime->from_epoch(epoch => $epoch, time_zone=>'local');
		$c->stash->{yesterday} = $yesterday;
		$c->stash(template => 'Topic.tt2');
	} else {
		$c->stash(template => 'NewThread.tt2');
	}
}

sub send_thread :Local :Args(0) {
	my ( $self, $c ) = @_;
	
	my $topics_rs = $c->model('StudentsLifeDB::Topic');
	my $topic_id = $c->request->params->{topic_id};
	my $subject = $c->request->params->{subject};
	my $body = $c->request->params->{body};
    my $image_path = $c->request->params->{image};
    my $created_date = DateTime->now(time_zone=>'local');
   	
   	# Has an user logged in
   	if ( $body ) {
   		if ( $c->request->parameters->{form_submit} eq 'yes' ) {
	   		if ( my $upload = $c->request->upload('upload_image') ) {
			    my $filename = $upload->filename;
			    my $target   = $c->config->{upload_abs}."/$filename";
             	my $file_uri = $c->config->{upload_dir}."/$filename";
             	$image_path = $file_uri;
			    
			    unless ($upload->link_to( $target) || $upload->copy_to($target)) {
                 die ("Failed to copy '$filename' to '$target': $!");    
             	}
			}
   		}
        
   		if ( $c->user_exists() ) {
   			my $owner_id = $c->user->get('id');
   			
	   		my $topic = $topics_rs->find({ id => $topic_id, key => 'primary' });
	   		$topic->threads->create({ thread_subject => $subject, 
	   								 body => $body,
	   								 image_path => $image_path,
	   								 created_date => $created_date,
	   								 owner_id => $owner_id,
	   								 is_activated => 1
	   							    });
		}
   	} else {
   		$c->stash(error_msg => 'Fill the content to post!') unless ($c->user_exists);
   	}
   	
   	#my $url_redirect = "/thread/$thread_id";
   	$c->response->redirect("/topic/$topic_id");
}

sub thread_delete :Local :Args(0) {
	my ( $self, $c ) = @_;
	
	my $topic_id = $c->request->params->{topic_id};
	my $thread_id = $c->request->params->{thread_id};
	
	if ( $c->request->parameters->{form_submit} eq 'yes' ) {
		my $thread = $c->model('StudentsLifeDB::Thread')->find({ id => $thread_id }, { key => 'primary' });
		$thread->posts->delete;
		$thread->delete();
		
		$c->response->redirect("/topic/$topic_id");
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
