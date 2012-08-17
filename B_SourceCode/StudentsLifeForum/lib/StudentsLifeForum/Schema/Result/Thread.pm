use utf8;
package StudentsLifeForum::Schema::Result::Thread;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

StudentsLifeForum::Schema::Result::Thread

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
use StudentsLifeForum::Schema::Result::User;
use DateTime;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<threads>

=cut

__PACKAGE__->table("threads");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 thread_subject

  data_type: 'text'
  is_nullable: 1

=head2 body

  data_type: 'text'
  is_nullable: 1

=head2 topic_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 created_date

  data_type: 'text'
  is_nullable: 1

=head2 owner_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 image_path

  data_type: 'text'
  is_nullable: 1

=head2 is_activated

  data_type: 'boolean'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "thread_subject",
  { data_type => "text", is_nullable => 1 },
  "body",
  { data_type => "text", is_nullable => 1 },
  "topic_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "created_date",
  { data_type => "text", is_nullable => 1 },
  "owner_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "image_path",
  { data_type => "text", is_nullable => 1 },
  "is_activated",
  { data_type => "boolean", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<thread_subject_unique>

=over 4

=item * L</thread_subject>

=back

=cut

__PACKAGE__->add_unique_constraint("thread_subject_unique", ["thread_subject"]);

=head1 RELATIONS

=head2 owner

Type: belongs_to

Related object: L<StudentsLifeForum::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "owner",
  "StudentsLifeForum::Schema::Result::User",
  { id => "owner_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 posts

Type: has_many

Related object: L<StudentsLifeForum::Schema::Result::Post>

=cut

__PACKAGE__->has_many(
  "posts",
  "StudentsLifeForum::Schema::Result::Post",
  { "foreign.thread_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 topic

Type: belongs_to

Related object: L<StudentsLifeForum::Schema::Result::Topic>

=cut

__PACKAGE__->belongs_to(
  "topic",
  "StudentsLifeForum::Schema::Result::Topic",
  { id => "topic_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-08-06 20:14:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Tv8dfNWBbIGWNC9Uq0UOPQ

__PACKAGE__->add_columns(
    'created_date'  => {
        data_type  => "DateTime"
    },
);

sub has_numbers_of_posts {
    my ($self, $thread) = @_;
    
    return $self->posts->search({ thread_id => $thread->id})->count;
};

sub get_latest_post {
	my ($self, $thread) = @_;
	
	if ( $thread->has_numbers_of_posts($thread) > 0 ) {
		return $thread->posts->search({ thread_id => $thread->id }, {order_by => 'created_date DESC'})->first;
	} else {
		return $thread;
	}
};

sub get_latest_post_date {
	my ($self, $thread) = @_;
	
	if ( $self->has_numbers_of_posts($self) > 0 ) {
		return $self->posts->search({ thread_id => $self->id }, {order_by => 'created_date DESC'})->first->created_date;
	} else {
		return $self->created_date;
	}
}

#sub author_name_of_thread {
#    my ($self, $owner_id) = @_;

#    return $self->users->search({ id => $owner_id})->username;
#}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
