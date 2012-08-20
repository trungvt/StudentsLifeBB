package StudentsLifeForum::Controller::Register;
use Moose;
use namespace::autoclean;
use DateTime;
use String::Random;
use Digest::SHA1 qw(sha1_hex);

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

StudentsLifeForum::Controller::Register - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub base :Chained('/'):PathPart('register'): Args(0) {
    my ($self, $c) = @_;
   	
    $c->stash(template => 'Register.tt2');
}

sub register :Local :Args(0) {
	my ($self, $c) = @_;
	
	my $username = $c->request->params->{username};
    my $password = $c->request->params->{password};
    my $email = $c->request->params->{email};
    my $avatar = $c->request->params->{avatar};
	my $random = new String::Random;
    my $salt = $random->randpattern("C!cn");
	$password = sha1_hex($salt . $password);
    
    my $check_user = $c->model('StudentsLifeDB::User')->search({ username => $username});
    my $check_email = $c->model('StudentsLifeDB::User')->search({ email => $email });
    
    if ($check_user != undef) {
    	$c->stash(error_msg => 'Username is existed! Try again!', template => 'Register.tt2');
    } elsif ($check_email != undef) {
    	$c->stash(error_msg => 'Email has already been used! Try again!', template => 'Register.tt2');
    } else {
    	my $users_rs = $c->model('StudentsLifeDB::User');
    	my $created_date = DateTime->now(time_zone=>'local');
    	my $dt = DateTime->now(time_zone=>'local');
    	
    	my $new_user = $users_rs->create({
			username => $username,
			email => $email,
			password => $password,
			created_date => $created_date,
			avatar => $avatar,
			salt => $salt
		});
		
		$new_user->user_roles->create({ role_id => 2 });
		
		if ($new_user->id > 0) {
			if ($c->authenticate({ username => $new_user->username, password => $new_user->password, expiration => { '>=' => $dt }} )) {
	    		$c->stash(status_msg => 'Registering Succeed!', template => 'Index.tt2');
	     		return;
			}
		} else {
			$c->stash(error_msg => 'Something wrong! Sorry, try again!', template => 'Register.tt2');
		}
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
