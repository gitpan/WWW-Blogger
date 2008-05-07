##
## WWW::Blogger::XML
##
package WWW::Blogger::XML;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2008.0407 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::Blogger::XML::ISA = qw(Exporter);

   @WWW::Blogger::XML::EXPORT = qw(); ## export required

   @WWW::Blogger::XML::EXPORT_OK =
   (

   ); ## export ok on request

} ## end BEGIN

require WWW::Blogger::XML::API;

require IO::Zlib;

#require File::Spec::Unix;

require File::Basename;

require Date::Format;

require String::Approx;

%WWW::Blogger::XML::opts =
(
);

__PACKAGE__ =~ m/^(WWW::[^:]+)((::([^:]+)){1}(::([^:]+)){0,1}){0,1}$/g;

##debug##print( "XML! $1::$4::$6\n" );

%WWW::Blogger::XML::opts_type_args =
(
   'ido'            => $1,
   'iknow'          => $4,
   'iman'           => 'aggregate',
   'myp'            => __PACKAGE__,
   'opts'           => \%WWW::Blogger::XML::opts,
   'opts_filename'  => {},
   'export_ok'      => [],
   'urls' =>
   {
   },
   'opts_type_flag' =>
   [
   ],
   'opts_type_numeric' =>
   [
   ],
   'opts_type_string' =>
   [
   ],

);

die( __PACKAGE__ ) if (
     __PACKAGE__ ne join( '::', $WWW::Blogger::XML::opts_type_args{'ido'},
                                $WWW::Blogger::XML::opts_type_args{'iknow'},
                                #$WWW::Blogger::XML::opts_type_args{'iman'}
                        )
                      );

WWW::Blogger::ML::API::create_opts_types( \%WWW::Blogger::XML::opts_type_args );

##debug##WWW::Blogger::ML::API::show_all_opts( \%WWW::Blogger::XML::opts_type_args );

WWW::Blogger::XML::register_all_opts( \%WWW::Blogger::XML::API::opts_type_args );

#push( @WWW::Blogger::XML::EXPORT_OK,
#      @{$WWW::Blogger::XML::opts_type_args{'export_ok'}} );

END {

} ## end END

##
## WWW::Blogger::XML::register_all_opts
##
sub WWW::Blogger::XML::register_all_opts
{
   my $opts_type_args = shift || \%WWW::Blogger::XML::API::opts_type_args;

   while ( my ( $opt_tag, $opt_val ) = each( %{$opts_type_args->{'opts'}} ) )
   {
      $WWW::Blogger::XML::opts_type_args{'opts'}{$opt_tag} = $opt_val;

   } ## end while

   while ( my ( $opt_tag, $opt_val ) = each( %{$opts_type_args->{'urls'}} ) )
   {
      $WWW::Blogger::XML::opts_type_args{'urls'}{$opt_tag} = $opts_type_args->{'urls'}{$opt_tag};

   } ## end while

} ## end sub WWW::Blogger::XML::register_all_opts

##
## WWW::Blogger::XML::show_all_opts
##
sub WWW::Blogger::XML::show_all_opts
{
   my $opts_type_args = shift || \%WWW::Blogger::XML::opts_type_args;

   WWW::Blogger::ML::API::show_all_opts( $opts_type_args );

} ## end sub WWW::Blogger::XML::show_all_opts

1;
__END__ ## package WWW::Blogger::XML

=head1 NAME

WWW::Blogger::XML - General Extensible Markup Language capabilities go in here.

=head1 SYNOPSIS

 Options;

   --xml_*

=head1 OPTIONS

--xml_*

=head1 DESCRIPTION

   WWW::Blogger XML Layer.

=head1 SEE ALSO

I<L<WWW::Blogger>> I<L<WWW::Blogger::ML>> I<L<WWW::Blogger::HTML>> I<L<WWW::Blogger::XML::API>>

=head1 AUTHOR

 Copyright (C) 2008 Eric R. Meyers E<lt>Eric.R.Meyers@gmail.comE<gt>

=cut

