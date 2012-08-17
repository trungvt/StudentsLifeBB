package StudentsLifeForum::Controller::Login;
use Moose;
use namespace::autoclean;
use DateTime;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

StudentsLifeForum::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub base :Chained('/'):PathPart('login'): Args(0) {
    my ( $self, $c ) = @_;
   
   	#my $result = $c->model('StudentsLifeDB::User')->find( {username => 'guest'} );
   	#$c->stash(test => $result->created_date);
    $c->stash(template => 'Login.tt2');
}

sub login :Local :Args(0) {
    my ( $self, $c ) = @_;
    
    my $username = $c->request->params->{username};
    my $password = $c->request->params->{password};
    my $dt = DateTime->now(time_zone=>'local');
    #my $today = $dt->ymd.' '.$dt->hms;
    
    if ( $username && $password ) {
		if ($c->authenticate({ username => $username, password => $password, expiration => { '>=' => $dt }} ) ) {
	    	## user is signed in
	    	$c->response->redirect($c->uri_for( $c->controller('Index')->action_for('index')) );
	     	return;
		}
    	else {
    	     $c->stash(error_msg => "Bad username or password.");
    	}
    } else {
		$c->stash(error_msg => "Empty username or password.")
                unless ($c->user_exists);
    }
	
    $c->stash(template => 'Login.tt2');
}

sub logout :Chained('/'):PathPart('logout'): Args(0) {
    my ( $self, $c ) = @_;

    $c->logout();
    $c->stash(template => 'Logout.tt2');
}

=head1 AUTHOR

Ubuntu 11.04,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
