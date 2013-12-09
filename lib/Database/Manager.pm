package Database::Manager;

use Moose::Role;
use namespace::autoclean;
use 5.019;
use Data::Dump qw(dump);
use Carp;
use YAML qw(LoadFile);
use MooseX::Types::Path::Class;

with 'MooseX::Getopt';
with 'MooseX::SimpleConfig';

requires qw(_create_db _drop_db _run_ddl);

for my $attr (qw/user password dsn/) {
    has $attr => (
        is      => 'ro',
        isa     => 'Str',
        default => '',
    );
}

has 'database' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'dry_run' => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

has 'schema_file' => (
    is       => 'ro',
    isa      => 'Path::Class::File',
    coerce   => 1,
    required => 1,
);

sub create_or_update_db {
    my ($self) = @_;
    
    if ($self->_database_exists()){
        say "Database " . $self->database . " already exists";
    }
    else {
        $self->_create_db();
        $self->_run_ddl($self->schema_file);
    }
}

1;
