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


=head1 AUTHOR

Ubuntu 11.04,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
