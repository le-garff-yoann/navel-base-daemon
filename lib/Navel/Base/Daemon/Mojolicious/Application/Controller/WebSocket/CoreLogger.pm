# Copyright (C) 2015 Yoann Le Garff, Nicolas Boquet and Yann Le Bras
# navel-base-daemon is licensed under the Apache License, Version 2.0

#-> BEGIN

#-> initialization

package Navel::Base::Daemon::Mojolicious::Application::Controller::WebSocket::CoreLogger 0.1;

use Navel::Base;

use Mojo::Base 'Mojolicious::Controller';

#-> methods

sub stream {
    my $controller = shift;

    my $tx = $controller->tx();

    my $tx_id = sprintf '%s', $tx;

    $controller->daemon()->{core}->{logger_callbacks}->{$tx_id} = sub {
        $tx->send(
            {
                json => $_->constructor_properties()
            }
        ) for @{shift->{queue}};
    };

    $controller->on(
        finish => sub {
            delete $controller->daemon()->{core}->{logger_callbacks}->{$tx_id};
        }
    );
}

# sub AUTOLOAD {}

# sub DESTROY {}

1;

#-> END

__END__

=pod

=encoding utf8

=head1 NAME

Navel::Base::Daemon::Mojolicious::Application::Controller::WebSocket::CoreLogger

=head1 COPYRIGHT

Copyright (C) 2015 Yoann Le Garff, Nicolas Boquet and Yann Le Bras

=head1 LICENSE

navel-base-daemon is licensed under the Apache License, Version 2.0

=cut
