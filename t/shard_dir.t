use strict;
use warnings;

use Test::More;

use File::ShardDir;

my %tests = (
    'foo_580760.jpg' => {
        'nn/nn/nn'    => '58/07/60',
        'NN/NN/NN'    => '06/70/85',
        'nn/nn/nn/nn' => '00/58/07/60',
        'NN/NN/NN/NN' => '06/70/85/00',
        'cc/cc'       => 'fo/o_',
        '123/456'     => 'foo/580',
    },

);

foreach my $filename ( sort keys %tests ) {
    foreach my $format ( sort keys %{ $tests{$filename} } ) {
        is File::ShardDir::shard_dir( $filename, $format ),
            $tests{$filename}->{$format}, "$filename - $format ok";
    }
}

done_testing();

