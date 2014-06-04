package Cache::Transparent;
use 5.008005;
use strict;
use warnings;
use List::Util qw/first/;
our $VERSION = "0.01";

sub new {
    my ($class, %args) = @_;
    my $layers = $args{layers};

    die "need array ref as layer" unless $layers && ref $layers ne 'Array';
    bless { _layers => $layers } , $class;
}


sub get {
    my ($self, $key) = @_;

    for my $layer ( $self->layers ) {
        my $rv = $layer->get($key);
        if (defined $rv) { return $rv; }
    }
    return undef;
}

sub set {
    my ($self, $key, $value, $expire) = @_;

    my $rv;
    for my $layer ($self->layers) {
        $rv = $rv && $layer->set($key, $value, $expire);
    }
    return $rv;
}

sub get_multi { 
    my ($self, @keys) = @_;
 
    my @remaining_keys = @keys;
    my %result;
 
    for my $layer ( $self->layers ) {
        my $rv = $layer->get_multi(@remaining_keys);
         @remaining_keys = grep { !defined $rv->{ $_ }  } (@remaining_keys);
         %result = (%result, %$rv);
    }
    return \%result;
}

sub set_multi {
    my ($self, $args) = @_;
    
    my %result;
    for my $layer ($self->layers) {
        my $rv = $layer->set_multi($args);
        for my $key (keys %$rv) {
            $result{$key} = $result{$key} && $rv->{$key};
        }
    }

    if (wantarray) {
        return map {
            $result{ $args->[0] };
        } @$args;
    }
    else {
        return \%result;
    }
}

sub get_or_set {
    my ($self, $key, $callback, $expire) = @_;
    my $rv = $self->get($key);
    unless (defined $rv) {
        $rv = $callback->();
        $self->set($key, $rv, $expire);
    }
    return $rv;
}

sub layers { @ { shift->{_layers}  }; }

1;
__END__

=encoding utf-8

=head1 NAME

Cache::Transparent - Transparent Cache module

=head1 SYNOPSIS

    use Cache::Transparent;
    use Cache::Memory::Simple;
    use Cache::Memcached::Fast;

    my $cache = Cache::Transparent->new(
        layers => [
            Cache::Memory::Simple->new,
            Cache::Memcached::Fast->new( servers => [ 127.0.0.1:11211 ] )
        ]
    );

    $cache->set('key1', 'foo'); returns defined value only if set to all layers success;
    $cache->get('key1', 'foo'); get value from multi layered cache
    $cache->get_or_set('key2', 'foo', sub { "WRITE YOUR CODE HERER" }, 10); 

=head1 DESCRIPTION

Cache::Transparent is transparent cache module that can make multi layered cache with well known cache modules. i.e Cache::Memcached::Fast. On, set it returns defined value when cache is succesfully set to all layers. On get, it tries to get value from 1 st layer to the last until it can retreive value.

=head1 LICENSE

Copyright (C) maeda-shuntaro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

maedama E<lt>maedama85@gmail.comE<gt>

=cut
