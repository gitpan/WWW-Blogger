##
## WWW::Blogger::HTML::API
##
package WWW::Blogger::HTML::API;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2008.0507 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::Blogger::HTML::API::ISA = qw(Exporter);

   @WWW::Blogger::HTML::API::EXPORT = qw(); ## export required

   @WWW::Blogger::HTML::API::EXPORT_OK =
   (
   ); ## export ok on request

} ## end BEGIN

require WWW::Blogger::Com; ## NOTE: I need WWW::Blogger::Com secrets

require WWW::Blogger::XML::API; ## NOTE: HTML/XML crossover

require WWW::Blogger::ML::API; ## NOTE: generic *ML

require LWP::UserAgent; ## HTML::API::ua (User Agent)

require LWP::Simple; ## HTML::API::ua-like (Simple User Agent)

require HTTP::Cookies;

require HTTP::Request::Common; ## qw(POST); ## quick and easy POST edit

require HTML::TreeBuilder; ## HTML::API::tree parser

require DBI;

require XML::Dumper;

require SQL::Statement;

require Data::Dumper; ## get rid of this

require IO::File;

require Encode;

require FindBin;

__PACKAGE__ =~ m/^(WWW::[^:]+)::([^:]+)(::([^:]+)){0,1}$/g;

##debug##print( "API! $1::$2::$4\n" );

%WWW::Blogger::HTML::API::opts_type_args =
(
   'ido'            => $1,
   'iknow'          => $2,
   'iman'           => $4,
   'myp'            => __PACKAGE__,
   'opts'           => {},
   'opts_filename'  => {},
   'export_ok'      => [],
   'opts_type_flag' =>
   [
      @{$WWW::Blogger::ML::API::opts_type_args{'opts_type_flag'}},
      ## Customizations follow this line ##
   ],
   'opts_type_numeric' =>
   [
      @{$WWW::Blogger::ML::API::opts_type_args{'opts_type_numeric'}},
      ## Customizations follow this line ##
   ],
   'opts_type_string' =>
   [
      @{$WWW::Blogger::ML::API::opts_type_args{'opts_type_string'}},
      ## Customizations follow this line ##
   ],

);

die( __PACKAGE__ ) if (
     __PACKAGE__ ne join( '::', $WWW::Blogger::HTML::API::opts_type_args{'ido'},
                                $WWW::Blogger::HTML::API::opts_type_args{'iknow'},
                                $WWW::Blogger::HTML::API::opts_type_args{'iman'}
                        )
                      );

WWW::Blogger::ML::API::create_opts_types( \%WWW::Blogger::HTML::API::opts_type_args );

$WWW::Blogger::HTML::API::string_dbm_dir = $WWW::Blogger::ML::API::string_dbm_dir.'/html';

WWW::Blogger::ML::API::register_all_opts( \%WWW::Blogger::HTML::API::opts_type_args );

push( @WWW::Blogger::HTML::API::EXPORT_OK,
      @{$WWW::Blogger::HTML::API::opts_type_args{'export_ok'}} );

#foreach my $x ( keys %{$WWW::Blogger::HTML::API::opts_type_args{'opts'}} )
#{
#   printf( "opts{%s}=%s\n", $x, $WWW::Blogger::HTML::API::opts_type_args{'opts'}{$x} );
#} ## end foreach

#foreach my $x ( @{$WWW::Blogger::HTML::API::opts_type_args{'export_ok'}} )
#{
#   printf( "ok=%s\n", $x );
#} ## end foreach

#foreach my $x ( @WWW::Blogger::HTML::API::EXPORT_OK )
#{
#   printf( "OK=%s\n", $x );
#} ## end foreach

##
## NOTE: Getopts hasn't set the options yet. (all flags = 0 right now)
##

$WWW::Blogger::HTML::API::url = 'http://www.blogger.com';

$WWW::Blogger::HTML::API::tree = HTML::TreeBuilder->new(); ## need one to work with
$WWW::Blogger::HTML::API::tree->delete();                  ## after each use to clean up

$WWW::Blogger::HTML::API::ua = LWP::UserAgent->new();

END {

} ## end END

##
## WWW::Blogger::HTML::API::show_all_opts
##
sub WWW::Blogger::HTML::API::show_all_opts
{
   WWW::Blogger::ML::API::show_all_opts( \%WWW::Blogger::HTML::API::opts_type_args );

} ## end sub WWW::Blogger::HTML::API::show_all_opts

##
## WWW::Blogger::HTML::API::tree_dumper
##
sub WWW::Blogger::HTML::API::tree_dumper
{
   my $tree = shift;

   my $i = 2;

   my $ima = 'tree'; ## dumper

   my $filename = $WWW::Blogger::HTML::API::opts_type_args{'opts_filename'}{"${ima}_dmp"};

   my $fh = IO::File->new();

   my $request = HTML::Request->new(); ## to ask for video page

   my $result = undef;

   $request->method( 'GET' );

=cut
   $fh->open( "+>${filename}.txt" ) ||
   die "opening: ${filename}.txt: $!\n";

   while ( defined( $tree->[1]->[2]->[$i-1] ) )
   {
      if ( ! $WWW::Blogger::XML::API::vlf{$tree->[1]->[2]->[$i]->[4]->[2]} )
      {
         $request->uri( $tree->[1]->[2]->[$i]->[24]->[2] );

         $result = WWW::Blogger::HTML::API::ask( $request );

         if ( $result->as_string() =~ m/class="error">(This video [^<]+)/ )
         {
            $fh->printf( "%s\n", $tree->[1]->[2]->[$i]->[4]->[2] .':'. $1 );

         }
         elsif ( $result->as_string() =~
                 m/>(This video may contain content that is inappropriate [^<]+)/ )
         {
            $fh->printf( "%s\n", $tree->[1]->[2]->[$i]->[4]->[2] .':'. 'adult content' );

         }
         else
         {
            $fh->printf( "%s\n", $tree->[1]->[2]->[$i]->[4]->[2] .':'. 'viewable' );

         } ## end if

      } ## end if

      $i += 2;

   } ## end while

   $fh->close();
=cut

} ## end sub WWW::Blogger::HTML::API::tree_dumper

##
## WWW::Blogger::HTML::API::ua_request_utf8
##
## returns a parse $tree and the $result (delete your $tree when you're done with it!)
##
sub WWW::Blogger::HTML::API::ua_request_utf8
{
   my ( $request, $control ) = @_;

   my $ua_info = 'sprintf( "WWW::Blogger::HTML::API::ua_request_utf8 failed: ? \$itry=%dof%d\n",
                            $itry-1, $max_try
                         )';

   my $result = undef;

   my $tree = undef;

   my ( $itry, $max_try ) = ( 1, 5 ); ## how many retries exactly?

   die( "ua_request_utf8 method error\n" ) if ( $request->method() ne 'GET' );

   while ( $itry++ <= $max_try )
   {
      ##debug##      print( STDERR "ua_request_utf8 makes request\n" );
      ##debug##      printf( STDERR "ua_request_utf8 %s\n", $request->uri() );

      ##BAD## $result = $WWW::Blogger::HTML::API::ua->mirror( $request, $content_file );

      $result = LWP::Simple::get( $request->uri() );

      last if ( defined( $result ) );

      print( STDERR eval( $ua_info ) ) if ( $itry > $max_try );

   } ## end while

   ##
   ## Simulating the Frontier::Client debug output style of XML::API::ua
   ##
   if ( $WWW::Blogger::HTML::API::flag_ua_dmp )
   {
      printf( STDERR "---- request ----\n%s\n", $request->as_string() );

   } ## end if

   if ( defined( $result ) )
   {
      ##debug##      print( STDERR "ua_request_utf8 got good result\n" );

      if ( 1 )
      {
         Encode::from_to( $result, 'utf8', 'Unicode' ); ## Solved! Keep adding problem chars!
         $result =~ s/[\xC2]/utf8(xC2)/g;               ##
         $result =~ s/[\xC3]/utf8(xC3)/g;               ##

         $result = HTTP::Response->parse( $result );

      }
      else
      {
         ##
         ## At least with what's here in this block, you'll see problem chars
         ##
         Encode::from_to( $result, 'utf8', 'Unicode' ); ## Solved! Keep adding problem chars!
         $result =~ s/[\xC2]/utf8(xC2)/g;               ##
         $result =~ s/[\xC3]/utf8(xC3)/g;               ##

         my $content_file = 'utf8content.html';

         my $fh_content = IO::File->new( $content_file, '+>:encoding(utf8)' );

         $fh_content->print( $result );

         undef( $fh_content );

         $fh_content = IO::File->new( $content_file, '<:encoding(utf8)' );

         my $save_slash = $/; undef( $/ );

         $result = <$fh_content>;

         $/ = $save_slash;

         undef( $fh_content );

         $result = HTTP::Response->parse( $result );

      } ## end if

      if ( $WWW::Blogger::HTML::API::flag_ua_dmp )
      {
         printf( STDERR "---- result  ----\n%s\n", $result->as_string() );

      } ## end if

      return ( $result ) if ( defined( $control->{'no_tree'} ) );

      $tree = HTML::TreeBuilder->new(); ## (delete your $tree when you're done with it!)

      $tree->parse( $result );

      $tree->eof();

      $tree->elementify(); ## NOTE: maybe I shouldn't do this all the time here?

      return ( $tree ) if ( defined( $control->{'no_result'} ) );

   }
   else
   {
      die eval( $ua_info );

   } ## end if

   ##
   ## XML::API::ask does if ( $tree->[1]->[0]->{status} eq 'ok' )
   ## HTML::API::ask does something even more useful:
   ##
   if ( 1 )
   {
      WWW::Blogger::HTML::API::tree_dumper( $tree ) if ( $WWW::Blogger::HTML::API::flag_tree_dmp );

   } ## end if

   return ( $tree, $result ); ## you get to pick one or keep both

} ## end sub WWW::Blogger::HTML::API::ua_request_utf8

##
## WWW::Blogger::HTML::API::ua_request
##
## returns a parse $tree and the $result (delete your $tree when you're done with it!)
##
sub WWW::Blogger::HTML::API::ua_request
{
   my ( $request, $control ) = @_;

   my $result = undef;

   my $tree = undef;

   my $ua_info = 'sprintf( "WWW::Blogger::HTML::API::ua_request failed: %s \$itry=%dof%d\n",
                            $result->status_line(), $itry-1, $max_try
                         )';

   my ( $itry, $max_try ) = ( 1, 5 ); ## how many retries exactly?

   while ( $itry++ <= $max_try )
   {
      ##debug##      print( STDERR "ua_request makes request\n" );

      $result = $WWW::Blogger::HTML::API::ua->request( $request );

      last if ( $result->is_success() );

      print( STDERR eval( $ua_info ) ) if ( $itry > $max_try );

   } ## end while

   ##
   ## Simulating the Frontier::Client debug output style of XML::API::ua
   ##
   if ( $WWW::Blogger::HTML::API::flag_ua_dmp )
   {
      printf( STDERR "---- request ----\n%s\n", $request->as_string() );

      printf( STDERR "---- result  ----\n%s\n", $result->as_string() );

   } ## end if

   if ( $result->is_success() )
   {
      ##debug##      print( STDERR "ua_request got good result\n" );

      return ( $result ) if ( defined( $control->{'no_tree'} ) );

      $tree = HTML::TreeBuilder->new(); ## (delete your $tree when you're done with it!)

      $tree->parse( $result );

      $tree->eof();

      $tree->elementify(); ## NOTE: maybe I shouldn't do this all the time here?

      return ( $tree ) if ( defined( $control->{'no_result'} ) );

   }
   else
   {
      die eval( $ua_info );

   } ## end if

   ##
   ## XML::API::ask does if ( $tree->[1]->[0]->{status} eq 'ok' )
   ## HTML::API::ask does something even more useful:
   ##
   if ( 1 )
   {
      WWW::Blogger::HTML::API::tree_dumper( $tree ) if ( $WWW::Blogger::HTML::API::flag_tree_dmp );

   } ## end if

   return ( $tree, $result ); ## you get to pick one or keep both

} ## end sub WWW::Blogger::HTML::API::ua_request

##
## WWW::Blogger::HTML::API::demo
##
sub WWW::Blogger::HTML::API::demo
{
} ## end sub WWW::Blogger::HTML::API::demo

1;
__END__ ## package WWW::Blogger::HTML::API

=head1 NAME

WWW::Blogger::HTML::API - How to Interface with Blogger using HTTP Protocol, CGI, returning HTML.

=head1 SYNOPSIS

 Options;

   --html_api_*

=head1 OPTIONS

--html_api_*

=head1 DESCRIPTION

HTML::API stands for HTML Application Programming Interface

=head1 SEE ALSO

I<L<WWW::Blogger>> I<L<WWW::Blogger::ML::API>> I<L<WWW::Blogger::HTML>> I<L<WWW::Blogger::XML::API>>

=head1 AUTHOR

 Copyright (C) 2008 Eric R. Meyers E<lt>Eric.R.Meyers@gmail.comE<gt>

=cut
