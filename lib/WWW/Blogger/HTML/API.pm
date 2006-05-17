#!/usr/bin/perl -w
##

package WWW::Blogger::HTML::API;

use strict;

use warnings;

require WWW::Blogger::ML::API;

$WWW::Blogger::HTML::API::url = 'http://www.blogger.com';

$WWW::Blogger::HTML::API::ua = LWP::UserAgent->new();

$WWW::Blogger::HTML::API::ua->cookie_jar( HTTP::Cookies->new( 'file' => "lwpcookies_$ENV{'USER'}.txt",
                                                              'autosave' => 1
                                                            )
                                        );

END {

} ## end END

1;
__END__

