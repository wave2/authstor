use inc::Module::Install;

name 'AuthStor';
all_from 'lib/AuthStor.pm';

requires 'Catalyst::Runtime' => '5.7015';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'Catalyst::Log::Log4perl';
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
requires 'Crypt::SaltedHash';
requires 'Class::Accessor';
requires 'Class::Accessor::Chained';
requires 'Class::C3::Componentised';
requires 'Class::C3::XS';
requires 'Class::Data::Accessor';
requires 'Class::Inspector';
requires 'Config::General';
requires 'Data::FormValidator';
requires 'Data::Page';
requires 'DBIx::Class';
requires 'DBIx::Class::Schema::Loader';
requires 'Digest::MD5';
requires 'Digest::SHA';
requires 'Exception::Class::TryCatch';
requires 'File::BaseDir';
requires 'File::DesktopEntry';
requires 'File::MimeInfo';
requires 'GnuPG::Interface';
requires 'HTML::TagCloud';
requires 'IO::Scalar';
requires 'IO::Tty';
requires 'IPC::Run';
requires 'Lingua::EN::Inflect::Number';
requires 'Net::SSH::Perl';
requires 'String::Random';
requires 'Text::Balanced';
requires 'Text::Password::Pronounceable';
requires 'YAML'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
