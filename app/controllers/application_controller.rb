class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_current_user
  protected # prevents method from being invoked by a route
  def set_current_user
    # we exploit the fact that find_by_id(nil) returns nil
    @current_user ||= Moviegoer.find_by_id(session[:user_id])
    #below bad: once user logs out, @current_user becomes nil and redirects to login
    #redirect_to login_path(:provider => 'twitter') and return unless @current_user
    #redirect_to '/auth/twitter' and return unless @current_user
  end


end
