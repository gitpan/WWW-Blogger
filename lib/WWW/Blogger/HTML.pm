##
## package WWW::Blogger::HTML
##
package WWW::Blogger::HTML;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2008.0407 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::Blogger::HTML::ISA = qw(Exporter);

   @WWW::Blogger::HTML::EXPORT = qw(); ## export required

   @WWW::Blogger::HTML::EXPORT_OK =
   (
   ); ## export ok on request

} ## end BEGIN

require WWW::Blogger::HTML::API;

require File::Spec;

##require File::stat;

require File::Basename;

##require DBI; require XML::Dumper; ##require SQL::Statement;

require Date::Format;

require Text::Wrap;

%WWW::Blogger::HTML::opts =
(
);

__PACKAGE__ =~ m/^(WWW::[^:]+)((::([^:]+)){1}(::([^:]+)){0,1}){0,1}$/g;

##debug##print( "HTML! $1::$4::$6\n" );

%WWW::Blogger::HTML::opts_type_args =
(
   'ido'            => $1,
   'iknow'          => $4,
   'iman'           => 'aggregate',
   'myp'            => __PACKAGE__,
   'opts'           => \%WWW::Blogger::HTML::opts,
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
     __PACKAGE__ ne join( '::', $WWW::Blogger::HTML::opts_type_args{'ido'},
                                $WWW::Blogger::HTML::opts_type_args{'iknow'},
                                #$WWW::Blogger::HTML::opts_type_args{'iman'}
                        )
                      );

WWW::Blogger::ML::API::create_opts_types( \%WWW::Blogger::HTML::opts_type_args );

##debug##WWW::Blogger::ML::API::show_all_opts( \%WWW::Blogger::HTML::opts_type_args );

WWW::Blogger::HTML::register_all_opts( \%WWW::Blogger::HTML::API::opts_type_args );

##debug##WWW::Blogger::HTML::show_all_opts( \%WWW::Blogger::HTML::opts_type_args );

push( @WWW::Blogger::HTML::EXPORT_OK,
      @{$WWW::Blogger::HTML::opts_type_args{'export_ok'}} );

END {

} ## end END

##
## WWW::Blogger::HTML::register_all_opts
##
sub WWW::Blogger::HTML::register_all_opts
{
   my $opts_type_args = shift || \%WWW::Blogger::HTML::API::opts_type_args;

   while ( my ( $opt_tag, $opt_val ) = each( %{$opts_type_args->{'opts'}} ) )
   {
      $WWW::Blogger::HTML::opts_type_args{'opts'}{$opt_tag} = $opt_val;

   } ## end while

   while ( my ( $opt_tag, $opt_val ) = each( %{$opts_type_args->{'urls'}} ) )
   {
      $WWW::Blogger::HTML::opts_type_args{'urls'}{$opt_tag} = $opts_type_args->{'urls'}{$opt_tag};

   } ## end while

} ## end sub WWW::Blogger::HTML::register_all_opts

##
## WWW::Blogger::HTML::show_all_opts
##
sub WWW::Blogger::HTML::show_all_opts
{
   my $opts_type_args = shift || \%WWW::Blogger::HTML::opts_type_args;

   WWW::Blogger::ML::API::show_all_opts( $opts_type_args );

} ## end sub WWW::Blogger::HTML::show_all_opts

1;
__END__ ## package WWW::Blogger::HTML

=head1 NAME

WWW::Blogger::HTML - General Hyper-Text Markup Language capabilities go in here.

=head1 SYNOPSIS

Options (--html_* options);

=head1 OPTIONS

--html_* options:

opts_type_flag:

   --html_*

opts_type_numeric:

   --html_*=number

opts_type_string:

   --html_*=string

=head1 DESCRIPTION

   WWW::Blogger HTML Layer.

=head1 SEE ALSO

I<L<WWW::Blogger>> I<L<WWW::Blogger::ML>> I<L<WWW::Blogger::HTML::API>> I<L<WWW::Blogger::XML>>

=head1 AUTHOR

 Copyright (C) 2008 Eric R. Meyers E<lt>Eric.R.Meyers@gmail.comE<gt>

=cut
