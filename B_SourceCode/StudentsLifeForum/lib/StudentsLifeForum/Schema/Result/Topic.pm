use utf8;
package StudentsLifeForum::Schema::Result::Topic;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

StudentsLifeForum::Schema::Result::Topic

=cut

use strict;
use warnings;

use StudentsLifeForum::Schema::Result::Thread;
use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<topics>

=cut

__PACKAGE__->table("topics");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 topic_name

  data_type: 'text'
  is_nullable: 1

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 category

  data_type: 'text'
  is_nullable: 1

=head2 created_date

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "topic_name",
  { data_type => "text", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "category",
  { data_type => "text", is_nullable => 1 },
  "created_date",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<category_unique>

=over 4

=item * L</category>

=back

=cut

__PACKAGE__->add_unique_constraint("category_unique", ["category"]);

=head2 C<topic_name_unique>

=over 4

=item * L</topic_name>

=back

=cut

__PACKAGE__->add_unique_constraint("topic_name_unique", ["topic_name"]);

=head1 RELATIONS

=head2 threads

Type: has_many

Related object: L<StudentsLifeForum::Schema::Result::Thread>

=cut

__PACKAGE__->has_many(
  "threads",
  "StudentsLifeForum::Schema::Result::Thread",
  { "foreign.topic_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-08-06 20:14:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9QFOQ8Dk9rwq5ANpwg5nmw

sub has_numbers_of_threads {
    my ($self, $topic) = @_;
    
    return $self->threads->search({ topic_id => $topic->id})->count;
};

sub get_latest_thread {
	my ($self, $topic) = @_;
	
	if ( $topic->has_numbers_of_threads($topic) > 0 ) {
		return $topic->threads->search({ topic_id => $topic->id }, { order_by => 'created_date DESC'})->first;
	} else {
		return $topic;
	}
}

sub get_latest_thread_date {
	my ($self, $topic) = @_;
	
	if ( $self->has_numbers_of_threads($self) > 0 ) {
		return $self->threads->search({ topic_id => $self->id }, { order_by => 'created_date DESC'})->first->created_date;
	} else {
		return $self->created_date;
	}
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
