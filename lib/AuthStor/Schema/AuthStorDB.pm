package AuthStor::Schema::AuthStorDB;
    
=head1 NAME 
    
AuthStorDB -- DBIC Schema Class

=cut

# Our schema needs to inherit from 'DBIx::Class::Schema'
use base qw/DBIx::Class::Schema/;

__PACKAGE__->load_classes(qw/Auth AuthTag Attachment AuthAtt Group Tag User UserRole UserTag Role/);


1;
