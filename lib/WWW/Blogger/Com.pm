##
## WWW::Blogger::Com
##
package WWW::Blogger::Com;

use strict;

use warnings;

#program version
#my $VERSION="0.1";

#For CVS , use following line
my $VERSION=sprintf("%d.%02d", q$Revision: 1.2 $ =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::Blogger::Com::ISA = qw(Exporter);

   @WWW::Blogger::Com::EXPORT = qw(); ## export required

   @WWW::Blogger::Com::EXPORT_OK = qw(user pass dev_id); ## export ok on request

} ## end BEGIN

require WWW::Blogger;

$WWW::Blogger::Com::user = ''; ## Blogger username

$WWW::Blogger::Com::pass = ''; ## Blogger password

END {

} ## end END

1;
__END__

=head1 NAME

WWW::Blogger::Com - (plete) setup of WWW::Blogger with needed personal parameters

=head1 SYNOPSIS

 how to use your program
 program [options]

WWW::Blogger::Com is your private package of secrets for WWW::Blogger to function.
This perl package is for your secrets to be kept (but used) by WWW::Blogger.

 Options;
# --help brief help message
# --man full documentation
=head1 OPTIONS

#=over 8
#
#=item B<--help>
#
#Print a brief help message and exits.
#
#=item B<--man>
#
#Prints the manual page and exits.
#
#=back

=head1 DESCRIPTION

 long description of your program

=head1 SEE ALSO

 need to know things before somebody uses your program

=head1 AUTHOR

 Copyright (C) 2006 Eric R. Meyers <ermeyers@adelphia.net>

=cut
