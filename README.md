# Name
Cache::Transparent - Transparent Cache module
# SYNOPSIS

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

# DESCRIPTION

Cache::Transparent is transparent cache module that can make multi layered cache with well known cache modules. i.e Cache::Memcached::Fast. On, set it returns defined value when cache is succesfully set to all layers. On get, it tries to get value from 1 st layer to the last until it can retreive value.

# LICENSE

Copyright (C) maedama

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

maedama E<lt>maedama85@gmail.comE<gt>

