package AuthStor::Controller::Dashboard;

use strict;
use warnings;
use base 'Catalyst::Controller';

=head1 NAME

AuthStor::Controller::Dashboard - Catalyst Controller

=head1 DESCRIPTION

AuthStor Dashboard

=head1 METHODS

=cut


=head2 index 

=cut

sub index : Private {
    my ( $self, $c ) = @_;
    
    # If a user doesn't exist, force login
    if (!$c->user_exists) {
        # Dump a log message to the development server debug output
        $c->log->debug('***Root::auto User not found, forwarding to /login');
        # Redirect the user to the login page
        $c->response->redirect($c->uri_for('/login'));
        # Return 0 to cancel 'post-auto' processing and prevent use of application
        return 0;
    }
    $c->stash->{expandGroup} = 0;
    $c->stash->{group} = $c->model('AuthStorDB::AuthGroup')->single({ parent_id => 0 });
    # Recent Changes
    $c->stash->{recentChanges} = $c->model('AuthStorDB::Auth')->search({}, {order_by => { -desc => 'modified' }, rows => 5});
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
    $c->stash->{title} = 'Dashboard';
    $c->stash->{template} = 'dashboard.tt2';
    $c->forward('AuthStor::View::TT');
}


=head1 AUTHOR

Alan Snelson

=head1 LICENSE

See the file LICENSE for details.

=cut

1;
