package Contenticious::Content::Node::File;
use Mojo::Base 'Contenticious::Content::Node';

use Carp;
use Mojo::Util      'decode';
#use Text::Markdown  'markdown';
use Text::MultiMarkdown 'markdown';

has raw     => sub { shift->build_raw };
has content => sub { shift->build_content_and_meta->content };
has meta    => sub { shift->build_content_and_meta->meta };

sub build_raw {
    my $self = shift;

    # open file for decoded reading
    my $fn = $self->filename;
    open my $fh, '<:encoding(UTF-8)', $fn or croak "couldn't open $fn: $!";

    # slurp
    return do { local $/; <$fh> };
}

sub build_content_and_meta {
    my $self    = shift;
    my $content = $self->raw;
    my %meta    = ();

    # extract (and delete) meta data from file content
    $meta{lc $1} = $2
        while $content =~ s/\A(\w+):\s*(.*)[\n\r]+//;

    # done
    $self->content($content)->meta(\%meta);
}

sub build_html {
    my $self = shift;
    return markdown(qq/<div markdown="1">\n/.$self->content."\n</div>\n");
}

1;

__END__

=head1 NAME

Contenticious::Content::Node::File - a file in a Contenticious content tree

=head1 SYNOPSIS

    use Contenticious::Content::Node::File;
    my $file = Contenticious::Content::Node::File->new(
        filename => 'foo.md'
    );
    my $html = $file->html;

=head1 DESCRIPTION

File nodes represent files in a Contenticious::Content content tree.

=head1 ATTRIBUTES

Contenticious::Content::Node::File inherits all L<Contenticious::Content::Node>
attributes and implements the following new ones:

=head2 raw

Raw file content right after decoding.

=head2 content

File content after meta informations are extracted.

=head1 METHODS

Contenticious::Content::Node::File inherits all L<Contenticious::Content::Node>
methods and implements the following new ones:

=head2 html

    my $html = $file->html;

HTML generated by L<Text::Markdown> from this file's C<content>.

=head1 SEE ALSO

L<Contenticious::Content::Node>,
L<Contenticious::Content::Node::Directory>,
L<Contenticious::Content>,
L<Contenticious>
