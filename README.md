# NAME

Catmandu::Exporter::Template - a TT2 Template exporter

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

# METHODS

## new(xml => 0|1 , template\_before => PATH, template => PATH , template\_after => PATH)

Catmandu::Exporter::Template can be used to export data objects using
[Template Toolkit](https://metacpan.org/pod/Template::Manual). The only required argument is 'template'
which points to a file to render for each exported object. Set the
'template\_before' and 'template\_before' to add output at the start and end of
the export.  Optionally provide an 'xml' indicator to include a XML header. 

## add

Add data to the exporter.

## commit

Commit all changes and execute the template\_after if given.

# AUTHOR

Nicolas Steenlant <nicolas.steenlant@ugent.be>

# Contributor

Vitali Peil <vitali.peil@uni-bielefeld.de>

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[Catmandu::Exporter](https://metacpan.org/pod/Catmandu::Exporter), [Template](https://metacpan.org/pod/Template)
