class TwoFactorAuthController < ApplicationController

  def new
    if params[:twoFA][:twoFA_auth] == "on"
      # Enable 2FA
      @secret_2fa = ROTP::Base32.random_base32
      $global_secret_2fa = @secret_2fa
      totp = ROTP::TOTP.new(@secret_2fa)
      @user = User.find_by(id: params[:twoFA][:twoFA_userId])
      qr_link = totp.provisioning_uri(@user.email + "(Blackbox)")
      totp = nil
      @qr = RQRCode::QRCode.new(qr_link)
      @qr = @qr.as_png(size: 400)
    elsif params[:twoFA][:twoFA_auth] == "off"
      @user = User.find_by(id: params[:twoFA][:twoFA_userId])
      @user.update_attribute(:encrypted_2fa_secret, nil)
      redirect_to user_url(@user)
    end
  end

  def create
    totp = ROTP::TOTP.new($global_secret_2fa)
    if totp.now() == params[:twoFA][:otp]
      # Linked successfully, save the encrypted otp in database
      key = ActiveSupport::KeyGenerator.new('blackbox').generate_key(Rails.application.credentials.dig(:salt_2fa), 32)
      crypt = ActiveSupport::MessageEncryptor.new(key)
      encrypted_data = crypt.encrypt_and_sign($global_secret_2fa)
      $global_secret_2fa = nil
      @user = User.find_by(id: params[:twoFA][:twoFA_userId])
      @user.update_attribute(:encrypted_2fa_secret, encrypted_data)
    else
      render :status => 403 
    end
  end

  def verify
    @user = User.find_by(id: params[:id])
    if @user.two_factor_state != params[:state]
      redirect_to login_url
    end
  end

  # Definition for verify action POST request
  def verify_post
    user = User.find_by(id: params[:otp][:twoFA_userId])
    key = ActiveSupport::KeyGenerator.new('blackbox').generate_key(Rails.application.credentials.dig(:salt_2fa), 32)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    secret = crypt.decrypt_and_verify(user.encrypted_2fa_secret)
    totp = ROTP::TOTP.new(secret)
    secret = nil
    crypt = nil
    key = nil
    if params[:otp][:otp] == totp.now()
      # Destroying 2fa state
      user.update_attribute(:two_factor_state, nil)
      log_in user
      flash[:success] = "Login was successful, Welcome! ~Mr. Robot"
      redirect_to user_url(user)
    else
      redirect_to controller: 'two_factor_auth', action: 'verify', id: user.id, state: user.two_factor_state
    end
  end
end
