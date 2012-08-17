use utf8;
package StudentsLifeForum::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

StudentsLifeForum::Schema::Result::User

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

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 username

  data_type: 'text'
  is_nullable: 1

=head2 email

  data_type: 'text'
  is_nullable: 1

=head2 password

  data_type: 'text'
  is_nullable: 1

=head2 created_date

  data_type: 'text'
  is_nullable: 1

=head2 avatar

  data_type: 'text'
  is_nullable: 1

=head2 salt

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "username",
  { data_type => "text", is_nullable => 1 },
  "email",
  { data_type => "text", is_nullable => 1 },
  "password",
  { data_type => "text", is_nullable => 1 },
  "created_date",
  { data_type => "text", is_nullable => 1 },
  "avatar",
  { data_type => "text", is_nullable => 1 },
  "salt",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<username_unique>

=over 4

=item * L</username>

=back

=cut

__PACKAGE__->add_unique_constraint("username_unique", ["username"]);

=head1 RELATIONS

=head2 posts

Type: has_many

Related object: L<StudentsLifeForum::Schema::Result::Post>

=cut

__PACKAGE__->has_many(
  "posts",
  "StudentsLifeForum::Schema::Result::Post",
  { "foreign.sender_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 threads

Type: has_many

Related object: L<StudentsLifeForum::Schema::Result::Thread>

=cut

__PACKAGE__->has_many(
  "threads",
  "StudentsLifeForum::Schema::Result::Thread",
  { "foreign.owner_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_roles

Type: has_many

Related object: L<StudentsLifeForum::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "user_roles",
  "StudentsLifeForum::Schema::Result::UserRole",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roles

Type: many_to_many

Composing rels: L</user_roles> -> role

=cut

__PACKAGE__->many_to_many("roles", "user_roles", "role");


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-08-06 20:14:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8OX7tXfpTF1NXgoL06aOrg

sub has_role {
	my ($self, $role) = @_;
	## $role is a row object for a role.
	my $roles = $self->user_roles->find({ role_id => $role->id });
	return $roles;
}

sub current_role {
	my ($self) = @_;
	my $user_roles = $self->user_roles->find({ user_id => $self->id })->role;
	#my $roles = $user_roles->role_id->role;
	return $user_roles;
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
