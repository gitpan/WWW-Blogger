#!/usr/bin/perl -w
##

use strict;

use warnings;

#program version
##my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2008.1017 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   ##debug## push( @ARGV, '--xml_ua_dmp' );
   ##debug## push( @ARGV, '--xml_request_dmp' );
   ##debug## push( @ARGV, '--xml_result_dmp' );

} ## end BEGIN

use lib ( "$ENV{'HOME'}" );

use WWW::Blogger;

use Getopt::Long;

use Pod::Usage;

my $man = 0;
my $help = 0;

##debug##%WWW::Blogger::opts = %WWW::Blogger::opts; ## dummy

my %opts =
(
   'man' => \$man,
   'help|?' => \$help,
   %WWW::Blogger::opts,

);

##debug##WWW::Blogger::show_all_opts(); exit;

GetOptions( %opts ) || pod2usage( 2 );

pod2usage( 1 ) if ( $help );

pod2usage( '-exitstatus' => 0, '-verbose' => 2 ) if ( $man );

##debug## WWW::Blogger::show_all_opts();
##debug## WWW::Blogger::ML::show_all_opts();
##debug## WWW::Blogger::ML::API::show_all_opts();
##debug## WWW::Blogger::XML::show_all_opts();
##debug## WWW::Blogger::XML::API::show_all_opts();
##debug## WWW::Blogger::HTML::show_all_opts();
##debug## WWW::Blogger::HTML::API::show_all_opts();

WWW::Blogger::XML::demo();

END {

} ## end END

__END__

=head1 NAME

B<blogger/demo/demo.plx> - Blogger Developers Interface, XML API demo.

=head1 SYNOPSIS

=over

=item It's time for you to see the Blogger Developer API's page: L<http://code.google.com/apis/blogger>

B<$ mkdir> ~/blogger

B<$ mkdir> ~/blogger/demo

=item Options;

--help|? brief help message

--man full documentation

=back

=head1 OPTIONS

=over

=item B<--help|?>

Print a brief help message and exits.

=item B<--man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

Blogger XML API demo for initial testing, training and your own WWW::Blogger Development Environment setup purpose.

=head1 SEE ALSO

I<L<WWW::Blogger>> I<L<WWW::Blogger::ML>> I<L<WWW::Blogger::XML>>

=head1 AUTHOR

 Copyright (C) 2006 Eric R. Meyers E<lt>ermeyers@adelphia.netE<gt>

=cut
