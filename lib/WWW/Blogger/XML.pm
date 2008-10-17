##
## WWW::Blogger::XML
##
package WWW::Blogger::XML;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2008.1017 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::Blogger::XML::ISA = qw(Exporter);

   @WWW::Blogger::XML::EXPORT = qw(); ## export required

   @WWW::Blogger::XML::EXPORT_OK =
   (

   ); ## export ok on request

} ## end BEGIN

require WWW::Blogger::XML::API;

require XML::TreeBuilder;

require XML::Dumper;

require XML::Atom::Syndication::Entry;
require XML::Atom::Syndication::Text;
require XML::Atom::Syndication::Content; 
require XML::Atom::Syndication::Person; 

require IO::Zlib;

require File::Basename;

require Date::Format;

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

##
## WWW::Blogger::XML::demo
##
sub WWW::Blogger::XML::demo
{
   my $request = undef;

   my $result = undef;

   my $xml_tree = undef;

   my $blogid = undef;

   $request = WWW::Blogger::XML::API::list_of_blogs_by_userid( 'default' );

   $result = WWW::Blogger::XML::API::ua_request( $request );

   if ( $result->is_success() )
   {
      $blogid = WWW::Blogger::XML::parse_list_of_blogs( $result );

   } ## end if

   WWW::Blogger::XML::clear_test_posts_by_blogid( $blogid );

   $request = WWW::Blogger::XML::test_post_by_blogid( $blogid );

   $result = WWW::Blogger::XML::API::ua_request( $request );

   if ( $result->is_success() )
   {
      WWW::Blogger::XML::parse_test_post_entry( $result );

   }
   else
   {
      print $result->as_string() . "\nFAILURE\n";

   } ## end if

   $request = WWW::Blogger::XML::API::list_of_posts_by_blogid( $blogid );

   $result = WWW::Blogger::XML::API::ua_request( $request );

   if ( $result->is_success() )
   {
      WWW::Blogger::XML::parse_list_of_posts( $result );

   }
   else
   {
      print $result->as_string() . "\nFAILURE\n";

   } ## end if

} ## end sub WWW::Blogger::XML::demo

##
## parse_list_of_blogs
##
sub WWW::Blogger::XML::parse_list_of_blogs
{
   my $result = shift;

   my $blogid = undef; ## returning for demonstration purposes

   my $xml_tree = XML::TreeBuilder->new(); 

   $xml_tree->parse( $result->content() );

   $xml_tree->eof();

   if ( $xml_tree->{'_tag'} eq 'feed' )
   {
      foreach my $xml_entry ( $xml_tree->find_by_tag_name('entry') ) ## blog entries
      {
         my $xml_id = $xml_entry->find_by_tag_name( 'id' );

         $xml_id->content()->[ 0 ] =~ m/[:]user[-](\d+)[.]blog[-](\d+)/;

         $blogid = $2 if ( ! defined( $blogid ) ); ## returning first for demonstration purposes

         ##debug##
         printf( "user=%s\tblogid=%s\n", $1, $2 );

         my $xml_title = $xml_entry->find_by_tag_name( 'title' );

         ##debug##
         printf( "title=%s\n", $xml_title->content()->[ 0 ] );

         foreach my $xml_link ( $xml_entry->find_by_tag_name( 'link' ) )
         {
            if ( $xml_link->attr( 'rel' ) eq 'alternate' )
            {
               ##debug##
               print "ALTERNATE " . $xml_link->attr( 'href' ) . "\n";

            }
            elsif ( $xml_link->attr( 'rel' ) eq 'http://schemas.google.com/g/2005#feed' )
            {
               ##debug##
               print "FEED      " . $xml_link->attr( 'href' ) . "\n";

            }
            elsif ( $xml_link->attr( 'rel' ) eq 'http://schemas.google.com/g/2005#post' )
            {
               ##debug##
               print "POST      " . $xml_link->attr( 'href' ) . "\n";

            }
            elsif ( $xml_link->attr( 'rel' ) eq 'self' )
            {
               ##debug##
               print "SELF      " . $xml_link->attr( 'href' ) . "\n";

            } ## end if

         } ## end foreach

      } ## end foreach

   } ## end if

   $xml_tree->delete();

   return( $blogid );

} ## end sub WWW::Blogger::XML::parse_list_of_blogs

##
## Publishing a blog post
##
## To publish this entry, send it to the blog's post URL as follows.
## First, place your Atom <entry> element in the body of a new POST request,
## using the application/atom+xml content type. Then find the blog's post URL
## in the metafeed by locating the <link> element where the rel attribute ends
## with #post. The blog's post URL is given as the href attribute of this
## element, which is in this format:
##
## http://www.blogger.com/feeds/blogID/posts/default
##
sub WWW::Blogger::XML::test_post_by_blogid
{
   my $blogid = shift;

   my $entry = XML::Atom::Syndication::Entry->new();

   my $title = XML::Atom::Syndication::Text->new( Name => 'title' );

   $title->body( 'Test Post' );

   my $content = XML::Atom::Syndication::Content->new( 'Type' => 'text',
                                                       'Body' => 'This is a test post.');

   my $author = XML::Atom::Syndication::Person->new( Name => 'author' );

   $author->name( 'Eric R. Meyers' );

   $author->email( 'Eric.R.Meyers@gmail.com' );

   ##
   ## Entry
   ##
   $entry->title( $title );

   $entry->content( $content );

   $entry->author( $author );

   ##
   ## Request
   ##
   my $request = WWW::Blogger::XML::API::post_entry_by_blogid( $blogid, $entry );

   return( $request );

} ## end sub WWW::Blogger::XML::test_post_by_blogid

##
## parse_test_post_entry
##
sub WWW::Blogger::XML::parse_test_post_entry
{
   my $result = shift;

   my $xml_tree = XML::TreeBuilder->new(); 

   $xml_tree->parse( $result->content() );

   $xml_tree->eof();

   my $xml_entry = $xml_tree->find_by_tag_name( 'entry' );

   my $xml_id = $xml_entry->find_by_tag_name( 'id' );

   $xml_id->content()->[ 0 ] =~ m/[:]blog[-](\d+)[.]post[-](\d+)/;

   ##
   ## Test Comments
   ##
   my $request = WWW::Blogger::XML::test_comment_by_blogid_postid( $1, $2 );

   $result = WWW::Blogger::XML::API::ua_request( $request ); #1
   $result = WWW::Blogger::XML::API::ua_request( $request ); #2

   $xml_tree->delete();

} ## end sub WWW::Blogger::XML::parse_test_post_entry

##
## parse_list_of_posts
##
sub WWW::Blogger::XML::parse_list_of_posts
{
   my $result = shift;

   my $xml_tree = XML::TreeBuilder->new(); 

   $xml_tree->parse( $result->content() );

   $xml_tree->eof();

   if ( $xml_tree->{'_tag'} eq 'feed' )
   {
      foreach my $xml_entry ( $xml_tree->find_by_tag_name( 'entry' ) )
      {
         my $xml_id = $xml_entry->find_by_tag_name( 'id' );

         $xml_id->content()->[ 0 ] =~ m/[:]blog[-](\d+)[.]post[-](\d+)/;

         ##debug##
         printf( "blogid=%s\tpostid=%s\n", $1, $2 );

         my $xml_title = $xml_entry->find_by_tag_name( 'title' );

         ##debug##
         printf( "title=%s\n", $xml_title->content()->[ 0 ] );

         foreach my $xml_link ( $xml_entry->find_by_tag_name( 'link' ) )
         {
            if ( $xml_link->attr( 'rel' ) eq 'alternate' )
            {
               ##debug##
               print "ALTERNATE " . $xml_link->attr( 'href' ) . "\n";

            }
            elsif ( $xml_link->attr( 'rel' ) eq 'edit' )
            {
               ##debug##
               print "EDIT      " . $xml_link->attr( 'href' ) . "\n";

            }
            elsif ( $xml_link->attr( 'rel' ) eq 'replies' )
            {
               ##debug##
               print "REPLIES   " . $xml_link->attr( 'href' ) . "\n";

            }
            elsif ( $xml_link->attr( 'rel' ) eq 'self' )
            {
               ##debug##
               print "SELF      " . $xml_link->attr( 'href' ) . "\n";

            } ## end if

         } ## end foreach

      } ## end foreach

   } ## end if

   $xml_tree->delete();

} ## end sub WWW::Blogger::XML::parse_list_of_posts

##
## Test comment
##
sub WWW::Blogger::XML::test_comment_by_blogid_postid
{
   my ( $blogid, $postid ) = @_;

   my $entry = XML::Atom::Syndication::Entry->new();

   my $title = XML::Atom::Syndication::Text->new( Name => 'title' );

   $title->body( 'Test Comment' );

   my $content = XML::Atom::Syndication::Content->new( 'Type' => 'text',
                                                       'Body' => 'This is a test comment.');

   my $author = XML::Atom::Syndication::Person->new( Name => 'author' );

   $author->name( 'Eric R. Meyers' );

   $author->email( 'Eric.R.Meyers@gmail.com' );

   ##
   ## Entry
   ##
   $entry->title( $title );

   $entry->content( $content );

   $entry->author( $author );

   ##
   ## Request
   ##
   my $request = WWW::Blogger::XML::API::comment_entry_by_blogid_postid( $blogid, $postid, $entry );

   return( $request );

} ## end sub WWW::Blogger::XML::test_comment_by_blogid_postid

##
## clear test post of all test comments
##
sub WWW::Blogger::XML::clear_test_comments_by_blogid_postid
{
   my ( $blogid, $postid ) = @_;

   my $request = WWW::Blogger::XML::API::list_of_comments_by_blogid_postid( $blogid, $postid );

   my $result = WWW::Blogger::XML::API::ua_request( $request );

   if ( $result->is_success() )
   {
      my $xml_tree = XML::TreeBuilder->new(); 

      $xml_tree->parse( $result->content() );

      $xml_tree->eof();

      if ( $xml_tree->{'_tag'} eq 'feed' )
      {
         foreach my $xml_entry ( $xml_tree->find_by_tag_name( 'entry' ) ) ## comment entries
         {
            my $xml_content = $xml_entry->find_by_tag_name( 'content' );

            next if ( $xml_content->content()->[ 0 ] ne 'This is a test comment.' );

            my $xml_id = $xml_entry->find_by_tag_name( 'id' );

            $xml_id->content()->[ 0 ] =~ m/[:]blog[-](\d+)[.]post[-](\d+)/; ## commentid

            my $commentid = $2;

            $request = WWW::Blogger::XML::API::remove_comment_by_blogid_postid_commentid( $blogid, $postid, $commentid );

            $result = WWW::Blogger::XML::API::ua_request( $request );

         } ## end foreach

      } ## end if

      $xml_tree->delete();

   } ## end if

} ## end sub WWW::Blogger::XML::clear_test_comments_by_blogid_postid

##
## clear test blog of all test posts
##
sub WWW::Blogger::XML::clear_test_posts_by_blogid
{
   my $blogid = shift;

   my $request = WWW::Blogger::XML::API::list_of_posts_by_blogid( $blogid );

   my $result = WWW::Blogger::XML::API::ua_request( $request );

   if ( $result->is_success() )
   {
      my $xml_tree = XML::TreeBuilder->new(); 

      $xml_tree->parse( $result->content() );

      $xml_tree->eof();

      if ( $xml_tree->{'_tag'} eq 'feed' )
      {
         foreach my $xml_entry ( $xml_tree->find_by_tag_name( 'entry' ) ) ## post entries
         {
            my $xml_title = $xml_entry->find_by_tag_name( 'title' );

            next if ( $xml_title->content()->[ 0 ] ne 'Test Post' );

            my $xml_id = $xml_entry->find_by_tag_name( 'id' );

            $xml_id->content()->[ 0 ] =~ m/[:]blog[-](\d+)[.]post[-](\d+)/; ## postid

            my $postid = $2;

            WWW::Blogger::XML::clear_test_comments_by_blogid_postid( $blogid, $postid );

            $request = WWW::Blogger::XML::API::remove_post_by_blogid_postid( $blogid, $postid );

            $result = WWW::Blogger::XML::API::ua_request( $request );

         } ## end foreach

      } ## end if

      $xml_tree->delete();

   } ## end if

} ## end sub WWW::Blogger::XML::clear_test_posts_by_blogid

1;
__END__ ## package WWW::Blogger::XML

=head1 NAME

WWW::Blogger::XML - General Extensible Markup Language capabilities go in here.

=head1 SYNOPSIS

=head1 OPTIONS

=head1 DESCRIPTION

   WWW::Blogger XML Layer.

=head1 SEE ALSO

I<L<WWW::Blogger>> I<L<WWW::Blogger::ML>> I<L<WWW::Blogger::XML::API>>

=head1 AUTHOR

 Copyright (C) 2008 Eric R. Meyers E<lt>Eric.R.Meyers@gmail.comE<gt>

=cut

