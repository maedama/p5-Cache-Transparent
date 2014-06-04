use strict;
use warnings;

package Test::Cache;
use parent 'Cache::Memory::Simple';
sub set_multi {
    my ($self, @args) = @_;
    return +{
        map { ( $_->[0] => $self->set(@$_) ) } (@args)
    }; 
}
1;

package main;

use Test::More;
use Cache::Transparent;

my $layer1 = Test::Cache->new;
my $layer2 = Test::Cache->new;

my $cache = Cache::Transparent->new(layers => [ $layer1, $layer2 ]);


subtest 'get values' => sub {
    $cache->set_multi(['foo', 1, 1], ['bar', 2, 1]);
    
    is $layer1->get('foo'), 1;
    is $layer1->get('bar'), 2;
    is $layer2->get('foo'), 1;
    is $layer2->get('bar'), 2;
};


done_testing;




1;
