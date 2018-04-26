#########################################################################
## cgi_init.pl
## Author: Colin Allen, edited by Ryan  Villalpando
##
## This file contains the initializtions for the cgi objects .
## Specifications are made for the logic and logic development sites.
##
## Note: if this file is required multiple times, it may overwrite the
## cgi object
##
#########################################################################

#########################################################################
# requires
# This require is necessary! It contains directives needed for the cgi
#########################################################################
require "/home/clic/bin/common_init.pl";



##########################################################################
# packages
##########################################################################
use CGI qw(:all);
use Mail::Sendmail;

##########################################################################
# globals used in a CGI context
##########################################################################
$INCGI = 1 if defined $ENV{'HTTP_HOST'};


##########################################################################
# cgi bin directory
##########################################################################
$CGIBIN = "$HTTPDDIR/cgi-bin";


##########################################################################
# common files required for QM and Logic
##########################################################################
require "$CGIBIN/logic_qm_common_subrs.pl";


##########################################################################
# CGI specifics
##########################################################################
$FQDN = $ENV{'HTTP_HOST'};
$e_ra = $ENV{'HTTP_PC_REMOTE_ADDR'} || $ENV{'REMOTE_ADDR'} || "?.?.?.?";
$e_rh = $ENV{'REMOTE_HOST'} || "Unknown";
$e_ref = $ENV{'HTTP_REFERER'};  # this is only around if you are using Apache

## initialize CGI object
$cgi = new CGI;


if ($cgi->url =~ /quizmaster|qm/) {
    $QM = $cgi;
    require "$CLICBIN/db_seq_rank.pl";
    require "$CGIBIN/qmlib.pl";
    require "$CGIBIN/qmproof.pl";
    require "$CGIBIN/qmmodel.pl";
} elsif ($cgi->url =~ /countermodel/) {
    require "$CGIBIN/qmmodel.pl";
} else {
    $stuff = $cgi;
    require "$CLICBIN/find_redundanciesinproof.pl";
}

#set the SID cookie 

$id = cookie('ID');                            # get the SID from the cookie

if (not defined $id) {                         # if no cookie, give new SID
    $id= time. $e_ra;
}

$sidcookie = cookie(-name => 'ID',                  # update SID cookie
		    -value =>  $id,
		    -expires => '+20m' );


1; # required by require
