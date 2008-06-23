##
## WWW::Blogger::XML::API
##
package WWW::Blogger::XML::API;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2008.0623 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::Blogger::XML::API::ISA = qw(Exporter);

   @WWW::Blogger::XML::API::EXPORT = qw(); ## export required

   @WWW::Blogger::XML::API::EXPORT_OK =
   (
   ); ## export ok on request

} ## end BEGIN

require AppConfig::Std;

require Net::Google::GData;

require WWW::Blogger::ML::API; ## NOTE: generic *ML

require Data::Dumper; ## get rid of this

require IO::File;

require Date::Format;

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
   ],
   'opts_type_numeric' =>
   [
      @{$WWW::Blogger::ML::API::opts_type_args{'opts_type_numeric'}},
   ],
   'opts_type_string' =>
   [
      @{$WWW::Blogger::ML::API::opts_type_args{'opts_type_string'}},
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

$WWW::Blogger::XML::API::url = 'https://www.blogger.com';

$WWW::Blogger::XML::API::config = AppConfig::Std->new();

$WWW::Blogger::XML::API::config_file = File::Spec->catfile( $ENV{'HOME'}, '.www_blogger_rc' );

$WWW::Blogger::XML::API::config->define( 'username', { EXPAND   => 0 } );
$WWW::Blogger::XML::API::config->define( 'password', { EXPAND   => 0 } );

if ( ! -e $WWW::Blogger::XML::API::config_file )
{
   system( "echo 'username = ' > $WWW::Blogger::XML::API::config_file" );
   system( "echo 'password = ' >> $WWW::Blogger::XML::API::config_file" );

} ## end if

if ( -e $WWW::Blogger::XML::API::config_file &&
     ( ( ( stat( $WWW::Blogger::XML::API::config_file ) )[2] & 36 ) != 0 )
   )
{
   die "Your config file $WWW::Blogger::XML::API::config_file is readable by others!\n";

} ## end if

if ( -f $WWW::Blogger::XML::API::config_file )
{
   $WWW::Blogger::XML::API::config->file( $WWW::Blogger::XML::API::config_file )
   || die "reading $WWW::Blogger::XML::API::config_file\n";

} ## end if

##debug##printf( "username='%s'\n", $WWW::Blogger::XML::API::config->username() );
##debug##printf( "password='%s'\n", $WWW::Blogger::XML::API::config->password() );

$WWW::Blogger::XML::API::gdi = Net::Google::GData->new( 'service' => 'blogger',
                                  'Email'  => $WWW::Blogger::XML::API::config->username(),
                                  'Passwd' => $WWW::Blogger::XML::API::config->password(),
                                                      );

$WWW::Blogger::XML::API::gdi->login() || die "login failed: ".$WWW::Blogger::XML::API::gdi->errstr()."\n";

$WWW::Blogger::XML::API::ua = $WWW::Blogger::XML::API::gdi->_ua();

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
## WWW::Blogger::XML::API::ua_request
##
sub WWW::Blogger::XML::API::ua_request
{
   my $request = shift;

   my $result = undef;

   my $ua_info = 'sprintf( "WWW::Blogger::XML::API::ua_request failed: %s \$itry=%dof%d\n",
                            $result->status_line(), $itry-1, $max_try
                         )';

   my ( $itry, $max_try ) = ( 1, $WWW::Blogger::XML::API::numeric_max_try );

   while ( $itry++ <= $max_try )
   {
      $result = $WWW::Blogger::XML::API::ua->request( $request );

      last if ( $result->is_success() );

      print( STDERR eval( $ua_info ) ) if ( $itry > $max_try );

   } ## end while

   WWW::Blogger::XML::API::request_dumper( $request ) if ( $WWW::Blogger::XML::API::flag_request_dmp );

   if ( $WWW::Blogger::XML::API::flag_ua_dmp )
   {
      printf( STDERR "---- request ----\n%s\n", $request->as_string() );

      printf( STDERR "---- result  ----\n%s\n", $result->as_string() );

   } ## end if

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
## Retrieving a list of blogs
## GET http://www.blogger.com/feeds/userID/blogs
##
sub WWW::Blogger::XML::API::list_of_blogs_by_userid
{
   my $userid = shift || 'default';

   my $request = HTTP::Request->new();

   $request->method( 'GET' );

   $request->uri( $WWW::Blogger::XML::API::url . "/feeds/${userid}/blogs" );

   return( $request );

} ## end sub WWW::Blogger::XML::API::list_of_blogs_by_userid

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

   my $request = HTTP::Request->new();

   $request->method( 'GET' );

   $request->uri( $WWW::Blogger::XML::API::url . "/feeds/${blogid}/posts/default" );

   return( $request );

} ## end sub WWW::Blogger::XML::API::list_of_posts_by_blogid

##
## Creating a post entry
##
sub WWW::Blogger::XML::API::post_entry_by_blogid
{
   my ( $blogid, $entry ) = @_;

   my $request = HTTP::Request->new();

   $request->method( 'POST' );

   $request->uri( $WWW::Blogger::XML::API::url . "/feeds/${blogid}/posts/default" );

   $request->header( 'Content_Type' => 'application/atom+xml' );

   $request->content( $entry->as_xml() );

   return( $request );

} ## end sub WWW::Blogger::XML::API::post_entry_by_blogid

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
## GET http://www.blogger.com/feeds/blogID/posts/default/postID
##
sub WWW::Blogger::XML::API::get_post_by_blogid_postid
{
   my ( $blogid, $postid ) = @_;

   my $request = HTTP::Request->new();

   $request->method( 'GET' );

   $request->uri( $WWW::Blogger::XML::API::url . "/feeds/${blogid}/posts/default/${postid}" );

   return( $request );

} ## end sub WWW::Blogger::XML::API::get_post_by_blogid_postid

##
## Updating a post entry
##
## PUT http://www.blogger.com/feeds/blogID/posts/default/postID
##
sub WWW::Blogger::XML::API::put_post_by_blogid_postid
{
   my ( $blogid, $postid, $entry ) = @_;

   my $request = HTTP::Request->new();

   $request->method( 'PUT' );

   $request->uri( $WWW::Blogger::XML::API::url . "/feeds/${blogid}/posts/default/${postid}" );

   $request->header( 'Content_Type' => 'application/atom+xml' );

   $request->content( $entry->as_xml() );

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

   my $request = HTTP::Request->new();

   $request->method( 'DELETE' );

   $request->uri( $WWW::Blogger::XML::API::url . "/feeds/${blogid}/posts/default/${postid}" );

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

##
## Creating a comment entry
##
## POST http://www.blogger.com/feeds/blogID/postID/comments/default
##
sub WWW::Blogger::XML::API::comment_entry_by_blogid_postid
{
   my ( $blogid, $postid, $entry ) = @_;

   my $request = HTTP::Request->new();

   $request->method( 'POST' );

   $request->uri( $WWW::Blogger::XML::API::url . "/feeds/${blogid}/${postid}/comments/default" );

   $request->header( 'Content_Type' => 'application/atom+xml' );

   $request->content( $entry->as_xml() );

   return( $request );

} ## end sub WWW::Blogger::XML::API::comment_entry_by_blogid

##
## Retrieving all comments for a blog
##
## GET http://www.blogger.com/feeds/blogID/comments/default
##
sub WWW::Blogger::XML::API::list_of_comments_by_blogid
{
   my $blogid = shift;

   my $request = HTTP::Request->new();

   $request->method( 'GET' );

   $request->uri( $WWW::Blogger::XML::API::url . "/feeds/${blogid}/comments/default" );

   return( $request );

} ## end sub WWW::Blogger::XML::API::list_of_comments_by_blogid

##
## Retrieving comments for a particular post
##
## GET http://www.blogger.com/feeds/blogID/postID/comments/default
##
sub WWW::Blogger::XML::API::list_of_comments_by_blogid_postid
{
   my ( $blogid, $postid ) = @_;

   my $request = HTTP::Request->new();

   $request->method( 'GET' );

   $request->uri( $WWW::Blogger::XML::API::url .  "/feeds/${blogid}/${postid}/comments/default" );

   return( $request );

} ## end sub WWW::Blogger::XML::API::list_of_comments_by_blogid_postid

##
## Removing a stray comment (in the undocumented way)
##
## DELETE http://www.blogger.com/feeds/blogID/comments/default/commentID
##
sub WWW::Blogger::XML::API::remove_comment_by_blogid_commentid
{
   my ( $blogid, $commentid ) = @_;

   my $request = HTTP::Request->new();

   $request->method( 'DELETE' );

   $request->uri( $WWW::Blogger::XML::API::url . "/feeds/${blogid}/comments/default/${commentid}" );

   return( $request );

} ## end sub WWW::Blogger::XML::API::remove_comment_by_blogid_commentid

##
## Removing a comment (in the standard way)
##
## DELETE http://www.blogger.com/feeds/blogID/postID/comments/default/commentID
##
sub WWW::Blogger::XML::API::remove_comment_by_blogid_postid_commentid
{
   my ( $blogid, $postid, $commentid ) = @_;

   my $request = HTTP::Request->new();

   $request->method( 'DELETE' );

   $request->uri( $WWW::Blogger::XML::API::url . "/feeds/${blogid}/${postid}/comments/default/${commentid}" );

   return( $request );

} ## end sub WWW::Blogger::XML::API::remove_comment_by_blogid_postid_commentid

##
## Browsing with categories and keywords
## GET http://www.blogger.com/feeds/blogID/posts/default/-/categories_or_keywords
##
sub WWW::Blogger::XML::API::browse_by_blogid
{
   my ( $blogid, $query ) = @_;

   my $request = HTTP::Request->new();

   $request->method( 'GET' );

   if ( ! ( $query =~ m@^[/]@ ) )
   {
      $query = '/' . $query;

   } ## end if

   $request->uri( $WWW::Blogger::XML::API::url . "/feeds/${blogid}/posts/default/-$query" );

   return( $request );

} ## end sub WWW::Blogger::XML::API::browse_by_blogid

##
## Searching for a blog's posts using query parameters
## GET http://www.blogger.com/feeds/blogID/posts/default?query_parameters
##
sub WWW::Blogger::XML::API::search_by_blogid
{
   my ( $blogid, @query ) = @_;

   my $request = HTTP::Request->new();

   my $uri = URI->new( $WWW::Blogger::XML::API::url . '/feeds/${blogid}/posts/default' );

   $uri->query_form( @query );

   $request->method( 'GET' );

   $request->uri( $uri );

   return( $request );

} ## end sub WWW::Blogger::XML::API::search_by_blogid

1;
__END__ ## package WWW::Blogger::XML::API

=head1 NAME

WWW::Blogger::XML::API - How to Interface with Blogger using HTTP Protocol and GData XML Atom API.

http://code.google.com/apis/blogger/developers_guide_protocol.html

=head1 SYNOPSIS

 use WWW::Blogger;

 my $request = WWW::Blogger::XML::API::list_of_blogs_by_userid( $userid );

 my $result = WWW::Blogger::XML::API::ua_request( $request );

=head1 OPTIONS

=item --xml_ua_dmp

user agent transaction dump

=item --xml_request_dmp

transaction request dump

=item --xml_result_dmp

transaction result dump

=head1 DESCRIPTION

XML::API stands for XML Application Programming Interface

See:	http://code.blogger.com
	http://code.google.com/apis/blogger
	http://code.google.com/apis/blogger/developers_guide_protocol.html


=head2	Demo

=over

WWW::Blogger::XML::demo()

=back

=head2  Retrieving a list of blogs

=over

$request = WWW::Blogger::XML::API::list_of_blogs_by_userid( $userid );

$result = WWW::Blogger::XML::API::ua_request( $request );

See Example: WWW::Blogger::XML::parse_list_of_blogs( $result )

=back

=head2	Creating posts

1. Publishing a blog post

=over

$request = WWW::Blogger::XML::test_post_by_blogid( $blogid ) ## a Test Post

-OR-

$request = WWW::Blogger::XML::API::post_entry_by_blogid( $blogid, $entry );

$result = WWW::Blogger::XML::API::ua_request( $request );

Follow the "Test Post" example to create your XML::Atom::Syndication::Entry.

See Example: WWW::Blogger::XML::parse_test_post_entry( $result );

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

$request = WWW::Blogger::XML::API::browse_by_blogid( $blogid, '/Comedy/-dark' );

-OR-

$request = WWW::Blogger::XML::API::search_by_blogid( $blogid, 'start-index' => 1, 'max-results' => 10 );

$result = WWW::Blogger::XML::API::ua_request( $request );

See: http://code.google.com/apis/blogger/developers_guide_protocol.html#RetrievingWithQuery

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

$request = WWW::Blogger::XML::test_comment_by_blogid_postid( $blogid, $postid );

-OR-

$request = WWW::Blogger::XML::API::comment_entry_by_blogid_postid( $blogid, $postid, $entry );

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

I<L<WWW::Blogger>> I<L<WWW::Blogger::ML::API>> I<L<WWW::Blogger::XML>>

=head1 AUTHOR

 Copyright (C) 2008 Eric R. Meyers E<lt>Eric.R.Meyers@gmail.comE<gt>

=cut

