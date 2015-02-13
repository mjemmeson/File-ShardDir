use strict;
use warnings;

package File::ShardDir;

our $VERSION = '0.01';

# ABSTRACT: 

my %FORMAT;

sub shard_dir {
    my $filename   = shift;
    my $format_str = shift or die "format not supplied";

    $FORMAT{$format_str} ||= _create_format_sub( $format_str );

    return $FORMAT{$format_str}->( $filename );
}

sub _create_format_sub {
    my $format_str = shift;

    my @format = split //, $format_str;
    my $f_digits = scalar grep {/[nN]/} @format;

    return sub {
        my $filename = shift;

        # remove extension and non word characters
        $filename =~ s/\.[^.]+$//;
        $filename =~ s/[\W_]//g;

        my @chars = split //, $filename;
        my @digits = grep {/[0-9]/} @chars;
        my @alpha  = grep {/[^0-9]/} @chars;

        my $diff = $f_digits - @digits;
        if ( $diff > 0 ) {
            splice( @digits, 0, 0, ('0') x $diff );
        }

        my $shard_dir;
        foreach my $f (@format) {
            $shard_dir .=
                  $f eq 'n' ? shift(@digits)
                : $f eq 'N' ? pop(@digits)
                : $f eq 'c' ? shift(@alpha) || '_'
                : $f eq 'C' ? pop(@alpha)   || '_'
                : $f =~ m/[1-9]/ ? $chars[ $f - 1 ]
                :                  $f;
        }
        return $shard_dir;
    };
}

1;

__END__

=encoding utf-8

=head1 NAME

File::ShardDir

=head1 SYNOPSIS

    # OO interface
    use File::ShardDir;
    my $sharder = File::ShardDir->new($format);

    my $shard_dir = $sharder->dir($filename);

    # functional interface
    use File::ShardDir qw( shard_dir );
    my $shard_dir = shard_dir( $filename, $format );

=head1 DESCRIPTION

=head1 FORMAT

    c - right padded non-digits

    n - left (zero) padded digits

    1..9 - numbered positional characters

=head1 METHODS

=cut

