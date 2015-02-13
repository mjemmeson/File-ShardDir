use strict;
use warnings;

use Test::More;

use File::ShardDir;

ok my $sharder = File::ShardDir->new("nn/nn/nn"), "got File::ShardDir object";
isa_ok $sharder, "File::ShardDir";

is $sharder->shard("foo_563452w4.jpg"), "56/34/52", "shard ok";

done_testing();

