#!/usr/bin/perl

#The main quizmaster program

#require "cgi_init.pl";
require "/home/ec2-user/environment/CSCE-431-Logic-Daemon-Project/app/cgi-bin/cgi_init.pl"; # must be in same directory

### MAIN routine
# set up some easy handles

$program = $cgi->url;   # QM is a CGI object defined in qmlib.pl

my $expires = '+20m';  # figure out proper expiry time
$expires = '+20m'
    if (($program =~ /quizmaster/) and ($dothis =~ /Generate/));


&start_qmpage # in qmlib.pl - prints the generic header for the webpage
    unless $dothis =~ /Check|Help/ and $CGI::qtype =~ /^(PR|IP)$/;  # have to handle proofs differently

for ($dothis) {
    /Begin/                     and do { &get_quiz_topic,last;};
    /Start|Menu/                and do { &get_quiz_topic,last;};
    /Generate|Select|Sort|Go/   and do { &generate_quiz,last;};
    /Take/                      and do { &generate_user_req_ques,last;};
    /Check|Help/                and do { &check_answers,last;};
    &get_started;     #default
} # end for action

&bye_bye;             #in qmlib.pl

#########################################################################
sub get_started {
# input: nothing
# returns: nothing
# displays start-up form and prompts user for name
    print 
	$cgi->start_form( -action=>$program ),
	p(strong("Hello!  Please identify yourself here by entering a nickname: "),
	    $cgi->hidden(-name=>'action', -value=>'Begin'),
	    "<br>",
	    $cgi->textfield( -name=>'user', -value=>$CGI::user, -size=>20 ), 
	    $cgi->submit( -name=>'void', -value=>'Begin'),
	    ),
	p("You may choose to remain anonymous if you prefer.");
    print end_form;
} #end get_started subroutine

#########################################################################

sub get_quiz_topic {
# input: nothing
# returns: nothing
# displays list of Exercises and prompts user for choice of topic

    %quiz_labels1 = ('Ex1.1'
		          => 'Ex. 1.1 Validity and Soundness',
		          'Ex1.2.1'
		          => 'Ex. 1.2.1: Sentential Wffs (prev. 1.1)',
		          'Ex1.2.2'
		          => 'Ex. 1.2.2: Dropping Parentheses (prev. 1.2a)',
		          'Ex1.2.3'
		          => 'Ex. 1.2.3: Reading Missing Parentheses (prev. 1.2b)',
		          'Ex1.3'
		          => 'Ex. 1.3: Sentential Translations',
		          'Ex1.4.1'
		          => 'Ex. 1.4.1: Completing Proofs (prev. 1.4)',
		          'Ex1.4.2'
		          => 'Ex. 1.4.2: Simple Proofs',
		          'Ex1.5.1a'
		          => 'Ex. 1.5.1: Basic Conditional and Reductio Proofs',
		          'Ex1.5.1b'
		          => 'Ex. 1.5.1: Proofs of Disjunctions',
		          'Ex1.5.2'
		          => 'Ex. 1.5.2: S40 through S63 Proofs',
		          'Ex1.5.4'
		          => 'Ex. 1.5.4: More proofs',
		          'Ex1.5.random'
		          => 'Ex. 1.5: Random Proof!',
		          'Ex1.6.1'
		          => 'Ex. 1.6.1: Prove Theorems',
		     );

    %quiz_labels2 = ('Ex2.2'
		          => 'Ex. 2.2: Invalidating Assignments',
		          'Ex2.4.2'
		          => 'Ex. 2.4.2: Indirect TT Method (prev. 2.4b)',
		          'Ex2.5.2'
		          => 'Ex. 2.5.2: More Sequents for ITT Method (prev 2.6)',
		          'Supp.Ch2'
		          => 'Supplemental T/F Quiz on Semantics',
		     );
    
    %quiz_labels3 = ('Ex3.1.1'
		          => 'Ex. 3.1.1: Wffs of Predicate Logic (prev. 3.1)',
		          'Ex3.2a'
		          => 'Ex 3.2s: Simple Translations (supplemental ex.)',
		          'Ex3.2b'
		          => 'Ex. 3.2: Single-place Predicate Translations (prev. 3.5)',
		          'Ex3.2c'
		          => 'Ex. 3.2: Multi-place Predicate Translations (prev. 3.5)',
		          'Ex3.3.2'
		          => 'Ex. 3.3.2: Predicate Logic Proofs (prev. 3.6)',
		          'Ex3.4.1'
		          => 'Ex. 3.4.1: More Sequents (prev. 3.7)',
		          'Ex3.4.2'
		          => 'Ex 3.4.2: Theorems (prev. 3.8)',
		     );

    %quiz_labels4 = (
		          'Ex4.1.1'
		          => 'Ex 4.1.1: Quantifier Expansions w/ Single-place Preds',
		          'Ex4.1.1s'
		          => 'Ex 4.1.1s: Expansions w/ Multi-place Preds (suppl. ex.)',
		          'Ex4.2'
		          => 'Ex 4.2: Countermodels w/ Single-place Predicates',
		          'Ex4.3.1'
		          => 'Ex 4.3.1: Countermodels w/ Multi-place Preds',
		     );
    
    @values1 = sort (keys %quiz_labels1);
    @values2 = sort (keys %quiz_labels2);
    @values3 = sort (keys %quiz_labels3);
    @values4 = sort (keys %quiz_labels4);

    
    print
	$cgi->table({-border=>0,-cellpadding=>3,-cellspacing=>0},
		    Tr(th({-bgcolor=>$MENUBAR_COLOR,-colspan=>2,-align=>'center'},
			  "<font color=$MENUTITLE_COLOR>",
			  "----- SENTENTIAL LOGIC -----",
			  "</font>",
			  )),
		    Tr(th({-bgcolor=>$MENUBAR_COLOR},
			  "<font color=$MENUTITLE_COLOR>",
			  strong("CHOOSE FROM CHAPTER ONE"),
			  "</font>"),
		       th({-bgcolor=>$MENUBAR_COLOR},
			  "<font color=$MENUTITLE_COLOR>",
			  strong("OR CHOOSE FROM CHAPTER TWO"),
			  "</font>")),
		    Tr(td({-align=>'center',-bgcolor=>$MENUBG_COLOR},
			  $cgi->start_form( -action=>$program ),
			  $cgi->hidden( -name=>'user', -value=>$CGI::user),
			  $cgi->popup_menu(-name=>'quiz',             # 
					   -values=>\@values1,        # list values
					   -labels=>\%quiz_labels1,   # labels array
					   -default=>0,
					   -size=>7),
			  '<br/>',
			  $cgi->hidden(-name => 'level',
				       -default=>1,
				       -force=>1),
			  $cgi->radio_group(-name => 'user_selection',
					    -values => ['Random', 'User Preference'],
					    -default => 'Random',
					    ),
			  '<br />',
			  $cgi->hidden( -name=>'score',  -default=>0, -force=>1 ),
			  $cgi->hidden( -name=>'qsofar', -default=>0, -force=>1 ),
			  $cgi->hidden( -name=>'attempt',-default=>0, -force=>1 ),
			  $cgi->submit( -name=>'action', -value=>'Generate quiz'),
			  $cgi->end_form),
		       
		       td({-align=>'center',-bgcolor=>$MENUBG_COLOR},
			  $cgi->start_form( -action=>$program ),
			  $cgi->hidden( -name=>'user', -value=>$CGI::user),
			  
			  $cgi->popup_menu(-name=>'quiz',             # 
					   -values=>\@values2,        # list values
					   -labels=>\%quiz_labels2,   # labels array
					   -default=>-1,
					   -size=>7),
			  '<br/>',
			  $cgi->hidden(-name => 'level',
				       -default=>1,
				       -force=>1),
			  $cgi->radio_group(-name => 'user_selection',
					    -values => ['Random', 'User Preference'],
					    -default => 'Random',
					    ),
			  '<br />',
			  $cgi->hidden( -name=>'score',  -default=>0, -force=>1 ),
			  $cgi->hidden( -name=>'qsofar', -default=>0, -force=>1 ),
			  $cgi->hidden( -name=>'attempt',-default=>0, -force=>1 ),
			  $cgi->submit( -name=>'action', -value=>'Generate quiz'),
			  $cgi->end_form),
		       
		       ),
		    Tr(th({-bgcolor=>$MENUBAR_COLOR,-colspan=>2,-align=>'center'},
			  "<font color=$MENUTITLE_COLOR>",
			  "----- PREDICATE LOGIC -----",
			  "</font>",
			  )),
		    Tr(th({-bgcolor=>$MENUBAR_COLOR},
			  "<font color=$MENUTITLE_COLOR>",
			  strong("CHOOSE FROM CHAPTER THREE"),
			  "</font>"),
		       th({-bgcolor=>$MENUBAR_COLOR},
			  "<font color=$MENUTITLE_COLOR>",
			  strong("OR CHOOSE FROM CHAPTER FOUR"))),
		    Tr(td({-align=>'center',-bgcolor=>$MENUBG_COLOR},
			  $cgi->start_form( -action=>$program ),
			  $cgi->hidden( -name=>'user', -value=>$CGI::user),
			  
			  $cgi->popup_menu(-name=>'quiz',             # 
					   -values=>\@values3,        # list values
					   -labels=>\%quiz_labels3,   # labels array
					   -default=>-1,
					   -size=>7),
			  '<br/>',
			  $cgi->hidden(-name => 'level',
				       -default=>1,
				       -force=>1),
			  
			  $cgi->radio_group(-name => 'user_selection',
					    -values => ['Random', 'User Preference'],
					    -default => 'Random',
					    ),
			  
			  '<br />',
			  $cgi->hidden( -name=>'score',  -default=>0, -force=>1 ),
			  $cgi->hidden( -name=>'qsofar', -default=>0, -force=>1 ),
			  $cgi->hidden( -name=>'attempt',-default=>0, -force=>1 ),
			  $cgi->submit( -name=>'action', -value=>'Generate quiz'),
			  $cgi->end_form),
		       
		       td({-align=>'center',-bgcolor=>$MENUBG_COLOR},
			  $cgi->start_form( -action=>$program ),
			  $cgi->hidden( -name=>'user', -value=>$CGI::user),
			  
			  $cgi->popup_menu(-name=>'quiz',             #
					   -values=>\@values4,        # list values
					   -labels=>\%quiz_labels4,   # labels array
					   -default=>-1,
					   -size=>7),
			  '<br/>',
			  $cgi->hidden(-name => 'level',
				       -default=>1,
				       -force=>1),
			  
			  $cgi->radio_group(-name => 'user_selection',
					    -values => ['Random', 'User Preference'],
					    -default => 'Random',
					    ),
			  '<br/>',
			  $cgi->hidden( -name=>'score',  -default=>0, -force=>1 ),
			  $cgi->hidden( -name=>'qsofar', -default=>0, -force=>1 ),
			  $cgi->hidden( -name=>'attempt',-default=>0, -force=>1 ),
			  $cgi->submit( -name=>'action', -value=>'Generate quiz'),
			  $cgi->end_form),
		       
		       )); # end table
    
} # end get_quiz_topic subroutine

######################################################################## 

sub generate_quiz {
# input: nothing
# returns: nothing
# subroutine to pick random selection of questions from a problem file and (with the help of (answer_form) generate an appropriate quiz
    
    my ($preamble,@questions) =  &get_questions($CGI::diff_level);

    $rlqz ="";   ##realquiz variable holds question
    
    @prev_chosen = @CGI::prevchosen;   # find out what nums have already been used
    
    my %attempted_ones = @CGI::ques_ans if @CGI::ques_ans;
    
    $numqs=1 if ($CGI::qtype eq "PR"       #proof
		 || $CGI::qtype eq "IP"    #incomplete proof
		 || $CGI::qtype eq 'Exp'   #expansion
		 || $CGI::qtype eq 'CM');  #countermodel
    
    if ($CGI::user_selection =~ /Pref/){  ######### Generate Preference Problems
        my $j=0;
	$preamble =~ s/\#!preamble//g;        #instructions in quizfile
	my $s = "s";
	$s = "" if $numqs == 1;

        print h3("Select the question$s you wish to work on from the list below, ",
		 "then use the 'Take quiz' button following the list.");

	print h4("This type of question only supports you working on one problem at a time.",
		 "If you click multiple boxes, only the first will be recognized.")
	    if $numqs==1;

	print h4(em("Specific instructions accompanying this exercise"),": ", "$preamble");

	print
	    $cgi->start_form( -action => $program),
	    "<table border =0 cellspacing=\"2\">";

	print 
	    "<tr>",
	    "<th valign=\"top\">",
	    "Attempt",
	    "</th>",
	    "<th valign=\"top\">",
	    "Problem",
	    "</th>";

# following lines commented out by CA on 12-16-17 until database is fixed
	#print "<th  valign=\"top\"> Success Rate <br> (proofs previously submitted)</th>" if $CGI::qtype eq "PR";
	
	if($CGI::qtype eq "PR"){
#	    print "<th  valign=\"top\"> Success Rate<br>(proofs previously submitted)<br>";
#	    print $cgi->submit('action','Sort'),
#	    $cgi->popup_menu(-name=>'ranksort',
#			     -values=>['ASC','DESC'],
#			     -default=>'DESC'),   
#	    "</th>";   
#	    print "<th  valign=\"top\">Additional Assumptions<br>(reqd/not-reqd)<br>Show ";
#	    print $cgi->popup_menu(-name=>'assump',
#				   -values=>['reqd','not-reqd','all'],
#				   -default=>'all'),   
#	    $cgi->submit('action','Go'),
#	    "</th>";   

	    print "</tr>";
	    
	    
	    my $t = 0;
	    for (@questions){
		my($foo1,$foo2,$foo3,$numb,$foo) = split($sep,$_,5);
		if ($numb) { # then we have a database id referring to sequent
		    # database not working not sure why - CA 2017-12-12
		    push @numbers,$numb;
		} else {
		    push @numbers,$t;    
		    ++$t;
		}    
	    }
	}else{
	    my $t = 0;
	    for(@questions){
		push @numbers, $t;  ### here @numbers store the array index values generated
		++$t;
	    }
	}
	
	for (my $k = 0; $k<= $#numbers  ; $k++){
	    $j++;
	    if($CGI::qtype eq "PR"){
		($ques,$err,$ans,$prob_number,$perc,$nonprem,$vcount)=split($sep,$questions[$k],7);
		$perc = 100*$perc;
	    }else{
		($ques,$err,$ans)=split($sep,$questions[$k],3);
	    }

	    $qnum = $j;
	    my $match = 0;

	    print "<tr>";

	    foreach my $question (@prev_chosen){

		my $qnumber = $numbers[$k];
		$qnumber = $numbers[$k] + 1; 
		# if ($CGI::qtype ne "PR"); -- database not working, commented by CA 12-16-17
                if ($question == $qnumber){
                    print "<td bgcolor=#FAEBD7>";
                        $match = 1;
                }
            }

	    print "<td bgcolor=ivory>" if !$match;

	    if ($match){
		print "<font color = maroon><strong> &nbsp; Attempted</strong></font>";

		if (
		    $attempted_ones{$k+1}==1
		    # below not working 12-16-17 due to database problem
		    # ($CGI::qtype eq "PR" and $attempted_ones{$numbers[$k]}==1)
		    #  or 
		    #$($CGI::qtype ne "PR" and $
		    ){
		    print " [<img src = $correct>]";
		} else {
		    print " [<img src = $wrong>]";
		}
	    } else {
		print "&nbsp; Not attempted";
	    }
	    print "</td>";

	    print "<td>";

	    my $qnumber = $qnum;
	    #$qnumber = $prob_number if $CGI::qtype eq "PR";
            print $cgi->checkbox(-name => 'qnum',
                                 -value => $qnumber,
				  -label => $qnum,
				  -override => 1,
                                 );
	    $ques =~ s/%%.*$//; # strip out incomplete proofs
	    print ".&nbsp;&nbsp;&nbsp;";
	    if ($CGI::qtype eq "PR") {
		&prettify($ques);
		print ($ques);
	    } else {
		print $ques;
	    }
	    print "</td>";
	        
	    #print "<td align=\"center\"> $perc% &nbsp; ($vcount)</td>" if $CGI::qtype eq "PR";
	    #print "<td align=\"center\"> $nonprem </td>" if $CGI::qtype eq "PR";
	    print "</tr>";
	}
	
	print 
	    "</table>\n",
	    $cgi->submit('action', 'Take the quiz'),
	    $cgi->reset(-value=>'Reset');
	
    } else {  ############ for Random Generation Problems
	
	if ($CGI::level && $CGI::qtype eq "PR") {
	    
	    &print_level_form;  ######### This displays the difficulty levels and it has a start_form but not end_form
	    
	} else { ########## Display Random Problems
	    
	    $numqs=@questions if (scalar(@questions)<$numqs);
	    $numqs=3 if $CGI::qtype eq "VA";       #validity
	    
	    my $s = "s" if $numqs > 1;            #creates plural of question(s) in instructions
	    
	    if (($CGI::qtype eq "PR") && (scalar(@questions) == scalar(@prev_chosen))) {
		    
		    @prev_chosen = (); ######### empty prev_chosen as all the problems in the difficulty level are attempted
		    $CGI::level = 1;   ######### set this to 1 to avoid printing checkanswers,reset answers
		    
		    print "<br><strong>You attempted all the \"$CGI::diff_level\" difficulty questions in this exercise.\n";
		    print "<br><br>Choose another level from the drop down list.</strong>\n";

		    &print_level_form;

	    } else {  
	        
		print h3("Answer the following question$s from $CGI::quiz ");
	        
		$preamble =~ s/\#!preamble//g;        #instructions in quizfile
		
		print $preamble;
		
		print $cgi->start_form( -action=>$program ) if $CGI::qtype ne "PR";   # Start a table for presenting the quiz
		print "<table border=0>\n";
	        
		my @selected;  # Variable to store random indices for selecting quiz questions

		@prev_chosen = () if $CGI::action =~ /Go/;
	        
		$i=0;
	      QUIZ_NUMS: while ($i<$numqs) {         # Gotta use a while loop cuz you won't wanna inc $i ...
		  # ... on passes that yield a duplicate random number.
		  $j=int(rand @questions);           # rand int from 0 to @questions-1
		  for ($n=0;$n<$i;$n++) {            #
		      if ($j==$selected[$n]) {       # If $j is equal to one of the nums already in @selected,
			  next QUIZ_NUMS;            # (No sense to keep looking.)
		      }
		  }
		  if (@questions<=@selected+@prev_chosen) {  # Check that we've got enough problems in the ...
		      @selected=(@selected,$j);              # problem file to avoid repeats from previous rounds, and if not,
		      $i++;                                  # just tack $j onto @selected directly ...
		      next QUIZ_NUMS;                        # and find the next number to put in @selected (if not finished).
		  }
		  for (@prev_chosen) {              # If there are enough problems in the problem file,
		      if ($j==$_) {                 # check to see if $j is equal to one of the nums in @prev_chosen.
			  next QUIZ_NUMS;           # If so, try another number...
		      }
		  }
		  @selected=(@selected,$j);     # If not, then $j isn't a repeat, so tack it onto @selected ...
		  $i++;                         # and increment $i.
		  
	      }
		
		
		push @prev_chosen, @selected;
		
		$j=0;
		for(@selected){
		    $j++;
		    $rlqz.="$questions[$_]$qsep";   # Tack the $_^th question with a $qsep onto $rlqz
		    # $qsep is constant defined in qmlib.pl
		    # next line commented out and subsequent one added by CA, 2004-04-15
		    # ($ques,$err,$ans,$foo)=split($sep,$questions[$_],4);
		    ($ques,$err,$ans)=split($sep,$questions[$_],3);
		    $qnum=$j;

		    &answer_form;    # creates the page with questions
		} # end for questions
		print "</table>\n";	

	    }  ########## end Display Random Problems
	    
	}  ########### end Random Generation Problems
	
    } 
    
    if ($CGI::qtype eq "PR") {       # no spaces in proofs
	$rlqz =~ s/\s+//g;
    } else {
	$rlqz =~ s/ /+/g;
    }
    
    print
	$cgi->hidden('user',$CGI::user),
	$cgi->hidden('score',$CGI::score),
	$cgi->hidden('qsofar',$CGI::qsofar),
	$cgi->hidden('attempt',$CGI::attempt),
	$cgi->hidden('quiz',$CGI::quiz),
	$cgi->hidden('qtype',$CGI::qtype),
	$cgi->hidden(-name => 'user_selection',
		     -value => $CGI::user_selection,
		     -override => 1),
	$cgi->hidden(-name => 'ques_ans', 
		     -values => \@CGI::ques_ans,
		     -override => 1),   
	$cgi->hidden(-name=>'prevchosen',
		     -values =>\@prev_chosen,
		     -override=>1),
	$cgi->hidden(-name=>'diff_level',
		     -value => $CGI::diff_level,
		     -override=>1),
	$cgi->hidden(-name=>'ranksort',
		     -value =>$CGI::ranksort,
		     -override=>1),
	$cgi->hidden(-name=>'assump',
		     -value =>$CGI::assump,
		     -override=>1),
	;
    
    if (($CGI::user_selection !~ /User/i) && ($CGI::level == 0 or $CGI::qtype ne "PR")){
	print 
	        $cgi->hidden('rlqz',$rlqz),
	        $cgi->submit('action','Check answers'),
	        $cgi->reset(-value=>'Reset answers'),
	    ;
    }
    print
	$cgi->submit('action','Main Menu'),
	$cgi->end_form,
	;   

} #end generate_quiz subroutine

sub print_level_form{

    print
	$cgi->start_form(-name => $program);

    print 
	"<table cellpadding='5' width='600'><tr><td width='350'>",
	"Choose Problem Difficulty Level in exercise $CGI::quiz :</td>",
	"<td align=\"left\">",
	$cgi->popup_menu(-name => 'diff_level',
			 -values => ['low','med','high'],
			 -default=> 'low',
			 ),
	"</td></tr>",
	"<tr><td colspan='2'> <tt>low : These problems are easy. <br> med : These problems are medium hard. <br> high : These problems are difficult. <br> </tt></td></tr>",
	"<tr><td colspan='2'> The difficulty levels are classified based on the ratio of successful to total proof attempts made by the Quizmaster users.<br></td></tr>",
	;
    
    print 
	"</table>",
	"<br>",
	$cgi->submit('action','Generate');
    print 
	$cgi->hidden(-name=>'level',
		     -default=>0,
		     force=>1);
    
}

sub get_questions{
#input : nothing
#output : return the problem file as an array 
    
    my ($diff_level) = @_;
    my $quizfile=$QUIZBASE.$CGI::quiz.$QUIZEXT;
    my $preamble;
########### Database queries ###############################
    my $ex_no = $CGI::quiz.$QUIZEXT;
    my $rank_sort = $CGI::ranksort; 
    my $assump_type = $CGI::assump;
    my $check;
    if(!$CGI::ranksort){
	$rank_sort = 'DESC';
    }
    if(!$CGI::assump){
	$assump_type = 'all';
    }
    my $check = &db_search_exno($ex_no);  # search for the exercise number in database

    if($check) {
	$CGI::qtype = "PR";
	$preamble = &db_get_preamble($ex_no);
	@questions = &db_get_questions($ex_no,$rank_sort,$assump_type,$diff_level);
	return ($preamble,@questions);
	
    }else{
	
	# Determine the number of questions in the quiz file
	
	open(QUIZFILE,$quizfile);
    
	while(<QUIZFILE>){
	    chop;
	    ($foo,$CGI::qtype) = split(/ /,$_,2) and next if /$qtype_marker/;  #get quiz type and continue
	    ($preamble .= $_) and next if /$preamble_marker/;
	    s/(\#.*)//;             ## strip comments
	    next if /^\s*$/;        ## skip empty lines
	    push @questions, $_;    ## Push each line in $quizfile onto @questions
	} #end while QUIZFILE
	close QUIZFILE;
	
	if (!@questions){
	    if (!$CGI::quiz) {
		print "<p>You did not select an exercise.";
	    } else {
		print ("<p>Sorry, no questions are available on this topic ($CGI::quiz).");
	    }
	    &bye_bye;                  #in qmlib.pl
	}else {
	    return $preamble, @questions;
	}
	
    }
}

sub generate_user_req_ques {
#input : nothing
#output : prints user requested questions (when user selects the user preference option)
    
    print $cgi->start_form(-action => $program);
    
    my ($preamble,@questions) = &get_questions;

    @prev_chosen = @CGI::prevchosen;
    $qnum =0;
    $rlqz ="";

    if(!@CGI::qnum){
	print "you have not selected any questions.<br>";
	print $cgi->submit('action','Main Menu');
	&bye_bye;
    }

    print h3("Answer the following question$s from $CGI::quiz");
    $preamble =~ s/\#!preamble//g;        #instructions in quizfile
    print h4($preamble);
    print "<table border =0>";


# limit the questions selected by user to 1 if it is of the following types
    @CGI::qnum = $CGI::qnum[0]  if ($CGI::qtype eq "PR"       #proof
				    || $CGI::qtype eq "IP"    #incomplete proof
				    || $CGI::qtype eq 'Exp'   #expansion
				    || $CGI::qtype eq 'CM');  #countermodel
    
# get the question numbers from database here for the selected exercise
# compare the question numbers with the attempted ones
    
    my $t=0; # question counter
    if($CGI::qtype eq "PR"){
	for(@questions){
	    my($foo1,$foo2,$foo3,$numb,$foo) = split($sep,$_,5);
	    if ($numb) { # then we have a database id (CA: ! not working 12/16/17)
		push @numbers,$numb;
	    } else {
		push @numbers,$t;
		$t++;
	    }
	}
    } else {
	for(@questions){
	    push @numbers, $t;
	    ++$t;
	}
    }
    
    $t=0;
    foreach my $ss (@numbers){ # iterate through the full set of problems
	++$t; 

	for (my $kk=0; $kk <= $#CGI::qnum; $kk++){ # iterate through user selections

	    $ss += 1; # if ($CGI::qtype ne "PR");
	    if($ss == ($CGI::qnum[$kk])){        ### since we are comparing array indexes with question numbers
		my $match = 0;
		for(@prev_chosen){
                   if ($_ == $ss){
                      $match = 1;
                 }
            }
           push @prev_chosen,$ss if (!$match);    ### storing actual question numbers but not indexes
		print "<tr> <td>";
		
		if($CGI::qtype eq "PR"){
		    ($ques,$err,$ans,$prob_number,$foo)=split($sep,$questions[$t-1],5);
		    $rlqz.="$questions[$ss-1]$qsep";   # Tack the $_^th question with a $qsep onto $rlqz
		}else{
		    ++$qnum;
		    ($ques,$err,$ans) = split($sep,$questions[$ss-1],3);
		    $rlqz.="$questions[$ss-1]$qsep";   # Tack the $_^th question with a $qsep onto $rlqz
		}
		&answer_form;
	    } 
	}
    }


    print
	"</table>",
        $cgi->hidden('user',$CGI::user),
	$cgi->hidden('score',$CGI::score),
	$cgi->hidden('qsofar',$CGI::qsofar),
	$cgi->hidden('attempt',$CGI::attempt),
	$cgi->hidden('quiz',$CGI::quiz),
	$cgi->hidden('qtype',$CGI::qtype),
	$cgi->hidden('rlqz',$rlqz),
	$cgi->hidden(-name => 'user_selection',
		     -value => $CGI::user_selection,
		     -override => 1),
	$cgi->hidden('qnum',\@CGI::qnum),
        $cgi->hidden(-name => 'prevchosen',
                     -values =>\@prev_chosen,
                     override => 1),
	$cgi->hidden(-name=>'ranksort',
		     -value =>$CGI::ranksort,
		     -override=>1),
	$cgi->hidden(-name=>'assump',
		     -value =>$CGI::assump,
		     -override=>1),
	$cgi->submit('action','Check'),
	$cgi->submit('action','Main Menu');
    
    print 
	$cgi->hidden(-name => 'ques_ans', 
		     -values => \@CGI::ques_ans)
	if @CGI::ques_ans;

    
    print $cgi->end_form;
}

#######################################################################

sub answer_form {
# input: nothing
# returns: nothing
# subroutine to generate quiz displayed for user to answer

    local $j; # this is required to prevent conflict with calling routine
    print "<tr>\n<td>\n";
    
    ### Quiz form for True/False questions

    if ($CGI::qtype eq "TF") {
	print
	    $cgi->hidden('qnum',$qnum),
	    
	    $cgi->radio_group(-name=>"ans$qnum",
			      -values=>['T','F'],
			      -cols=>2),
	    ;
	
	### Quiz form for Multiple Guess questions
	
    } elsif ($CGI::qtype eq "MC") {
	# first we put the options into an array for easy access
	$ans =~ s/$wsep/$sep/o;
	$ans =~ s/>/&gt\;/g; # so that html does not get confused
	$ans =~ s/</&lt\;/g;
	my @answerlist = split($sep,$ans);
	@answerlist = sort @answerlist;      #8-11-02 HK sorts MC answers in alphabetical order
	
	# print out the options
	print $cgi->hidden('qnum',$qnum);
	print "<select name=ans$qnum>\n<option selected value=\"\">?\n";
	for($j=0;$j<@answerlist;$j++){
	    my $next = @answerlist[$j];
	    print "<option \"$next\">$next\n";
	} # end for
	print "</select>\n";
    }
    elsif ($CGI::qtype eq "IP") { &IP_problem; }   # incomplete proof question
    elsif ($CGI::qtype eq "PR") { &PR_problem; }   # proof question
    elsif ($CGI::qtype eq "VA") {                  # validation question
	
	
	my @atoms;                              # Variable for list of atoms in the given $sequent
	my $seq = $ques;                        # Use a more descriptive local variable; the question of
	# validation type is a sequent
	
	# Make a nonredundant list of atoms
	
	my $atoms = $seq;                       
	$atoms =~ s/[\W v]//g;                  # Remove everything but atoms from the sequent
	$atoms =~ s/([A-Z])/$1 /g;              # separate atoms with spaces so we can make a list
	while ($atoms) {
	    ($elt, $_) = split(/ /,$atoms,2);
	    if (!/.*$elt.*/) {
		push(@atoms,$elt);
	    }
	    $atoms = $_;
	}
	&prettify($seq);
	print 
	        "$qnum.<tt> &nbsp;$seq</tt></td></tr>\n",
	        "<tr>\n<td>&nbsp;\n",
	    "</td></tr><tr><td>";                # HK 8-24-2002 Empty line between sequent and answer boxes
	
	print
	        $cgi->scrolling_list
		    (-name=>"ans$qnum",
		          -values=>['?','Valid','Invalid'],
		          -default=>'?',
		     -size=>1);
	
	print
	    "&nbsp;&nbsp;&nbsp;&nbsp;";                # HK 8-24-2002 Spaces between validity box and TF boxes
	
	for (sort @atoms) {
	        print
		    "$_:\n",
		    $cgi->scrolling_list
		    (-name=>"ans$qnum$_",
		      -values=>['','T','F'],       # generate T/F option lists for each sentence letter
		      -default=>'',
		     -size=>1);
	    }
	print
	    "</td></tr><tr><td>&nbsp;";           # HK 8-24-2002 Empty line between questions
	
    } elsif ($CGI::qtype =~ /PAREN/) {
	print "<input size=30 name=ans$qnum value=\"$ques\">";
    } elsif ($CGI::qtype eq 'Exp') {               # Expansion type problem
	print &expansion_form($ques);
    } elsif ($CGI::qtype eq 'CM') {
	&CM_route;
    } else {                 # default to text field
	print "<input size=30 name=ans$qnum value=\"\">";
    }
    
    print "</td>\n";
    print "<td>$qnum. $ques</td>\n" unless $CGI::qtype =~ /VA|PR|IP|Exp|CM/; #qtype was determined at...
    print "</tr>\n";                                                      #..the beginning of generate_quiz  
} # end answer_form subroutine


########################################################################
sub check_answers {
# input: nothing
# returns: nothing
# subroutine to check answers, reprints questions and congrats or error message
# global variable currscore, rlqz

    $currscore=0; # global for logging purposes
    local $i=0;
    local $rlqz=$CGI::rlqz;
    local $nextq;

    %ques_ans = @CGI::ques_ans;

    my @questions;

    my @foo = @CGI::prevchosen;

    if ($CGI::user_selection  =~ /User/i){
	push @questions, @CGI::qnum;
	$ques_ans{'count'} = $#CGI::prevchosen+1;
    }

    if ($CGI::qtype eq "PR") { &PR_check; }
    elsif ($CGI::qtype eq "IP") {&IP_check;}

    else {
	
	print
	        h2("Here are your results, $CGI::user..."),
	        "\n<dl>",
	    ;
	
      CHECK_LOOP: while ($rlqz) {

	  my $ques_no  = shift @questions;
	  my $check_score = $currscore;

	  $i++;                                              # question number
	  ($nextq,$rlqz) = split($qsep,$rlqz,2);             # put first ques in $rlqz in $nextq
	  local ($ques,$errmsg,$ans) = split($sep,$nextq,3); # split $nextq into 3 parts
	  local $guess = ${ "CGI::ans$i" };                   # user guess
	  
	$ques =~ s/\+/ /g;                                   # replace +'s with spaces in $ques
	$ans =~ s/\+/ /g;                                    # and $ans
	  
	  # Print question no. and the question, appropriately formatted 
	  
	if ($CGI::qtype =~/VA|PR/) {                  
	    my $nice_ques = $ques;      
	    $nice_ques =~ &htmlify(&prettify($nice_ques));
	    print "<dt>$i. $nice_ques</dt><p>\n";
	} elsif ($CGI::qtype eq "IP") {
	    my $nice_sequent = $ques;
	    $nice_sequent =~ s/(^.*)%%.*/$1/;
	    $nice_sequent =~ &htmlify(&prettify($nice_sequent));
	    print "<dt>$i. $nice_sequent</dt><p>\n";
	} elsif ($CGI::qtype eq 'Exp') {
	    print "<dt>".&htmlify($ques)."</dt>\n";
	} elsif ($CGI::qtype eq 'TR') {
	    print "<dt>$i. $ques</dt>\n";
	} else {
	    print "<dt>$i. ".&htmlify($ques)."</dt>\n";
	}
	  
	if    ($CGI::qtype eq 'TF') { &TF_check; }
	elsif ($CGI::qtype eq 'MC') { &MC_check; } 
	elsif ($CGI::qtype eq "TR") { &TR_check; }
	elsif ($CGI::qtype eq "VA") { &VA_check; }
	elsif ($CGI::qtype eq "Exp") { $currscore = &Exp_check; }
	elsif ($CGI::qtype eq "CM") { &CM_route; }
	else { &TXT_check; } # default to text

	  
	if (($currscore - $check_score) == 1){
	    $ques_ans{$ques_no} = 1;
	}else {
	    unless ($ques_ans{$ques_no}){
		$ques_ans{$ques_no} = 0;
	    }
	}
	$ques_ans{$ques_no*100} = $guess;
    } # end while CHECK_LOOP

    print "</dl>";
    
    @ques_ans = %ques_ans;

    $CGI::score+=$currscore;
    $CGI::qsofar+=$i;
    $CGI::attempt++;
    

    my $total_questions;
    my $no_of_ques_attempted;
    my $min_attempts;
    my $k = $i;
    my $best_effort_count =0;
    my $select_or_generate = "Generate";

    if($CGI::user_selection =~ /User/){

	my ($foo,@total_ques) =  &get_questions;

	$total_questions = $#total_ques;
	$no_of_ques_attempted = (($#ques_ans-1)/4);
	$min_attempts = 0.3*$total_questions;
	$k = "";
	$select_or_generate = "Select";

	if($SCORE_BEST_EFFORT){

	    $CGI::qsofar = $no_of_ques_attempted;

	    for my $key (keys %ques_ans){
		if(($key =~  /\d+/) &&  $ques_ans{$key} ==1 ) {
		    ++$best_effort_count;
		}
	    }

	    $CGI::score = $best_effort_count;
	}

    }else{

	$total_questions = $maxattempts;
	$no_of_ques_attempted = $CGI::attempt;
	$min_attempts = $minattempts;

    }
    
    $ratio = $CGI::score/$CGI::qsofar;
    
    print "Well done! " if $currscore == $i;
    print "Score=$currscore/$i, 
    Cumulative total = $CGI::score/$CGI::qsofar correct answers";
    
    print $cgi->start_form( -action=>$program );

    my $s = 's';
    $s = '' if $i == 1 and $k;

    if($no_of_ques_attempted >= $total_questions){
       
	if ($ratio >= $Acriterion) { print br($Amsg); }
	elsif (($currscore/$i) >= 0.8) { print br($Bmsg); }
	elsif ($ratio >= $Bcriterion) { print br($Cmsg); }
	else { print br($Fmsg); }
	    print
		$cgi->hidden('user',$CGI::user),
		$cgi->submit('action','Start over');
	    
    } elsif (($no_of_ques_attempted >=$min_attempts) && ($ratio > $Acriterion)){

	$k = " $k" if $k;
	    print
		br($Amsg),
		$cgi->hidden('user',$CGI::user),
		$cgi->hidden(-name=>'score',-value=>$CGI::score,-override=>1),
		$cgi->hidden(-name=>'qsofar',-value=>$CGI::qsofar,-override=>1),
		$cgi->hidden(-name=>'attempt',-value=>$CGI::attempt,-override=>1),
		$cgi->hidden('quiz',$CGI::quiz),
		$cgi->hidden(-name => 'user_selection',
			          -value => $CGI::user_selection,
			          -override => 1),
		$cgi->hidden('qnum',@CGI::qnum),
		$cgi->hidden(-name=>'prevchosen',
			          -values=> @CGI::prevchosen,
			          -override=>1),
		$cgi->hidden(-name=>'diff_level',
			          -value => $CGI::diff_level,
			          -override=>1),
		$cgi->hidden(-name =>'ques_ans',
			          -values => \@ques_ans,
			          -override => 1),
		$cgi->hidden(-name=>'ranksort',
			          -value =>$CGI::ranksort,
			          -override=>1),
		$cgi->hidden(-name=>'assump',
			          -value =>$CGI::assump,
			          -override=>1),
		$cgi->submit('action',"Start next section"),
		$cgi->submit('action',"$select_or_generate$k more question$s in this category"),
		$cgi->submit('action','Main Menu'),
		;
	    
    } else {

	$k = " $k" if $k;
	    print
		"Keep going! ",
		$cgi->hidden('user',$CGI::user ),
		$cgi->hidden(-name=>'score',-value=>$CGI::score,-override=>1),
		$cgi->hidden(-name=>'qsofar',-value=>$CGI::qsofar,-override=>1),
		$cgi->hidden(-name=>'attempt',-value=>$CGI::attempt,-override=>1),
		$cgi->hidden('quiz',$CGI::quiz),
		$cgi->hidden(-name => 'user_selection',
			          -value => $CGI::user_selection,
			          -override => 1),
		$cgi->hidden('qnum',@CGI::qnum),
		$cgi->hidden(-name=>'prevchosen',
			          -values =>@CGI::prevchosen),
		$cgi->hidden(-name=>'diff_level',
			          -value => $CGI::diff_level,
			          -override=>1),
		$cgi->hidden(-name=>'ranksort',
			          -value =>$CGI::ranksort,
			          -override=>1),
		$cgi->hidden(-name=>'assump',
			          -value =>$CGI::assump,
			          -override=>1),
		$cgi->submit('action',"$select_or_generate$k more question$s" ),
		$cgi->submit('action','Main Menu'),
		$cgi->hidden(-name =>'ques_ans',
			          -values => \@ques_ans,
			          -override => 1),
		;
	    
    } # end else (continue quiz)
} 

#my $message = join("-:-",@ques_ans);
#print "<a target=\"_new\" href=\"/cgi-bin/send-mail.cgi?type=$QUIZBASE$CGI::quiz$QUIZEXT&problem=$message\">[Send Mail]</a>";
    
print $cgi->end_form;
    
} #end check_answers subroutine

####################################################################
sub logit {
# input: nothing
# returns: nothing
# routine for logging transactions; called by bye_bye(in qmlib.pl)

    my ($foo,$logfile) = split("cgi-bin",$program);
    my $rlqz = $CGI::rlqz;
    my $dothis = $CGI::action || "Say Hello";
    my $numqs;

    if (open (LOG,">>$LOGDIR/$logfile")) {
	print LOG
	    "$CGI::user at $now ($e_ra)\n",
	    "$dothis $CGI::quiz\n";
	
	if ($dothis =~ /Check/) {
	    if ($CGI::qtype eq "PR") {
		print LOG
		    "Sequent: ",
		    $CGI::sequent,
		    "\nProof Check Result:\n$prfcheck_result\n";
	    } elsif ($CGI::qtype){
		my @questions = split($qsep,$rlqz);
		$numqs = @questions;
		for (@questions){
		    $i++;
		    my ($ques,$foo) = split($sep,$_);
		    $ques =~ s/\+/ /g;
		    $ques = dehtmlify($ques);
		    print LOG "Question $i: $ques\n";
		    if (${"CGI::ans$i"}) {
		        my $item = ${"CGI::ans$i"};
   		        print LOG
			    " -- response: $item\n";
		
		my $itemkey = $item;
		$itemkey =~ s/\s//g;
		
		        if ($CGI::qtype = "TR") {
			    print LOG "correct\n" if $transcheck{$itemkey} == 1;
			    print LOG "unknown\n" if $transcheck{$itemkey} == 0.5;
			    print LOG "incorrect\n" if !$transcheck{$itemkey};
			}

 	             } else {
			 print LOG " -- no response\n";
		     }

     	        }
	    }
	}
	print LOG "Score = $currscore/$numqs (Total $CGI::score/$CGI::qsofar)\n";
	
	print LOG "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n";
	close(LOG);
    }
} #end logit subroutine


####################################################################
sub TF_check {
# input: nothing
# returns: nothing
# Checking routine for True/False questions
# Global variables: $guess, $currscore, $ans, $errmsg, global constants: $thumbup, $thumbdown(def in qmlib.pl)

    if ($guess eq "") {
	print "<dd><em>You did not answer this question.</em></dd><p>";
    } elsif ($guess eq $ans) {
	print "<dd><img src=$thumbup><em>Your answer of </em>\"$guess\"<em> is correct.</em></dd><p>";
	$currscore++;
    } else {
	$errmsg =~ s/\+/ /g;
	print "<dd><img src=$thumbdown><em>Your answer of </em>\"$guess\"<em> is incorrect. $errmsg</em></dd><p>";
    }
}

####################################################################
sub MC_check {
# input: nothing
# returns: nothing
# Checking routine for Multiple Guess questions

    if ($guess eq "") {
	print "<dd><em>You did not answer this question.</em></dd><p>";
    } else {
	$ans =~ s/$wsep.*//o;
	$_ = "$sep$ans$sep";            # put $sep on either side of $ans (so we don't match subwffs)
	if (/.*[:]{2}$guess[:]{2}.*/) { # see if $guess matches one of the correct formulas in $ans
	    print 
		"<dd><img src=$thumbup><em>Your answer of </em>$guess<em> is correct.</em></dd><p>";
	    $currscore++;
	} else {
	    $errmsg =~ s/\+/ /g;
	    print "<dd><img src=$thumbdown><em>Your answer of </em>$guess<em> is incorrect. $errmsg</em></dd><p>";
	}
    }
}

####################################################################
sub TR_check {
# input: nothing
# returns: nothing
# Checking routine for Translation questions
# 1/17/2003 HK
# changed all references to answer_array to $ans
# changed the equality check to &is_equivalent
# changed all problem files involving translations to only include one answer

    my $output_string = "";

    $guess =~ s/\s//g;
    $ans =~ s/\s//g;

    if ($guess eq "") {
	print "<dd><em>You did not answer this question.</em></dd><p>";
    }
    else {
	$wfftype = &wfftype($guess);

	if (!$wfftype) {
	    print 
		"<dd><img src=$thumbdown><em>Your answer of </em><tt>$guess</tt><em> is not a wff.</em></dd><p>";
	}
	else { ## it's well formed
	    my @answers = sort (split(/::/,$ans));
	    my @tmp;
	    my $correct = 0;
	    my $timeout = 0;
	    my $equiv;
	    my $known_wrong = 0;
	    my %arity;
	    
	    #Check the wrong answers
	    foreach my $answer (@answers) {
		if ($answer =~ /WRONG/) {
		    $answer =~ s/\[|\]|WRONG//g;
		    if ($answer eq $guess) {
			$correct = 0;
			$known_wrong = 1;
		    }
		}
		else {
		    push (@tmp, $answer);
		}
	    }
	    @answers = @tmp;  #These are only the correct answers

	    #Check to make sure that the input has the same number of preds
	    my $temp = $answers[0];
	    while($temp =~ s/([A-Z])([a-uw-z]+)//) { # a-z bug fixed by CA 1/12/04; v is special
		$arity{$1} = length($2);
	    }
	    $temp = $guess;
	    while($temp =~ s/([A-Z])([a-uw-z]+)//) {
		if ($arity{$1} != length($2)) {
		    $output_string .= "<em> $1 is a " . $arity{$1} . " place predicate, ";
		    $output_string .= "but you incorrectly used it as a " . length($2) . " place predicate.</em><br>\n"; 
		    $known_wrong = 1;
		}
	    }
	    
	    #Check the correct answers
	    
	    unless ($known_wrong) {
		$guess = &reparen($guess);

		foreach my $answer (@answers) {
		    #Checking each of the answers in the problem file
		    $answer = &reparen($answer);
		    if ($answer eq $guess) {
			$equiv = "equivalent";
			last;
		    }
		}
		unless ($equiv eq "equivalent") {
		    #Check equivalency on first correct answer in prob_file
		    $equiv = &is_equivalent($answers[0],$guess,0);
		}
		
		if ($equiv eq "equivalent") {
		    print
			"<dd><img src=$thumbup>",
			"<em>Your answer of </em>",
			"<tt>$guess</tt>",
			"<em> is correct.</em></dd><p>";
		    $currscore++;
		    $correct =1;
		    $transcheck{$guess} = 1;
		}
		elsif ($equiv eq "timeout") {
		    $timeout = 1;
		}
	    }
	    
	    if ($timeout) {
		print
		    "<em>Your answer of </em><tt>$guess</tt><em> is not identical to the expected answer, but its possible equivalance to a correct answer could not be verified. ",
		    "This problem will be reviewed by the system administrator. ",
		    "You may go on to the next question or click back to try again. </em>"
		    ;
		$transcheck{$guess} = 0.5;
		print $cgi->popup_menu(-values=>[ 'Give up? - pop up answer here',
						  'Quitter!! ;-)',
						  @answers ]);
		
		
		#my %msg = (From => "clic\@logic.tamu.edu",
		#	   To => "ryanscott\@logic.tamu.edu, colin\@logic.tamu.edu, jmk\@logic.tamu.edu",
		#	   Subject => "quizmaster translation problem",
		#	   );
		
		#$msg{'Message'} = "There was a translation attempt made that could not be verified because of a timeout\n\n";
		#$msg{'Message'} .= "Problem File = " . $QUIZBASE . $CGI::quiz . $QUIZEXT . "\n\n";
		#$msg{'Message'} .= "Sentence:  " . $ques . "\n\n";
		#$msg{'Message'} .= "Student answer: " . $guess . "\n\n";
		#$msg{'Message'} .= "Canned answers: \n";
		#foreach my $answer (@answers) {
		#    $msg{'Message'} .= "\t" . $answer . "\n";
		#}
		
		#$msg{'Message'} .= "Student self-id: $CGI::user\n";
		
		#sendmail(%msg) or print STDERR $Mail::Sendmail::error;
		
	    }
	    elsif (!$correct || $known_wrong) {
		$errmsg =~ s/\+/ /g;
		my $sentvarcount = $guess =~ tr/A-Z/A-Z/;
		my $ansvarcount = $answers[0] =~ tr/A-Z/A-Z/;
		my $answfftype =  &wfftype($answers[0]);
		
		print
		    "<dd><img src=$thumbdown>",
		    "<em>Your answer of </em><tt>$guess</tt><em> is not correct. ",
		    $output_string,
		    $errmsg,
		    " Your answer ";
		print
		    "has $wfftype form and " if ($wfftype ne $answfftype);
		print
		    "contains $sentvarcount sentence letters. ",
		    "There may be more than one correct answer, but at least one of ",
		    "the correct answers ";
		print
		    "has $answfftype form and " if ($wfftype ne $answfftype);
		print
		    "contains $ansvarcount sentence letters. ",
		"</em>",
		    "</dd>",
		    "<p>",
		    ;
		print
		    "Click the back button to try again. ",
		    $cgi->popup_menu(-values=>[ 'Give up? - pop up answer here',
						'Quitter!! ;-)',
						@answers ]);
		

	    }
	}
    }
}

####################################################################
sub VA_check {
# input: nothing
# returns: nothing
# Checking routine for Validation questions

  if ($guess =~ /\?/) {
    print "<dd><em>You did not answer this question.</em></dd><p>";
  } elsif ($guess eq "Valid") {
    if ($ans ne "Valid") {
      print "<dd><img src=$thumbdown><em>Your answer of \"$guess\" is incorrect. $errmsg</em></dd><p>" ;
    } else {
      print "<dd><img src=$thumbup><em>Your answer of \"$guess\" is correct!</em></dd><p>";
      $currscore++;
    }
  } else {
    my %tva;
    my $seq = &seq_reparen($ques);
    my $premises = $seq;
    $premises =~ s/(.*)\|-.*/$1/;
    my $conclusion = $seq;
    $conclusion =~ s/.*\|-(.*)/$1/;
    
    # Create @atoms again (shouldn't have to do this -- fix later)
    
    my @atoms;                
    my $atoms = $seq;
    $atoms =~ s/[\W v]//g;     
    $atoms =~ s/([A-Z])/$1 /g;
    while ($atoms) {
      ($elt, $_) = split(/ /,$atoms,2);
      if (!/.*$elt.*/) {
	push(@atoms,$elt);
      }
      $atoms = $_;
    }
    
    # Reconstruct user's truth value assignment as hash %tva
    
    for (@atoms) {
      $tva{$_} = ${ "CGI::ans$i$_"};
  }
  
  # Check to see that they've assigned a TV to every sentence letter
  
  for (sort @atoms) {
    
    if ($tva{$_} eq "") {
      print 
	"<dd><em>You didn't provide a truth value for </em><tt>\"$_\"</tt><em> ",
	"(and perhaps others).  You must submit a truth value for each sentence letter ",
	"if you think the sequent is invalid.  (What <b>might</b> have happened is that ",
	"you found assignments for the other sentence letters that will yield an invalidating ",
	"assignment regardless of  the truth value of </em>\"$_\"<em>.  In such a case, ",
	"just assign </em>\"T\"<em> or </em>\"F\"<em> arbitrarily to the irrelevant ",
	"sentence letter, as either will work.)</em></dd><p>";
      next CHECK_LOOP;
    }
  }
  
  # Test to see whether %tva is an invalidating assignment
  
  while ($premises) {
    ($nth_premise,$premises) = split(",",$premises,2);
    $_=$nth_premise;
    my $tva_string;
    for (sort @atoms) {
      $tva_string .= "$_:$tva{$_}<spacer type=horizontal size=8>";
    }
    if (&calculate_tv($nth_premise,%tva) ne "T") {
      $nice_nth_premise = $nth_premise;
      $nice_nth_premise =~ s/([& v]|\|-|->|<->)/ $1 /g; 
      print 
	"<dd><img src=$thumbdown><em>On the assignment:",
	"</em><spacer type=horizontal size=10>$tva_string",
	"<em>the premise </em>\"<tt>$nice_nth_premise</tt>\"<em> is <b>false</b> ",
	"so the assignment is not invalidating! ";
      if ($premises) {
	print
	  "(Other premises might be false as well.)</dd></em><p>";
      } else {
	print "</em></dd><p>";
      }
      last;
    } elsif (!$premises) {
      $_=$conclusion;
      if (&calculate_tv($conclusion,%tva) eq "T") {
	print
	  "<dd><img src=$thumbdown><em>On the assignment:",
	  "</em><spacer type=horizontal size=10><tt>$tva_string</tt> ",
	  "<em>the conclusion </em>\"<tt>$conclusion</tt>\"<em> is <em>true</em> ",
	  "so the assignment is not invalidating.</em></dd><p>";
      } else {
	print
	  "<dd><img src=$thumbup><em>On the assignment:",
	  "</em><spacer type=horizontal size=10><tt>$tva_string</tt>",
	  "<em>the premises are true and the conclusion is false ",
	  "so it is an invalidating assignment!</em></dd><p>";
	$currscore++;
      }
    }
  }
}
}

####################################################################
sub TXT_check {
# input: nothing
# returns: nothing
# Default checking routine; called by check_answers
    
    $guess =~ s/\s//g; ## added by CA 10/8/03

    if ($guess eq "") {
	print "<dd><em>You did not answer this question.</em></dd><p>";
    }else {

	($guess_wfftype, $guess_lhs, $guess_rhs)  = &wffa($guess);
	($ans_wfftype, $ans_lhs, $ans_rhs) = &wffa($ans);

	if (!$guess_wfftype){
	    print "<dd><img src=$thumbdown>Your answer $guess is not an acceptable abbreviation of any well formed formula</dd>";
	}
	elsif ($guess eq $ans) {
	    print 
		"<dd><img src=$thumbup><em>Your answer of $guess is correct.</em></dd><p>";
	    $currscore++;
	}
	else{
	    if ($guess_wfftype eq 'negation') {
		$guess_wfftype = "negation of $guess_lhs";
	    } elsif ($guess_wfftype ne 'atomic') {
		$guess_wfftype = "$guess_wfftype of ".&reparen($guess_lhs)." and ".&reparen($guess_rhs);
	    }
	    if ($ans_wfftype eq 'negation') {
		$ans_wfftype = "negation of $ans_lhs";
	    } elsif ($ans_wfftype ne 'atomic') {
		$ans_wfftype = "$ans_wfftype of ".&reparen($ans_lhs)." and ".&reparen($ans_rhs);
	    }

	    $guess_full = &reparen($guess);
	    if($guess eq $guess_full){
		print "<dd><img src = $thumbdown> Your answer $guess is same as the presented question. You can drop some more parentheses.</dd> ";
	    } else {
		if ($guess_wfftype ne $ans_wfftype){
		    print "<dd><img src=$thumbdown>Your answer $guess would have been an acceptable abbreviation of $guess_full which is a $guess_wfftype, but the answer to this question $ans is a $ans_wfftype</dd>";
		} elsif (&samewff($guess,$ans)) {
		    print "<dd><img src=$thumbdown>Your answer $guess represents the original formula, but you have not omitted all the possible parentheses</dd>";
		} else {
		    print "<dd><img src=$thumbdown>Your answer $guess represents the same type of formula as the original formula, but it represents $guess_full which is not equivalent to $ans</dd>";
		    
		}
	    }
	}
    }
    
#    } else {
#	$errmsg =~ s/\+/ /g;
#	print "<dd><img src=$thumbdown><em>Your answer of $guess is incorrect. $errmsg</em></dd><p>";
#    }

}

####################################################################
sub expansion_form {
# input: the question string
# returns: the form to be printed out
# Expansion subroutine: called by generate_quiz, provides the three forms for expanding the expression in three universes

  my ($ques) = @_;
  $ques = &htmlify($ques);
  my $form;
  $form .= "Expand $ques <p>";
  foreach $universe ("a","a,b","a,b,c") {
    $form .= "... for universe {$universe}: ";
    $form .= "<br>";
    $form .= $cgi->textfield(-name=>'expansion',
			    -size=>60);
    $form .= "<p>";
  }
  return $form;
}

####################################################################
sub Exp_check {
# input: nothing
# returns: score for question
# Expansion subroutine: called by check_answers; checks if student provdied correct expansions for the three given universes

  my $count=0;
  my $score=0;
  print
    " expansions checked",
    "<dl>",
    ;

  foreach $universe (("a","a,b","a,b,c")) {
    my @universe = split(/,/,$universe);
    print
      "<dt>",
      "<strong>UNIVERSE {$universe}</strong>",
      "</dt>",
      ;
    
    if (!$CGI::expansion[$count]) {
      print
	"<dd>",
	"You did not provide an expansion for {$universe}",
	"</dd>",
	;
    } elsif (!&wff($CGI::expansion[$count])) {
      print
	"<dd>",
	"<img src=$thumbdown>",
	"Your expansion $CGI::expansion[$count] is not a wff. ",
	"(Please note that the program does not yet allow parentheses to be dropped in multiple clause conjuncts and disjuncts)",
	"</dd>",
	;
    } elsif (&is_expansion($ques,$CGI::expansion[$count],@universe)) {
      print
	"<dd>",
	"<img src=$thumbup>",
	"Expansion $CGI::expansion[$count] is correct",
	"</dd>",
	;
      ++$score;
    } else {
      print
	"<dd>",
	"<img src=$thumbdown>",
	"Expansion $CGI::expansion[$count] is incorrect",
	"</dd>",
	;
      
      my $correcttype = &wfftype(&expand_qwff($ques,@universe));
      my $usertype = &wfftype($CGI::expansion[$count]);
      if ($correcttype ne $usertype) {
	print
	  "<dd>",
	  "Your expansion is a $usertype but should be a $correcttype.",
	  "</dd>",
	  ;
      } else {
	my @expansions = ($ques);
	my $exp = $ques;
	while (!&qfree($exp)) {
	  push @expansions, 'expands to';
	  $exp = &semi_expand_qwff($exp,@universe);
	  push @expansions, $exp;
	}
	
	print
	  "<dd>",
	  $cgi->start_form,
	  "The primary connective is correct ($usertype) but you should check the subsidiary connectives and clauses of your expansion. ",
	  $cgi->popup_menu(-values=>[ 'Give up? - pop up answer here',
				     'Quitter!! ;-)',
				     @expansions ]),
	  $cgi->end_form,
	  "</dd>",
	  ;
	
      }
    }
    ++$count;
  }
  print "</dl>";
  return $score/3;
}
