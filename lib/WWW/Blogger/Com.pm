##
## WWW::Blogger::Com
##
package WWW::Blogger::Com;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION=sprintf("%d.%04d", q$Revision: 2008.0407 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::Blogger::Com::ISA = qw(Exporter);

   @WWW::Blogger::Com::EXPORT = qw(); ## export required

   @WWW::Blogger::Com::EXPORT_OK = qw(); ## export ok on request

} ## end BEGIN

$WWW::Blogger::Com::user = <?php print "'$argv[1]'";?>; ## Blogger username

$WWW::Blogger::Com::pass = <?php print "'$argv[2]'";?>; ## Blogger password

END {

} ## end END

1;
__END__

=head1 NAME

WWW::Blogger::Com - Complete the setup of WWW::Blogger with needed personal parameters

=head1 SYNOPSIS

-- Now about your future Blogger Development Interface projects:

$ mkdir ~/WWW

$ mkdir ~/WWW/Blogger

/usr/bin/php $PERLLIB/WWW/Blogger/Com.pm B<user pass> > ~/WWW/Blogger/Com.pm

-- NOTE: php ...

 Options;

   B<user pass>

=head1 OPTIONS

 B<user pass>

=head1 DESCRIPTION

B<WWW::Blogger::Com> is your private package of secrets for B<WWW::Blogger> to function.

This perl package is for your secrets to be kept at home (but used) by B<WWW::Blogger> applications.

=head1 SEE ALSO

I<L<WWW::Blogger>>

=head1 AUTHOR

 Copyright (C) 2008 Eric R. Meyers E<lt>Eric.R.Meyers@gmail.comE<gt>

=cut
