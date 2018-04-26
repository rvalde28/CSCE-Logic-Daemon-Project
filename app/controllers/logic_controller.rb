require 'open3'
# run readlink -f [script] to find pl script if ruby can't find and place in capture2

class LogicController < ApplicationController
  
  def home
  end

  def primer
  end

  def quizmaster
    @quiz_views = ["login", "difficulty", "menu", "question"]
    @quiz_view = "login"
    @question_type = -1
    
         ########### Handle Extra Details ###########
    @nickname = "Anonymous"
    if(session[:nickname] and !params[:nickname])
      @nickname = session[:nickname]
    elsif(params[:nickname])
      @nickname = params[:user]
      session[:nickname] = params[:user]
    end
    
    @score = 0
    if(session[:score] and !params[:score])
      @score = session[:score]
    elsif(params[:score])
      @score = params[:score]
      session[:score] = params[:score]
    end
    
    @qsofar = 0
    if(session[:qsofar] and !params[:qsofar])
      @qsofar = session[:qsofar]
    elsif(params[:qsofar])
      @qsofar = params[:qsofar]
      session[:qsofar] = params[:qsofar]
    end
    
    @attempt = 0
    if(session[:attempt] and !params[:attempt])
      @attempt = session[:attempt]
    elsif(params[:attempt])
      @attempt = params[:attempt]
      session[:attempt] = params[:attempt]
    end
    
    @question_key = "Ex.0.0"
    if(session[:question_key] and !params[:question_key])
      @question_key = session[:question_key]
    elsif(params[:question_key])
      session[:question_key] = params[:question_key]
      @question_key = params[:question_key]
    end
    
    ###### If Action = Go To Menu (Submit) ######
    if(params[:submit_login] || params[:menu])
      @quiz_view = "menu"
      print("\n============= Perl Return Start =============\n")
      @renderedPerl,_ = Open3.capture2(
        'perl',
        '/home/ec2-user/environment/CSCE-431-Logic-Daemon-Project/app/cgi-bin/get_quiz_topic.pl'
      )
      print("\n============= Perl Return End =============\n")
      
      if(params[:submit_login])
        params.delete :submit_login
      else
        params.delete :menu
      end
    
    ###### If Action = Generate Question ######
    elsif(params[:generate_quiz])
      
      if(params[:user_selection] == "Random")
        @quiz_view = "question"
        # Get questions
        
        params.delete :generate_quiz
      elsif(params[:user_selection] == "User Preference")
        @quiz_view = "question"
        # Get question
        
        params.delete :generate_quiz
      elsif(params[:diff_level])
        
        params.delete :diff_level
      end
    
    ###### Difficulty Button ######
    elsif(params[:difficulty_button])
      @quiz_view = "difficulty"
      params.delete :difficulty_button
    
    ###### Check Button ######
    elsif(params[:check_button])
      # Call check actions
      params.delete :check_button
    
    ###### Reset Button ######
    elsif(params[:reset_button])
      # Call reset actions
      params.delete :reset_button
      
    end
    
    ########### Handle View Partial ###########
    if(params[:quiz_view])
      @quiz_view = params[:quiz_view]
    end
    @quiz_partial = "quizmaster/" + @quiz_view
    
  end

  def daemon
    @premise = "" 
    @conclusion = ""
    @proof = "AASDFADASD"
    @sequent = ""
    
    if(session[:premise] and !params[:premise])
      @premise = session[:premise]
    elsif(params[:premise])
      @premise = params[:premise]
      session[:premise] = params[:premise]
    end
    
    if(session[:conclusion] and !params[:conclusion])
      @conclusion = session[:conclusion]
    elsif(params[:conclusion])
      @conclusion = params[:conclusion]
      session[:conclusion] = params[:conclusion]
    end

    
    if(session[:proof] and !params[:proof])
      @proof = session[:proof]
    elsif(params[:proof])
      @proof = params[:proof]
      session[:proof] = params[:proof]
    end

    if(params[:restart_button])
      @premise = ""
      @conclusion = ""
      @proof = ""
    elsif(params[:example_button])
      @premise = "PvQ->R, P, @xFx, Fa&R->S "
      @conclusion = "S"
      @proof = "1       (1) PvQ->R    A
2       (2) P         A
2       (3) PvQ       2 vI
1,2     (4) R         1,3 ->E
5       (5) @xFx      A
5       (6) Fa        5 @E
1,2,5   (7) Fa&R      4,6 &I
8       (8) Fa&R->S   A
1,2,8,5 (9) S         7,8 ->E"
    end

    @premise = @premise.gsub(" ", "")
    puts @proof

    @sequent = @premise + "|-" + @conclusion
    #@proof = @proof.gsub("\r"," ")

    if(params[:check_proof])
    @deamon_response =  Open3.capture2(
       'perl',
       '/home/ubuntu/workspace/CSCE-431-Logic-Daemon-Project/app/controllers/home/cgi-bin/logic.pl',
       @sequent,
       @proof
        )[0]
    end
  end

  def checkers
    @WFFInput = ""
    @formula1 = ""
    @formula2 = ""
    
    if(session[:WFFInput] and !params[:WFFInput])
      @WFFInput = session[:WFFInput]
    elsif(params[:WFFInput])
      @WFFInput = params[:WFFInput]
      session[:WFFInput] = params[:WFFInput]
    end
    
    if(session[:formula1] and !params[:formula1])
      @formula1 = session[:formula1]
    elsif(params[:formula1])
      @formula1 = params[:formula1]
      session[:formula1] = params[:formula1]
    end
    
    if(session[:formula2] and !params[:formula2])
      @formula2 = session[:formula2]
    elsif(params[:formula2])
      @formula2 = params[:formula2]
      session[:formula2] = params[:formula2]
    end
    
    #@result = system("/usr/bin/perl /home/ubuntu/workspace/CSCE-431-Logic-Daemon-Project-2/app/controllers/home/cgi-bin/wff-wrapper.pl \"A->B\"")
    @result = Open3.capture2(
    'perl',
    '/home/ubuntu/workspace/CSCE-431-Logic-Daemon-Project/app/controllers/home/cgi-bin/wff-wrapper.pl', 
    @WFFInput
    )[0]
    
    @eqResult = Open3.capture2(
    'perl',
    '/home/ubuntu/workspace/CSCE-431-Logic-Daemon-Project/app/controllers/home/cgi-bin/test/equivalency.pl', 
    @formula1,
    @formula2
    )[0]
  end
end
