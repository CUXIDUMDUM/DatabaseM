package Database::Manager::Mysql;

use Moose;
use namespace::autoclean;
use 5.019;
use Data::Dump qw(dump);
use Carp;
use IPC::Run3;
use File::Slurp qw(slurp);

with 'Database::Manager';

sub _create_db {
    my ($self) = @_;

    say "Created Database";
}

sub _drop_db {
    my ($self) = @_;

    say "Dropped Database";
}

sub _database_exists {
    my ($self) = @_;

    return int(rand(1));
}

sub _run_ddl {
    my ($self, $file) = @_;

    my $ddl = slurp($file->stringify);
    $self->_run_command( $self->_run_cli, $ddl );
}

sub _run_cli {
    my ($self) = @_;

    my @cmd = "sqlite3";
    push(@cmd, $self->database);

    return \@cmd;
}

sub _run_command {
    my ($self, $cmd, $input) = @_;

    my ($output, $err);

    say dump($cmd, $input);
    run3($cmd, \$input, $output, $err);
    return $output;
}

1;
