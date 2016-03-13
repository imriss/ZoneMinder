package ONVIF::Analytics::Types::FindMetadataResultList;
use strict;
use warnings;


__PACKAGE__->_set_element_form_qualified(1);

sub get_xmlns { 'http://www.onvif.org/ver10/schema' };

our $XML_ATTRIBUTE_CLASS;
undef $XML_ATTRIBUTE_CLASS;

sub __get_attr_class {
    return $XML_ATTRIBUTE_CLASS;
}

use Class::Std::Fast::Storable constructor => 'none';
use base qw(SOAP::WSDL::XSD::Typelib::ComplexType);

Class::Std::initialize();

{ # BLOCK to scope variables

my %SearchState_of :ATTR(:get<SearchState>);
my %Result_of :ATTR(:get<Result>);

__PACKAGE__->_factory(
    [ qw(        SearchState
        Result

    ) ],
    {
        'SearchState' => \%SearchState_of,
        'Result' => \%Result_of,
    },
    {
        'SearchState' => 'ONVIF::Analytics::Types::SearchState',
        'Result' => 'ONVIF::Analytics::Types::FindMetadataResult',
    },
    {

        'SearchState' => 'SearchState',
        'Result' => 'Result',
    }
);

} # end BLOCK








1;


=pod

=head1 NAME

ONVIF::Analytics::Types::FindMetadataResultList

=head1 DESCRIPTION

Perl data type class for the XML Schema defined complexType
FindMetadataResultList from the namespace http://www.onvif.org/ver10/schema.






=head2 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY
methods:

=over

=item * SearchState


=item * Result




=back


=head1 METHODS

=head2 new

Constructor. The following data structure may be passed to new():

 { # ONVIF::Analytics::Types::FindMetadataResultList
   SearchState => $some_value, # SearchState
   Result =>  { # ONVIF::Analytics::Types::FindMetadataResult
     RecordingToken => $some_value, # RecordingReference
     TrackToken => $some_value, # TrackReference
     Time =>  $some_value, # dateTime
   },
 },




=head1 AUTHOR

Generated by SOAP::WSDL

=cut

