package StudentsLifeForum::Controller::Search;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

StudentsLifeForum::Controller::Search - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub do_search :Local :Args() {
	my ( $self, $c, $query ) = @_;
	
	$c->stash(template => 'Search.tt2');
	my $search = $c->request->params->{search_query};
	$c->stash(query => $search);
	my $thread_results = $c->model('StudentsLifeDB::Thread')->search([{ thread_subject => {-like => '%'.$search.'%'}},
                                            						  { body => {-like => '%'.$search.'%'}}]
																	);
	if ($thread_results->next){
        @{$c->stash->{'threads'}} = $thread_results->all();            
    }
	my $post_results = $c->model('StudentsLifeDB::Post')->search([ { body => {-like => '%'.$search.'%'}} ]);
	if ($post_results->next){
        @{$c->stash->{'posts'}} = $post_results->all();            
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
