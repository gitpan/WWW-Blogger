##
## WWW::Blogger::XML::API
##
package WWW::Blogger::XML::API;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2008.0501 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::Blogger::XML::API::ISA = qw(Exporter);

   @WWW::Blogger::XML::API::EXPORT = qw(); ## export required

   @WWW::Blogger::XML::API::EXPORT_OK =
   (
   ); ## export ok on request

} ## end BEGIN

##
## Use HTTPS! AtomAPIdoc=http://code.blogger.com/archives/atom-docs.html
##

require Net::Google::GData;

require WWW::Blogger::Com; ## NOTE: I need WWW::Google secrets

require WWW::Blogger::HTML::API; ## NOTE: HTML/XML crossover

require WWW::Blogger::ML::API; ## NOTE: generic *ML

require XML::TreeBuilder; ## XML::API::tree parser

require XML::Dumper;

require XML::Atom::Syndication::Entry;
require XML::Atom::Syndication::Text;
require XML::Atom::Syndication::Content; 
require XML::Atom::Syndication::Person; 

require Data::Dumper; ## get rid of this

require IO::File;

##debug##require FindBin;
##debug##require Cwd;

require Date::Format;

$WWW::Blogger::XML::API::url = 'https://www.blogger.com';

__PACKAGE__ =~ m/^(WWW::[^:]+)::([^:]+)(::([^:]+)){0,1}$/;

##debug##print( "API! $1::$2::$4\n" );

%WWW::Blogger::XML::API::opts_type_args =
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

); ## this does the work with opts and optype_flag(s)

die( __PACKAGE__ ) if (
     __PACKAGE__ ne join( '::', $WWW::Blogger::XML::API::opts_type_args{'ido'},
                                $WWW::Blogger::XML::API::opts_type_args{'iknow'},
                                $WWW::Blogger::XML::API::opts_type_args{'iman'}
                        )
                      );

WWW::Blogger::ML::API::create_opts_types( \%WWW::Blogger::XML::API::opts_type_args );

$WWW::Blogger::XML::API::numeric_max_try = $WWW::Blogger::ML::API::numeric_max_try;
$WWW::Blogger::XML::API::string_dbm_dir = $WWW::Blogger::ML::API::string_dbm_dir.'/xml';

##debug##$WWW::Blogger::XML::API::numeric_max_try++;
##debug##printf( STDERR "WWW::Blogger::XML::API::numeric_max_try=%d\n", $WWW::Blogger::XML::API::numeric_max_try );
##debug##printf( STDERR "WWW::Blogger::ML::API::numeric_max_try=%d\n", $WWW::Blogger::ML::API::numeric_max_try );

WWW::Blogger::ML::API::register_all_opts( \%WWW::Blogger::XML::API::opts_type_args );

push( @WWW::Blogger::XML::API::EXPORT_OK,
      @{$WWW::Blogger::XML::API::opts_type_args{'export_ok'}} );

#foreach my $x ( keys %{$WWW::Blogger::XML::API::opts_type_args{'opts'}} )
#{
#   printf( "opts{%s}=%s\n", $x, $WWW::Blogger::XML::API::opts_type_args{'opts'}{$x} );
#} ## end foreach

#foreach my $x ( @{$WWW::Blogger::XML::API::opts_type_args{'export_ok'}} )
#{
#   printf( "ok=%s\n", $x );
#} ## end foreach

#foreach my $x ( @WWW::Blogger::XML::API::EXPORT_OK )
#{
#   printf( "OK=%s\n", $x );
#} ## end foreach

##
## NOTE: Getopts hasn't set the options yet. (all flags = 0 right now)
##
## I've deferred the instantiation of this qw(ua) until needed.
## That occurs when creating the xmlrpc request types ( qw(ua->string), etc.).
## I fixed this problem with qw(ua_central) function.
##
$WWW::Blogger::XML::API::ua = undef; ## Frontier::Client see NOTE above, goto qw(ua_central) function

$WWW::Blogger::XML::API::tree = undef;

$WWW::Blogger::XML::API::gdi = Net::Google::GData->new(
                                                          'service' => 'blogger',
                                                          'Email'   => $WWW::Blogger::Com::user,
                                                          'Passwd'  => $WWW::Blogger::Com::pass,
                                                       );

$WWW::Blogger::XML::API::gdi->login();

END {

} ## end END

##
## WWW::Blogger::XML::API::show_all_opts
##
sub WWW::Blogger::XML::API::show_all_opts
{
   WWW::Blogger::ML::API::show_all_opts( \%WWW::Blogger::XML::API::opts_type_args );

} ## end sub WWW::Blogger::XML::API::show_all_opts

##
## WWW::Blogger::XML::API::request_dumper
##
sub WWW::Blogger::XML::API::request_dumper
{
   my $request = shift;

   my $ima = 'request'; ## dumper

   my $filename = $WWW::Blogger::XML::API::opts_type_args{'opts_filename'}{"${ima}_dmp"};

   my $fh = IO::File->new();

   $fh->open( "+>${filename}.txt" ) ||
   die "opening: ${filename}.txt: $!\n";

   $fh->print( Data::Dumper->Dump( [ $request ], [ $ima ] ) );

   $fh->close();

} ## end sub WWW::Blogger::XML::API::request_dumper

##
## WWW::Blogger::XML::API::result_dumper
##
sub WWW::Blogger::XML::API::result_dumper
{
   my $result = shift;

   my $ima = 'result'; ## dumper

   my $filename = $WWW::Blogger::XML::API::opts_type_args{'opts_filename'}{"${ima}_dmp"};

   my $fh = IO::File->new();

   ##
   ## .xml
   ##
   $fh->open( "+>${filename}.xml" ) ||
   die "opening: ${filename}.xml: $!\n";

   $fh->print( $result->content() );

   $fh->close();

   ##
   ## .txt
   ##
   $fh->open( "+>${filename}.txt" ) ||
   die "opening: ${filename}.txt: $!\n";

   $fh->print( Data::Dumper->Dump( [ $result ], [ $ima ] ) );

   $fh->close();

} ## end sub WWW::Blogger::XML::API::result_dumper

##
## WWW::Blogger::XML::API::tree_dumper
##
sub WWW::Blogger::XML::API::tree_dumper
{
   my $tree = shift;

   my $ima = 'tree'; ## dumper

   my $filename = $WWW::Blogger::XML::API::opts_type_args{'opts_filename'}{"${ima}_dmp"};

   my $fh = IO::File->new();

   $fh->open( "+>${filename}.txt" ) ||
   die "opening: ${filename}.txt: $!\n";

   $fh->print( Data::Dumper->Dump( [ $tree ], [ $ima ] ) );

   $fh->close();

} ## end sub WWW::Blogger::XML::API::tree_dumper

##
## WWW::Blogger::XML::API::ua_request
##
sub WWW::Blogger::XML::API::ua_request
{
   my $request = shift;

   $request->header( 'Authorization' => 'GoogleLogin auth=' . $WWW::Blogger::XML::API::gdi->_auth() );

   WWW::Blogger::XML::API::request_dumper( $request ) if ( $WWW::Blogger::XML::API::flag_request_dmp );

   my $result = WWW::Blogger::HTML::API::ua_request( $request );

   if ( ! $result->is_success() )
   {
      printf( STDERR "Failed: %s\n", $result->status_line() );

   }
   else
   {
      WWW::Blogger::XML::API::result_dumper( $result ) if ( $WWW::Blogger::XML::API::flag_result_dmp );

   } ## end if

   return ( $result );

} ## end sub WWW::Blogger::XML::API::ua_request

##
## See: http://code.google.com/apis/gdata/reference.html
##
## The Atom response feed and entries may also include any of the following Atom and GData elements
## (as well as others listed in the Atom specification):
##
#<link rel="http://schemas.google.com/g/2005#feed" type="application/atom+xml" href="..."/>
#      Specifies the URI where the complete Atom feed can be retrieved.
#
#<link rel="http://schemas.google.com/g/2005#post" type="application/atom+xml" href="..."/>
#      Specifies the Atom feed's PostURI (where new entries can be posted).
#
#<link rel="self" type="..." href="..."/>
#      Contains the URI of this resource.
#      The value of the type attribute depends on the requested format.
#      If no data changes in the interim, sending another GET to this URI returns the same response.
#
#<link rel="previous" type="application/atom+xml" href="..."/>
#      Specifies the URI of the previous chunk of this query result set, if it is chunked.
#
#<link rel="next" type="application/atom+xml" href="..."/>
#      Specifies the URI of the next chunk of this query result set, if it is chunked.
#
#<link rel="edit" type="application/atom+xml" href="..."/>
#      Specifies the Atom entry's EditURI (where you send an updated entry).

##
## WWW:Blogger Test 1 (1538373143315425622) Entry
## ------------------ ( ---- blogid ----- ) Type
##
##HTML##<link href="http://wwwbloggertest1.blogspot.com/"
##(get)        rel="alternate" type="text/html"></link>
##
##FEED###<link href="http://wwwbloggertest1.blogspot.com/feeds/posts/default"
##(get)         rel="http://schemas.google.com/g/2005#feed" type="application/atom+xml"></link>
##
##POST##<link href="http://www.blogger.com/feeds/1538373143315425622/posts/default"
##(post)       rel="http://schemas.google.com/g/2005#post" type="application/atom+xml"></link>
##
##SELF##<link href="http://www.blogger.com/feeds/10829698745685235014/blogs/1538373143315425622"
##(get)       rel="self" type="application/atom+xml"></link>

##
## WWW::Blogger::XML::API::demo
##
sub WWW::Blogger::XML::API::demo
{
   my $request = undef;

   my $result = undef;

   my $xml_tree = undef;

   $request = WWW::Blogger::XML::API::list_of_blogs_by_userid( '10829698745685235014' );

   $result = WWW::Blogger::XML::API::ua_request( $request );

   if ( $result->is_success() )
   {
      WWW::Blogger::XML::API::parse_list_of_blogs( $result );

   } ## end if

   WWW::Blogger::XML::API::clear_test_posts_by_blogid( '1538373143315425622' );

   $request = WWW::Blogger::XML::API::test_post_by_blogid( '1538373143315425622' );

   $result = WWW::Blogger::XML::API::ua_request( $request );

   if ( $result->is_success() )
   {
      WWW::Blogger::XML::API::parse_test_post_entry( $result );

   }
   else
   {
      print $result->as_string() . "\nfailure\n";

   } ## end if

   $request = WWW::Blogger::XML::API::list_of_posts_by_blogid( '1538373143315425622' );

   $result = WWW::Blogger::XML::API::ua_request( $request );

   if ( $result->is_success() )
   {
      WWW::Blogger::XML::API::parse_list_of_posts( $result );

   }
   else
   {
      print $result->as_string() . "\nfailure\n";

   } ## end if

} ## end sub WWW::Blogger::XML::API::demo

##
## Retrieving a list of blogs
## GET http://www.blogger.com/feeds/userID/blogs
##
sub WWW::Blogger::XML::API::list_of_blogs_by_userid
{
   my $userid = shift || 'default';

   my $request = HTTP::Request->new( 'GET', $WWW::Blogger::XML::API::url . "/feeds/${userid}/blogs" );

   return( $request );

} ## end sub WWW::Blogger::XML::API::list_of_blogs_by_userid

##
## parse_list_of_blogs
##
sub WWW::Blogger::XML::API::parse_list_of_blogs
{
   my $result = shift;

   my $xml_tree = XML::TreeBuilder->new(); 

   $xml_tree->parse( $result->content() );

   $xml_tree->eof();

   if ( $xml_tree->{'_tag'} eq 'feed' )
   {
      WWW::Blogger::XML::API::tree_dumper( $xml_tree ) if ( $WWW::Blogger::XML::API::flag_tree_dmp );

      foreach my $xml_entry ( $xml_tree->find_by_tag_name('entry') ) ## blog entries
      {
         my $xml_id = $xml_entry->find_by_tag_name( 'id' );

         $xml_id->content()->[ 0 ] =~ m/[:]user[-](\d+)[.]blog[-](\d+)/;

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

} ## end sub WWW::Blogger::XML::API::parse_list_of_blogs

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
sub WWW::Blogger::XML::API::test_post_by_blogid
{
   my $blogid = shift;

   my $entry = XML::Atom::Syndication::Entry->new();

   my $title = XML::Atom::Syndication::Text->new( Name => 'title' );

   $title->body( 'Test Post' );

   my $content = XML::Atom::Syndication::Content->new( 'Type' => 'text',
                                                       'Body' => 'This is a test post.');

   my $author = XML::Atom::Syndication::Person->new( Name => 'author' );

   $author->name('Eric R. Meyers');

   $author->email('Eric.R.Meyers@gmail.com');

   ##
   ## Entry
   ##
   $entry->title($title);

   $entry->content($content);

   $entry->author($author);

   ##
   ## Request
   ##
   my $request = HTTP::Request->new();

   $request->method( 'POST' );

   $request->uri( $WWW::Blogger::XML::API::url . "/feeds/${blogid}/posts/default" );

   $request->header( 'Content_Type' => 'application/atom+xml' );

   $request->content( $entry->as_xml() );

   return( $request );

} ## end sub WWW::Blogger::XML::API::test_post_by_blogid

##
## parse_test_post_entry
##
sub WWW::Blogger::XML::API::parse_test_post_entry
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
   my $request = WWW::Blogger::XML::API::test_comment_by_blogid_postid( $1, $2 );

   $result = WWW::Blogger::XML::API::ua_request( $request );
   $result = WWW::Blogger::XML::API::ua_request( $request );

   $xml_tree->delete();

} ## end sub WWW::Blogger::XML::API::parse_test_post_entry

##
## Retrieving all blog posts
##
## To retrieve the user's posts, send an HTTP GET request to the blog's feed URL.
## Blogger then returns a feed containing the appropriate blog entries.
## For example, to get a list of blog posts for liz@gmail.com, send the following
## HTTP request to Blogger (with the appropriate value in place of blogID, of course):
##
## GET http://www.blogger.com/feeds/blogID/posts/default
##
sub WWW::Blogger::XML::API::list_of_posts_by_blogid
{
   my $blogid = shift;

   my $request = HTTP::Request->new( 'GET', $WWW::Blogger::XML::API::url . "/feeds/${blogid}/posts/default" );

   return( $request );

} ## end sub WWW::Blogger::XML::API::list_of_posts_by_blogid

##
## parse_list_of_posts
##
sub WWW::Blogger::XML::API::parse_list_of_posts
{
   my $result = shift;

   my $xml_tree = XML::TreeBuilder->new(); 

   $xml_tree->parse( $result->content() );

   $xml_tree->eof();

   if ( $xml_tree->{'_tag'} eq 'feed' )
   {
      WWW::Blogger::XML::API::tree_dumper( $xml_tree ) if ( $WWW::Blogger::XML::API::flag_tree_dmp );

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

} ## end sub WWW::Blogger::XML::API::parse_list_of_posts

##
## Modifying a post entry
##
## (get it)
## GET http://www.blogger.com/feeds/blogID/posts/default/postID
## (edit it to update it)
## PUT http://www.blogger.com/feeds/blogID/posts/default/postID
##

##
## Retrieve a post entry
##
sub WWW::Blogger::XML::API::get_post_by_blogid_postid
{
   my ( $blogid, $postid ) = @_;

   my $request = HTTP::Request->new( 'GET', $WWW::Blogger::XML::API::url . "/feeds/${blogid}/posts/default/${postid}" );

   return( $request );

} ## end sub WWW::Blogger::XML::API::get_post_by_blogid_postid

##
## Updating a post entry
##
sub WWW::Blogger::XML::API::put_post_by_blogid_postid
{
   my ( $blogid, $postid ) = @_;

   my $request = HTTP::Request->new( 'PUT', $WWW::Blogger::XML::API::url . "/feeds/${blogid}/posts/default/${postid}" );

   return( $request );

} ## end sub WWW::Blogger::XML::API::put_post_by_blogid_postid

##
## Removing a post entry
##
## DELETE http://www.blogger.com/feeds/blogID/posts/default/postID
##
sub WWW::Blogger::XML::API::remove_post_by_blogid_postid
{
   my ( $blogid, $postid ) = @_;

   my $request = HTTP::Request->new( 'DELETE', $WWW::Blogger::XML::API::url . "/feeds/${blogid}/posts/default/${postid}" );

   return( $request );

} ## end sub WWW::Blogger::XML::API::remove_post_by_blogid_postid

##
## About Comments:
## The Blogger Data API allows for creating, retrieving, and deleting comments.
## Updating comments is not supported (nor is it available in the web interface).
##

##
## Publishing a comment for a post
## To publish this comment, place your Atom <entry> element in the body of a
## new POST request, using the application/atom+xml content type.
## Then send the POST request to the appropriate Blogger URL:
##
## POST http://www.blogger.com/feeds/blogID/postID/comments/default
##
sub WWW::Blogger::XML::API::test_comment_by_blogid_postid
{
   my ( $blogid, $postid ) = @_;

   my $entry = XML::Atom::Syndication::Entry->new();

   my $title = XML::Atom::Syndication::Text->new( Name => 'title' );

   $title->body( 'Test Comment' );

   my $content = XML::Atom::Syndication::Content->new( 'Type' => 'text',
                                                       'Body' => 'This is a test comment.');

   my $author = XML::Atom::Syndication::Person->new( Name => 'author' );

   $author->name('Eric R. Meyers');

   $author->email('Eric.R.Meyers@gmail.com');

   ##
   ## Entry
   ##
   $entry->title($title);

   $entry->content($content);

   $entry->author($author);

   ##
   ## Request
   ##
   my $request = HTTP::Request->new();

   $request->method( 'POST' );

   $request->uri( $WWW::Blogger::XML::API::url . "/feeds/${blogid}/${postid}/comments/default" );

   $request->header( 'Content_Type' => 'application/atom+xml' );

   $request->content( $entry->as_xml() );

   return( $request );

} ## end sub WWW::Blogger::XML::API::test_comment_by_blogid_postid

##
## Retrieving all comments for a blog
## GET http://www.blogger.com/feeds/blogID/comments/default
##
sub WWW::Blogger::XML::API::list_of_comments_by_blogid
{
   my $blogid = shift;

   my $request = HTTP::Request->new( 'GET', $WWW::Blogger::XML::API::url . "/feeds/${blogid}/comments/default" );

   return( $request );

} ## end sub WWW::Blogger::XML::API::list_of_comments_by_blogid

##
## Retrieving comments for a particular post
## GET http://www.blogger.com/feeds/blogID/postID/comments/default
##
sub WWW::Blogger::XML::API::list_of_comments_by_blogid_postid
{
   my ( $blogid, $postid ) = @_;

   my $request = HTTP::Request->new( 'GET', $WWW::Blogger::XML::API::url .  "/feeds/${blogid}/${postid}/comments/default" );

   return( $request );

} ## end sub WWW::Blogger::XML::API::list_of_comments_by_blogid_postid

##
## Removing a comment
##
## DELETE http://www.blogger.com/feeds/blogID/postID/comments/default/commentID
##
sub WWW::Blogger::XML::API::remove_comment_by_blogid_postid_commentid
{
   my ( $blogid, $postid, $commentid ) = @_;

   my $request = HTTP::Request->new( 'DELETE', $WWW::Blogger::XML::API::url . "/feeds/${blogid}/${postid}/comments/default/${commentid}" );

   return( $request );

} ## end sub WWW::Blogger::XML::API::remove_comment_by_blogid_postid_commentid

##
## clear test post of all test comments
##
sub WWW::Blogger::XML::API::clear_test_comments_by_blogid_postid
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
            my $xml_id = $xml_entry->find_by_tag_name( 'id' );

            $xml_id->content()->[ 0 ] =~ m/[:]blog[-](\d+)[.]post[-](\d+)/; ## commentid

            my $commentid = $2;

            $request = WWW::Blogger::XML::API::remove_comment_by_blogid_postid_commentid( $blogid, $postid, $commentid );

            $result = WWW::Blogger::XML::API::ua_request( $request );

         } ## end foreach

      } ## end if

      $xml_tree->delete();

   } ## end if

} ## end sub WWW::Blogger::XML::API::clear_test_comments_by_blogid_postid

##
## clear test blog of all test posts
##
sub WWW::Blogger::XML::API::clear_test_posts_by_blogid
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
            my $xml_id = $xml_entry->find_by_tag_name( 'id' );

            $xml_id->content()->[ 0 ] =~ m/[:]blog[-](\d+)[.]post[-](\d+)/; ## postid

            my $postid = $2;

            WWW::Blogger::XML::API::clear_test_comments_by_blogid_postid( $blogid, $postid );

            $request = WWW::Blogger::XML::API::remove_post_by_blogid_postid( $blogid, $postid );

            $result = WWW::Blogger::XML::API::ua_request( $request );

         } ## end foreach

      } ## end if

      $xml_tree->delete();

   } ## end if

} ## end sub WWW::Blogger::XML::API::clear_test_posts_by_blogid

1;
__END__ ## package WWW::Blogger::XML::API

=head1 NAME

WWW::Blogger::XML::API - How to Interface with Blogger using HTTP Protocol and GData XML Atom API.

http://code.google.com/apis/blogger/developers_guide_protocol.html

=head1 SYNOPSIS

 use WWW::Blogger;

 my $request = WWW::Blogger::XML::API::list_of_blogs_by_userid( $userid );

 my $result = WWW::Blogger::XML::API::ua_request( $request );

 Options;

   --xml_api_*

=head1 OPTIONS

--xml_api_*

=head1 DESCRIPTION

XML::API stands for XML Application Programming Interface

See:	http://code.blogger.com
	http://code.google.com/apis/blogger
	http://code.google.com/apis/blogger/developers_guide_protocol.html


=head2	Demo

=over

WWW::Blogger::XML::API::demo()

=back

=head2  Retrieving a list of blogs

=over

$request = WWW::Blogger::XML::API::list_of_blogs_by_userid( $userid );

$result = WWW::Blogger::XML::API::ua_request( $request );

See Example: WWW::Blogger::XML::API::parse_list_of_blogs( $result )

=back

=head2	Creating posts

=over

$request = WWW::Blogger::XML::API::test_post_by_blogid( $blogid ) ## a Test Post

$result = WWW::Blogger::XML::API::ua_request( $request );

See Example: WWW::Blogger::XML::API::parse_test_post_entry( $result );

=back

1. Publishing a blog post

=over

Follow the "Test Post" example to create your XML::Atom::Syndication::Entry.

=back

2. Creating a draft blog post

=over

TBD

=back

=head2	Retrieving posts

1. Retrieving all blog posts

=over

$request = WWW::Blogger::XML::API::list_of_posts_by_blogid( $blogid );

$result = WWW::Blogger::XML::API::ua_request( $request );

=back

2. Retrieving posts using query parameters

=over

TBD

=back

=head2	Updating posts

=over

$request = WWW::Blogger::XML::API::get_post_by_blogid_postid( $blogid, $postid );

$result = WWW::Blogger::XML::API::ua_request( $request );

## Edit the Entry, then put the update

$request = WWW::Blogger::XML::API::put_post_by_blogid_postid( $blogid, $postid, $entry );

$result = WWW::Blogger::XML::API::ua_request( $request );

=back

=head2	Deleting posts

=over

$request = WWW::Blogger::XML::API::remove_post_by_blogid_postid( $blogid, $postid );

$result = WWW::Blogger::XML::API::ua_request( $request );

=back

=head2	Comments

1. Creating comments

=over

$request = WWW::Blogger::XML::API::test_comment_by_blogid_postid( $blogid, $postid ); ## a Test Comment

$result = WWW::Blogger::XML::API::ua_request( $request );

Follow the "Test Comment" example to create your XML::Atom::Syndication::Entry.

=back

2. Retrieving comments

=over

$request = WWW::Blogger::XML::API::list_of_comments_by_blogid( $blogid );

-OR-

$request = WWW::Blogger::XML::API::list_of_comments_by_blogid_postid( $blogid, $postid );

$result = WWW::Blogger::XML::API::ua_request( $request );

=back

3. Deleting comments

=over

$request = WWW::Blogger::XML::API::remove_comment_by_blogid_postid_commentid( $blogid, $postid, $commentid );

$result = WWW::Blogger::XML::API::ua_request( $request );

=back

=head1 SEE ALSO

I<L<WWW::Blogger>> I<L<WWW::Blogger::ML::API>> I<L<WWW::Blogger::HTML::API>> I<L<WWW::Blogger::XML>>

=head1 AUTHOR

 Copyright (C) 2008 Eric R. Meyers E<lt>Eric.R.Meyers@gmail.comE<gt>

=cut

