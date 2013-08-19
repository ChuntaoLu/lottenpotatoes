class SessionsController < ApplicationController
  # user shouldn't have to be logged in before logging in!
  skip_before_filter :set_current_user
  def create
    auth = request.env["omniauth.auth"]
    #debug below
    #render :text => auth.to_yaml
    #raise auth.inspect
    user = Moviegoer.find_by_provider_and_uid(auth["provider"], auth["uid"]) ||
        Moviegoer.create_with_omniauth(auth)
    #raise user.inspect
    session[:user_id] = user.id
    #raise session.inspect
    redirect_to movies_path
  end
  def destroy
    session.delete(:user_id)
    flash[:notice] = 'Logged out successfully.'
    redirect_to movies_path
  end
end