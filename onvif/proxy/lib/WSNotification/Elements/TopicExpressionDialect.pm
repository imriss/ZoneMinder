
package WSNotification::Elements::TopicExpressionDialect;
use strict;
use warnings;

{ # BLOCK to scope variables

sub get_xmlns { 'http://docs.oasis-open.org/wsn/b-2' }

__PACKAGE__->__set_name('TopicExpressionDialect');
__PACKAGE__->__set_nillable();
__PACKAGE__->__set_minOccurs();
__PACKAGE__->__set_maxOccurs();
__PACKAGE__->__set_ref();
use base qw(
    SOAP::WSDL::XSD::Typelib::Element
    SOAP::WSDL::XSD::Typelib::Builtin::anyURI
);

}

1;


=pod

=head1 NAME

WSNotification::Elements::TopicExpressionDialect

=head1 DESCRIPTION

Perl data type class for the XML Schema defined element
TopicExpressionDialect from the namespace http://docs.oasis-open.org/wsn/b-2.







=head1 METHODS

=head2 new

 my $element = WSNotification::Elements::TopicExpressionDialect->new($data);

Constructor. The following data structure may be passed to new():

 $some_value, # anyURI

=head1 AUTHOR

Generated by SOAP::WSDL

=cut

