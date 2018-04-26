class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
end

  #Function to set navigation buttons as active
  def current_class?(test_path)
    if request.path == test_path
      return "nav-button-active"
    else 
      return "nav-button"
    end
  end
