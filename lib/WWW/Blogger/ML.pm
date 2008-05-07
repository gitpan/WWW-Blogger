#!/usr/bin/perl -w
##

##
## WWW::Blogger::ML
##
package WWW::Blogger::ML;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2008.0507 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::Blogger::ML::ISA = qw(Exporter);

   @WWW::Blogger::ML::EXPORT = qw(); ## export required

   @WWW::Blogger::ML::EXPORT_OK =
   (
   ); ## export ok on request

} ## end BEGIN

require WWW::Blogger::XML;

require WWW::Blogger::HTML;

##bad##require Term::UI;

require Term::ReadLine;

%WWW::Blogger::ML::opts =
(
   ##
   ## vlbt_opts
   ##

); ## General Public

__PACKAGE__ =~ m/^(WWW::[^:]+)((::([^:]+)){1}(::([^:]+)){0,1}){0,1}$/g;

##debug##print( "ML! $1::$4::$6\n" );

%WWW::Blogger::ML::opts_type_args =
(
   'ido'            => $1,
   'iknow'          => $4,
   'iman'           => 'aggregate',
   'myp'            => __PACKAGE__,
   'opts'           => \%WWW::Blogger::ML::opts,
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
      'delay_sec',

   ],
   'opts_type_string' =>
   [
   ],

);

die( __PACKAGE__ ) if (
     __PACKAGE__ ne join( '::', $WWW::Blogger::ML::opts_type_args{'ido'},
                                $WWW::Blogger::ML::opts_type_args{'iknow'},
                                #$WWW::Blogger::ML::opts_type_args{'iman'}
                        )
                      );

##WWW::Blogger::ML::register_all_opts( \%WWW::Blogger::ML::API::opts_type_args );

WWW::Blogger::ML::API::create_opts_types( \%WWW::Blogger::ML::opts_type_args );

$WWW::Blogger::ML::numeric_delay_sec = 5; ## pacing

##debug##WWW::Blogger::ML::API::show_all_opts( \%WWW::Blogger::ML::opts_type_args );

WWW::Blogger::ML::register_all_opts( \%WWW::Blogger::XML::opts_type_args );

WWW::Blogger::ML::register_all_opts( \%WWW::Blogger::HTML::opts_type_args );

push( @WWW::Blogger::ML::EXPORT_OK,
      @{$WWW::Blogger::ML::opts_type_args{'export_ok'}} );

END {

} ## end END

##
## WWW::Blogger::ML::register_all_opts
##
sub WWW::Blogger::ML::register_all_opts
{
   my $opts_type_args = shift || \%WWW::Blogger::ML::API::opts_type_args;

   while ( my ( $opt_tag, $opt_val ) = each( %{$opts_type_args->{'opts'}} ) )
   {
      $WWW::Blogger::ML::opts_type_args{'opts'}{$opt_tag} = $opt_val;

   } ## end while

   while ( my ( $opt_tag, $opt_val ) = each( %{$opts_type_args->{'urls'}} ) )
   {
      $WWW::Blogger::ML::opts_type_args{'urls'}{$opt_tag} = $opts_type_args->{'urls'}{$opt_tag};

   } ## end while

} ## end sub WWW::Blogger::ML::register_all_opts

##
## WWW::Blogger::ML::show_all_opts
##
sub WWW::Blogger::ML::show_all_opts
{
   my $opts_type_args = shift || \%WWW::Blogger::ML::opts_type_args;

   WWW::Blogger::ML::API::show_all_opts( $opts_type_args );

} ## end sub WWW::Blogger::ML::show_all_opts

1;
__END__ ## package WWW::Blogger::ML

=head1 NAME

WWW::Blogger::ML - WWW::Blogger Markup Language, an Abstraction Layer

=head1 SYNOPSIS

 Options;

   --ml_*

=head1 OPTIONS

--ml_*

=head1 DESCRIPTION

ML just stands for Markup Language, in a Abstract way, for HTML, XML, SGML or YAML or whatever gets included as ML capabilities.

=head1 SEE ALSO

I<L<WWW::Blogger>> I<L<WWW::Blogger::ML::API>> I<L<WWW::Blogger::HTML>> I<L<WWW::Blogger::XML>>

=head1 AUTHOR

 Copyright (C) 2008 Eric R. Meyers E<lt>Eric.R.Meyers@gmail.comE<gt>

=cut
