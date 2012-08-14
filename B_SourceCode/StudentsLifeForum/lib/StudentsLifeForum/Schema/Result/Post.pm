use utf8;
package StudentsLifeForum::Schema::Result::Post;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

StudentsLifeForum::Schema::Result::Post

=cut

use strict;
use warnings;

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

=head1 TABLE: C<posts>

=cut

__PACKAGE__->table("posts");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 body

  data_type: 'text'
  is_nullable: 1

=head2 image_path

  data_type: 'text'
  is_nullable: 1

=head2 created_date

  data_type: 'text'
  is_nullable: 1

=head2 thread_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 sender_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "body",
  { data_type => "text", is_nullable => 1 },
  "image_path",
  { data_type => "text", is_nullable => 1 },
  "created_date",
  { data_type => "text", is_nullable => 1 },
  "thread_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "sender_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 sender

Type: belongs_to

Related object: L<StudentsLifeForum::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "sender",
  "StudentsLifeForum::Schema::Result::User",
  { id => "sender_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 thread

Type: belongs_to

Related object: L<StudentsLifeForum::Schema::Result::Thread>

=cut

__PACKAGE__->belongs_to(
  "thread",
  "StudentsLifeForum::Schema::Result::Thread",
  { id => "thread_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-08-06 20:14:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:I5pbw8kWJetyDy9jP56eQ



# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
