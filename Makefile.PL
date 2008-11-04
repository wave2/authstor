use inc::Module::Install;

name 'AuthStor';
all_from 'lib/AuthStor.pm';

requires 'Catalyst::Runtime' => '5.7011';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Model::DBIC::Schema';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::Authorization::Roles';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::Store::FastMmap';
requires 'Catalyst::Plugin::StackTrace';
requires 'Catalyst::View::TT';
requires 'Catalyst::View::JSON';
requires 'Carp::Clan';
requires 'Crypt::GPG';
requires 'Class::Accessor';
requires 'Class::Accessor::Chained';
requires 'Class::C3::Componentised';
requires 'Class::C3::XS';
requires 'Class::Data::Accessor';
requires 'Class::Inspector';
requires 'Data::FormValidator';
requires 'Data::Page';
requires 'DBIx::Class';
requires 'DBIx::Class::Schema::Loader';
requires 'File::BaseDir';
requires 'File::DesktopEntry';
requires 'File::MimeInfo';
requires 'HTML::TagCloud';
requires 'IO::Tty';
requires 'IPC::Run';
requires 'Lingua::EN::Inflect::Number';
requires 'Text::Balanced';
requires 'Text::Password::Pronounceable';
requires 'YAML'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
