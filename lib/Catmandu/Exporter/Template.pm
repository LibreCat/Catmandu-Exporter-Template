package Catmandu::Exporter::Template;

use Catmandu::Sane;
use Catmandu::Util qw(is_string);
use Catmandu;
use Template;
use Moo;
use namespace::clean;

our $VERSION = '0.08';

with 'Catmandu::Exporter';

my $XML_DECLARATION = qq(<?xml version="1.0" encoding="UTF-8"?>\n);

my $ADD_TT_EXT = sub {
    my $tmpl = $_[0];
    is_string($tmpl) && $tmpl !~ /\.\w{2,4}$/ ? "$tmpl.tt" : $tmpl;
};

has xml             => ( is => 'ro' );
has template_before => ( is => 'ro', coerce => $ADD_TT_EXT );
has template        => ( is => 'ro', coerce => $ADD_TT_EXT, required => 1 );
has template_after => ( is => 'ro', coerce => $ADD_TT_EXT );
has start_tag      => ( is => 'ro' );
has end_tag        => ( is => 'ro' );
has tag_style      => ( is => 'ro' );
has interpolate    => ( is => 'ro' );
has eval_perl      => ( is => 'ro' );
has _tt_opts => ( is => 'lazy' );

sub BUILD {
    my ($self, $opts) = @_;
    my $tt_opts = $self->_tt_opts;
    for my $key (keys %$opts) {
        $tt_opts->{uc $key} = $opts->{$key};
    }
}

sub _build__tt_opts {
    +{
        ENCODING     => 'utf8',
        ABSOLUTE     => 1,
        RELATIVE     => 1,
        ANYCASE      => 0,
        INCLUDE_PATH => Catmandu->root,
    };
}

sub _tt {
    my ( $self ) = @_;
    my $opts = $self->_tt_opts;
    my $vars = $opts->{VARIABLES} ||= {};
    $vars->{_root} = Catmandu->root;
    $vars->{_config} = Catmandu->config;
    local $Template::Stash::PRIVATE = 0;
    state $tt = Template->new(%$opts);
}

sub _process {
    my ( $self, $tmpl, $data ) = @_;
    unless ( $self->_tt->process( $tmpl, $data || {}, $self->fh ) ) {
        my $msg = "Template error";
        $msg .= ": " . $self->_tt->error->info if $self->_tt->error;
        Catmandu::Error->throw($msg);
    }
}

sub add {
    my ( $self, $data ) = @_;
    if ( $self->count == 0 ) {
        $self->fh->print($XML_DECLARATION) if $self->xml;
        $self->_process( $self->template_before ) if $self->template_before;
    }
    $self->_process( $self->template, $data );
}

sub commit {
    my ($self) = @_;
    $self->_process( $self->template_after ) if $self->template_after;
}

=head1 NAME

Catmandu::Exporter::Template - a TT2 Template exporter in Catmandu style

=head1 SYNOPSIS

    # From the command line
    echo '{"colors":["red","green","blue"]}' | 
        catmandu convert JSON to Template --template `pwd`/xml.tt

    where xml.tt like:

    <colors>
    [% FOREACH c IN colors %]
       <color>[% c %]</color>
    [% END %]
    </colors>

    # From perl
    use Catmandu::Exporter::Template;

    my $exporter = Catmandu::Exporter::Template->new(
                fix => 'myfix.txt'
                xml => 1,
                template_before => '<path>/header.xml' ,
                template => '<path>/record.xml' ,
                template_after => '<path>/footer.xml' ,
           );

    $exporter->add_many($arrayref);
    $exporter->add_many($iterator);
    $exporter->add_many(sub { });

    $exporter->add($hashref);

    $exporter->commit; # trigger the template_after

    printf "exported %d objects\n" , $exporter->count;

=head1 DESCRIPTION

This L<Catmandu::Exporter> can be used to export records using
L<Template Toolkit|Template::Manual>. If you are new to Catmandu
see L<Catmandu::Tutorial>.

=head1 METHODS

Catmandu::Exporter::Template derives from L<Catmandu::Exporter> with all of its
methods (C<add>, C<add_many>, C<count>, and C<log>). The following methods are
supported in addition:

=head2 new(%opts)

The only required argument is 'template' which points to a file to render for
each exported object. Set the 'template_before' and 'template_before' to add
output at the start and end of the export.  Optionally provide an 'xml'
indicator to include a XML header.

=over

=item *

template: Required. Must contain path to the template.

=item *

xml: Optional. Value: 0 or 1. Prepends xml header to the template.

=item *

template_before: Optional. Prepend template.

=item *

template_after: Optional. Append template.

=item *

fix: Optional. Apply Catmandu fixes while exporting.

=item *

start_tag

=item *

end_tag

=item *

tag_style

=item *

interpolate

=item *

eval_perl

=back

=head2 commit

Commit all changes and execute the template_after if given.

=head1 SEE ALSO

L<Catmandu::Exporter>, L<Template>

=cut

1;
