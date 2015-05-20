# NAME

Catmandu::Exporter::Template - a TT2 Template exporter in Catmandu style

# STATUS

[![Build Status](https://travis-ci.org/LibreCat/Catmandu-Exporter-Template.svg?branch=master)](https://travis-ci.org/LibreCat/Catmandu-Exporter-Template)
[![Coverage](https://coveralls.io/repos/LibreCat/Catmandu-Exporter-Template/badge.png?branch=master)](https://coveralls.io/r/LibreCat/Catmandu-Exporter-Template)
[![CPANTS kwalitee](http://cpants.cpanauthors.org/dist/Catmandu-Exporter-Template.png)](http://cpants.cpanauthors.org/dist/Catmandu-ArXiv)

# SYNOPSIS

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

# DESCRIPTION

This [Catmandu::Exporter](https://metacpan.org/pod/Catmandu::Exporter) can be used to export records using
[Template Toolkit](https://metacpan.org/pod/Template::Manual). If you are new to Catmandu
see [Catmandu::Tutorial](https://metacpan.org/pod/Catmandu::Tutorial).

# METHODS

Catmandu::Exporter::Template derives from [Catmandu::Exporter](https://metacpan.org/pod/Catmandu::Exporter) with all of its
methods (`add`, `add_many`, `count`, and `log`). The following methods are
supported in addition:

## new(%opts)

The only required argument is 'template' which points to a file to render for
each exported object. Set the 'template\_before' and 'template\_before' to add
output at the start and end of the export.  Optionally provide an 'xml'
indicator to include a XML header.

- template: Required. Must contain path to the template.
- xml: Optional. Value: 0 or 1. Prepends xml header to the template.
- template\_before: Optional. Prepend template.
- template\_after: Optional. Append template.
- fix: Optional. Apply Catmandu fixes while exporting.
- start\_tag
- end\_tag
- tag\_style
- interpolate
- eval\_perl

## commit

Commit all changes and execute the template\_after if given.

# AUTHOR

Nicolas Steenlant, `<nicolas.steenlant at ugent.be>`

# CONTRIBUTOR

Vitali Peil, `<vitali.peil at uni-bielefeld.de>`

Jakob Voss, `<jakob.voss at gbv.de>`

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[Catmandu::Exporter](https://metacpan.org/pod/Catmandu::Exporter), [Template](https://metacpan.org/pod/Template)
