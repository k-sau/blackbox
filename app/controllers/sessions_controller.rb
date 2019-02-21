class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.encrypted_2fa_secret.nil?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to user
      else
        # Creating state for two factor verify, so that attacker can't manipulate the user id
        # Login and check url for tfa enbale users to understand the above statement.
        user.update_attribute(:two_factor_state, SecureRandom.alphanumeric(30))
        redirect_to controller: 'two_factor_auth', action: 'verify', id: user.id, state: user.two_factor_state
      end
    else
      flash.now[:danger] = "Invalid email or password combination" # Not quite right :/
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
