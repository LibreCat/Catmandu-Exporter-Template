requires 'perl', 'v5.10.1';

on test => sub {
    requires 'Test::More', '0.88';
    requires 'Test::Exception', '0.32';
};

requires 'Module::Build::Tiny';
requires 'Catmandu', '>=0.9301';
requires 'Storable', 0;
requires 'Template', '>=2.22';
requires 'Moo', '>1.004';
