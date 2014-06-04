use strict;
use warnings;
use Test::More;

use Cache::Transparent;
use Cache::Memory::Simple;

my $layer1 = Cache::Memory::Simple->new;
my $layer2 = Cache::Memory::Simple->new;

my $cache = Cache::Transparent->new(layers => [ $layer1, $layer2 ]);

subtest 'undef' => sub {
    is $cache->set('foo'), undef;
};

subtest 'get value from layer1' => sub {
    $layer1->set('foo', 'var');
    is $cache->get('foo'), 'var';
};

subtest 'get value from layer2' => sub {
    $layer2->set('bar', 'buz');
    is $cache->get('bar'), 'buz';
};

done_testing;

1;
