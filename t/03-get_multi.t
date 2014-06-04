use strict;
use warnings;

package Test::Cache;
use parent 'Cache::Memory::Simple';
sub get_multi {
    my ($self, @keys) = @_;
    return +{
        map { $_ => $self->get($_) } (@keys)
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
    $layer1->set('foo', 1);
    $layer2->set('bar', 2);
    is_deeply(
        $cache->get_multi('foo', 'bar', 'baz'),
        {
            foo => 1,
            bar => 2,
            baz => undef
        }
    );
};

done_testing;




1;
