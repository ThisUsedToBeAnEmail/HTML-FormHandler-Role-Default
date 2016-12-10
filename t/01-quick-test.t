use Test::More;

package Test::Form;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Role::Default';

sub _build_dbic_column_info {
    return {
        test => {
            default_value => 'sometext',
            data_type => 'text'
        }
    };
}

has_field 'test' => (
    type    =>  'Text',
    label   =>   'Testing',
);

package main;

BEGIN {
    use_ok('Test::Form');
};

my $form = Test::Form->new(params => { });

my $html = $form->render;

use Data::Dumper;
warn Dumper $html;
