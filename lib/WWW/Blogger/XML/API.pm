#!/usr/bin/perl -w
##

package WWW::Blogger::XML::API;

require WWW::Blogger::ML::API;

$WWW::Blogger::XML::API::uri = 'https://www.blogger.com/atom';

##
## Use HTTPS! AtomAPIdoc=http://code.blogger.com/archives/atom-docs.html
##

##
## WWW::Blogger::XML::API::demo
##
sub WWW::Blogger::XML::API::demo
{
   my $todo = undef;

   my $result = undef;

   my $request = HTTP::Request->new( 'GET' => $WWW::Blogger::XML::API::uri );

   $request->authorization_basic( 'ermeyers', 'delete delete' ); ## $WWW::MyBlogger::ML::user, $WWW::MyBlogger::ML::pass );

   ##
   $todo = 'users.blogs';
   ##
   ## GET /atom HTTP/1.1
   ## Host: www.blogger.com
   ## Authorization: BASIC base64(user:pass)
   ##
   ## You'll get one service.feed and one service.post for each blog of which you're a member.
   ## service.feed is the URI where you would make an Atom API request to see the Blog's latest entries.
   ## service.post is the URI where you would send an Entry to post to your blog.
   ##
   printf( "##\n## %s\n##\n", $todo );

   $request->method( 'GET' );

   $request->uri( $WWW::Blogger::XML::API::uri );

   $result = WWW::Blogger::XML::API::ua_request( $request );

   ##
   $todo = "users.recent_posts";
   ##
   ## GET /atom/3187374 HTTP/1.1
   ## Host: www.blogger.com
   ## Authorization: BASIC base64(user:pass)
   ##
   ## This will return an Atom feed containing the last 15 posts.
   ##

   foreach $blog ( sort keys %WWW::MyBlogger::blog )
   {
      printf( "##\n## %s %s\n##\n", $todo, $blog );

      $request->method( 'GET' );

      $request->uri( $WWW::Blogger::XML::API::uri .'/'. $WWW::MyBlogger::blog{$blog} );

      $result = WWW::Blogger::XML::API::ua_request( $request );

   } ## end foreach

   ##
   $todo = "To see a specific Post:";
   ##
   ## GET /atom/3187374/1123937362671 HTTP/1.1
   ## Host: www.blogger.com
   ## Authorization: BASIC base64(user:pass)
   ##
   ## This will return a single Atom entry, outside of a feed.
   ##

=cut
   printf( "##\n## %s\n##\n", $todo );

   $request->method( 'GET' );

   $request->uri( $MyBlogger::atom_uri );

   $result = WWW::Blogger::XML::API::ua_request( $request );
=cut

   ##
   $todo = "To create a new entry:";
   ##
   ## POST /atom/3187374 HTTP/1.1
   ## Content-type: application/xml
   ## Host: www.blogger.com
   ## Authorization: BASIC base64(user:pass)
   ##
   ## <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
   ## <entry xmlns="http://purl.org/atom/ns#">
   ##   <title mode="escaped" type="text/plain">atom test</title>
   ##   <issued>2004-04-12T06:07:20Z</issued>
   ##   <generator url="http://www.yoursitesurlhere.com">Your client's name here.</generator>
   ##   <content type="application/xhtml+xml">
   ##     <div xmlns="http://www.w3.org/1999/xhtml">Testing the Atom API</div>
   ##   </content>
   ## </entry>
   ##

=cut
   printf( "##\n## %s\n##\n", $todo );

   $request->method( 'GET' );

   $request->uri( $MyBlogger::atom_uri );

   $result = WWW::Blogger::XML::API::ua_request( $request );
=cut

   ##
   $todo = "To save a post as Draft:";
   ##
   ## To use drafts in Blogger, we created a new namespace with an optional element called draft.i
   ## The only valid children of draft are true or false.
   ## If draft is left out of a newly created post, it is assumed to be live.
   ## If draft is left out of an edited post, the post's draft status will not change.
   ## Here is the syntax:
   ## <draft xmlns="http://purl.org/atom-blog/ns#">false</draft>

=cut
   printf( "##\n## %s\n##\n", $todo );

   $request->method( 'GET' );

   $request->uri( $MyBlogger::atom_uri );

   $result = WWW::Blogger::XML::API::ua_request( $request );
=cut

   ##
   $todo = "To edit an existing entry:";
   ##
   ## PUT /atom/3187374/112393873673 HTTP/1.1
   ## Content-type: application/xml
   ## Host: www.blogger.com
   ## Authorization: BASIC base64(user:pass)
   ##
   ## <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
   ## <entry xmlns="http://purl.org/atom/ns#">
   ##   <title mode="escaped" type="text/html">atom test</title>
   ##   <issued>2004-04-12T06:07:20Z</issued>
   ##   <generator url="http://www.yoursitesurlhere.com">Your client's name here.</generator>
   ##   <content type="application/xhtml+xml" xml:lang="en-US" xml:space="preserve">
   ##     <div xmlns="http://www.w3.org/1999/xhtml"><em>Update:</em> Testing the Atom API</div>
   ##   </content>
   ## </entry>
   ##

=cut
   printf( "##\n## %s\n##\n", $todo );

   $request->method( 'GET' );

   $request->uri( $MyBlogger::atom_uri );

   $result = WWW::Blogger::XML::API::ua_request( $request );
=cut

   ##
   $todo = "To delete a Post:";
   ##
   ## DELETE /atom/3187374/112983287376436 HTTP/1.1
   ## Host: www.blogger.com
   ## Authorization: BASIC base64(user:pass)
   ##
   ## If your delete was successful, you should receive:
   ##
   ## HTTP/1.1 204 No Content 
   ##

=cut
   printf( "##\n## %s\n##\n", $todo );

   $request->method( 'GET' );

   $request->uri( $MyBlogger::atom_uri );

   $result = WWW::Blogger::XML::API::ua_request( $request );
=cut

   ##
   $todo = "Blogger Extensions:";
   ##
   ## <convertLineBreaks> — Line Break Status.
   ## This flag, when set to true, means that a blog's posts will have their newlines automatically
   ## converted to <br />. If set to false, newlines will not be transformed.
   ## This flag is read-only and can only be changed through the Blogger web interface for now.
   ## You can see a blog's Line Break Status by sending a GET to it's service.feed URI and looking for
   ## it as a child of the <feed> element:
   ## <convertLineBreaks xmlns="http://www.blogger.com/atom/ns#">true</convertLineBreaks>
   ##

=cut
   printf( "##\n## %s\n##\n", $todo );

   $request->method( 'GET' );

   $request->uri( $MyBlogger::atom_uri );

   $result = WWW::Blogger::XML::API::ua_request( $request );
=cut

   ##
   $todo = "Failures:";
   ##
   ## If unable to authenticate your request, the server will respond with:
   ##
   ## HTTP/1.1 401 Unauthorized
   ## WWW-Authenticate: BASIC realm="Blogger"
   ##
   ## Your username/password is invalid.
   ##

=cut
   printf( "##\n## %s\n##\n", $todo );

   $request->method( 'GET' );

   $request->uri( $MyBlogger::atom_uri );

   $result = WWW::Blogger::XML::API::ua_request( $request );
=cut

} ## end sub WWW::Blogger::XML::API::demo

##
## WWW::Blogger::XML::API::ua_request
##
sub WWW::Blogger::XML::API::ua_request
{
   my $request = shift;

   my $result = $WWW::Blogger::HTML::API::ua->request( $request );

   printf( "REQUEST:\n%s\n", $request->as_string() );

   if ( $result->is_success() )
   {
      printf( "RESULT:\n%s\n", $result->as_string() );

   }
   else
   {
      printf( "Failed: %s\n", $result->status_line() );

   } ## end if

   return ( $result );

} ## end sub WWW::Blogger::XML::API::ua_request

END {

} ## end END

1;
__END__

