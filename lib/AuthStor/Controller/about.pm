package AuthStor::Controller::about;

use strict;
use warnings;
use base 'Catalyst::Controller';

=head1 NAME

AuthStor::Controller::about - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{expandGroup} = 0;
    $c->stash->{group} = $c->model('AuthStorDB::AuthGroup')->single({ parent_id => 0 });
    # Tag Cloud
    my $cloud = HTML::TagCloud->new(levels=>5);
    my $tags = $c->model('AuthStorDB::AuthTag')->search({},
    {
      join => 'tag',
      select => [ { count => '*' }, 'tag.tag_text' ],
      as => [qw/tagcount tag_text/],
      group_by => [qw/tag_text/]
    });
    while( my $tag=$tags->next() ) {
      $cloud->add(lc($tag->get_column('tag_text')),$c->uri_for('/search/tag', lc($tag->get_column('tag_text'))), $tag->get_column('tagcount'));
    }
    $c->stash->{tag_cloud} =  $cloud->html(50);
    $c->stash->{title} = 'About';
    $c->stash->{template} = 'about.tt2';
    $c->forward('AuthStor::View::TT');


}


=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
