#!/usr/bin/perl
# this is equivalency-wrapper.pl
# it is expected to reside in cgi-bin

require "cgi_init.pl"; # must be in same direcrtor

$thumbup = "http://$FQDN/Images/th_up.gif";
$thumbdown = "http://$FQDN/Images/th_dnx.gif";

$cgi->import_names('CGI');

$SELF = $cgi->self_url;
$SELF=~s/\?.*?$//;

$input1 = $ARGV[0]
$input2 = $ARGV[1]

if ($CGI::formula1) {
    # check it for wffiness
    $formula1 = &reparen($input1);
    $result1 = &wff($formula1);
    if (!$result1){
    	$message = "The first formula is not well-formed. ";
    }
}
if ($CGI::formula2) {
    # check it for wffiness
    $formula2 = &reparen($input2);
    $result2 = &wff($formula2);
    if (!$result2){
			$message = $message."The second formula is not well-formed. ";
		}
}

if ($result1 && $result2) {
    $result = &is_valid("|-($formula1<->$formula2)");
    if ($result eq "valid") {$message = "The two formulas are logically equivalent."}
    elsif ($result =~ /identity/) {$message = "The equivalence of these formulas involving identity could not be ascertained."}
    else {$message = "The two formulas are <strong>not</strong> logically equivalent."}

 }
else {
	if ($formula1 || $formula2){ # don't want this message on initial screen
		$message = $message."<br>Please enter two well-formed formulas.";
	}
}

print STDOUT $message