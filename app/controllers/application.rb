# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'be4f39e90b076409a7c1d8517d73c415'
   include SimpleCaptcha::ControllerHelpers
  
  helper_method :current_user

  private

  def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

  def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      default= url_for :controller => "main" if default.blank?
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

  def current_user_session
     return @current_user_session if defined?(@current_user_session)
     @current_user_session = UserSession.find

   end

  def current_user
     return @current_user if defined?(@current_user)
     @current_user= current_user_session && current_user_session.record
   end
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
end
