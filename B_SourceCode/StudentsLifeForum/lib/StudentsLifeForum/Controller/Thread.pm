package StudentsLifeForum::Controller::Thread;
use Moose;
use namespace::autoclean;
use StudentsLifeForum::Schema::Result::User;
use DateTime;
use Data::Page;

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
	if ( $thread != undef ) {
		my $owner_rs = $c->model('StudentsLifeDB::User');
		my $owner = $owner_rs->find({ id => $thread->owner_id, key => 'primary' });
		$c->stash(thread => $thread);
		$c->stash(owner => $owner);
	
		# Prepare data for all related posts
		my $page = $c->request->param('page');
  		$page = 1 if($page !~ /^\d+$/);
  		my $posts_list = $c->model('StudentsLifeDB::Post')->search({ thread_id => $thread_id }, { page => $page, rows => 5, });
  		$c->stash->{pager} = $posts_list->pager; 
		$c->stash(posts => [$posts_list->all]);
		$c->stash(thread_id => $thread_id, template => 'Thread.tt2');
	} else {
		$c->stash(error_message => 'No resource found!', template => 'Error.tt2');
	}
}

sub send_post :Local :Args(0) {
	my ( $self, $c ) = @_;
	
	my $threads_rs = $c->model('StudentsLifeDB::Thread');
	my $thread_id = $c->request->params->{thread_id};
	my $body = $c->request->params->{body};
    my $image_path = $c->request->params->{image};
    my $created_date = DateTime->now(time_zone=>'local');
   	#my $created_date = $dt->ymd.' '.$dt->hms;
   	
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
   			
	   		my $thread = $threads_rs->find({ id => $thread_id, key => 'primary' });
	   		$thread->update({ created_date => $created_date, });
	   		$thread->posts->create({ body => $body,
	   								 image_path => $image_path,
	   								 created_date => $created_date,
	   								 sender_id => $owner_id
	   							    });
		 } else {
		   	# Guest post a new reply
		   	my $thread = $threads_rs->find({ id => $thread_id, key => 'primary' });
		   	$thread->posts->create({ body => $body,
		   							 image_path => $image_path,
		   							 created_date => $created_date,
		   						    });
		}
   	} else {
   		$c->stash(error_msg => 'Fill the content to post!') unless ($c->user_exists);
   	}
   	
   	#my $url_redirect = "/thread/$thread_id";
   	$c->response->redirect("/thread/$thread_id");
}

sub post_delete :Local :Args(0) {
	my ( $self, $c ) = @_;
	
	my $post_id = $c->request->params->{post_id};
	my $thread_id = $c->request->params->{thread_id};
	
	if ( $c->request->parameters->{form_submit} eq 'yes' ) {
		my $post = $c->model('StudentsLifeDB::Post')->find({ id => $post_id }, { key => 'primary' });
		$post->delete();
		
		$c->response->redirect("/thread/$thread_id");
	}
}

sub main_thread_delete :Local :Args(0) {
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
