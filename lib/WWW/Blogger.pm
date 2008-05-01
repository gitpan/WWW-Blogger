##
## WWW::Blogger
##
package WWW::Blogger;

use strict;

use warnings;

use 5.005;

require Date::Format;

#program version
#my $VERSION="0.1";

#For CVS , use following line
our $VERSION = sprintf("%d.%04d", "Revision: 2008.0501" =~ /(\d+)\.(\d+)/);

BEGIN {

   require Exporter;

   @WWW::Blogger::ISA = qw(Exporter);

   @WWW::Blogger::EXPORT = qw(); ## export required

   @WWW::Blogger::EXPORT_OK =
   (

   ); ## export ok on request

} ## end BEGIN

require WWW::Blogger::ML;

require File::Basename;

%WWW::Blogger::opts =
(
); ## General Public

__PACKAGE__ =~ m/^(WWW::[^:]+)((::([^:]+))(::([^:]+))){0,1}$/g;

##debug##print( "BL! $1::$4::$6\n" );

%WWW::Blogger::opts_type_args =
(
   'ido'            => $1,
   'iknow'          => 'bl',
   'iman'           => 'aggregate',
   'myp'            => __PACKAGE__,
   'opts'           => \%WWW::Blogger::opts,
   'opts_filename'  => {},
   'export_ok'      => [],
   'urls'           =>
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
     __PACKAGE__ ne join( '::', $WWW::Blogger::opts_type_args{'ido'},
                                #$WWW::Blogger::ML::opts_type_args{'iknow'},
                                #$WWW::Blogger::ML::opts_type_args{'iman'}
                        )
                      );

WWW::Blogger::ML::API::create_opts_types( \%WWW::Blogger::opts_type_args );

##debug## WWW::Blogger::ML::API::show_all_opts( \%WWW::Blogger::opts_type_args );

WWW::Blogger::register_all_opts( \%WWW::Blogger::ML::opts_type_args );

#push( @WWW::Blogger::EXPORT_OK,
#      @{$WWW::Blogger::opts_type_args{'export_ok'}} );

END {

} ## end END

##
## WWW::Blogger::register_all_opts
##
sub WWW::Blogger::register_all_opts
{
   my $opts_type_args = shift || \%WWW::Blogger::ML::opts_type_args;

   while ( my ( $opt_tag, $opt_val ) = each( %{$opts_type_args->{'opts'}} ) )
   {
      $WWW::Blogger::opts_type_args{'opts'}{$opt_tag} = $opt_val;

   } ## end while

   while ( my ( $opt_tag, $opt_val ) = each( %{$opts_type_args->{'urls'}} ) )
   {
      $WWW::Blogger::opts_type_args{'urls'}{$opt_tag} = $opts_type_args->{'urls'}{$opt_tag};

   } ## end while

} ## end sub WWW::Blogger::register_all_opts

##
## WWW::Blogger::ML::show_all_opts
##
sub WWW::Blogger::show_all_opts
{
   my $opts_type_args = shift || \%WWW::Blogger::opts_type_args;

   WWW::Blogger::ML::show_all_opts( $opts_type_args );

} ## end sub WWW::Blogger::XML::show_all_opts

1;
__END__ ## package WWW::Blogger

=head1 NAME

B<WWW::Blogger> - Blogger Development Interface (BDI)

=head1 SYNOPSIS

B<use lib ( $ENV{'HOME'} );>

B<use WWW::Blogger::Com;> ## SEE DESCRIPTION

 Options;

   --bl_*

=head1 OPTIONS

--bl_*

=head1 DESCRIPTION

B<WWW::Blogger> is the I<Public> I<Blogger Development Interface> (BDI).

B<L<WWW::Blogger::Com>> is your I<Private> Blogger Developer's Interface.

We need your private B<user and pass> defined here.

=head1 SEE ALSO

I<L<WWW::Blogger::Com>> I<L<WWW::Blogger::ML>> I<L<WWW::Blogger::XML>> I<L<WWW::Blogger::HTML>>

=head1 AUTHOR

 Copyright (C) 2008 Eric R. Meyers E<lt>Eric.R.Meyers@gmail.comE<gt>

=head1 LICENSE

perl

=cut

