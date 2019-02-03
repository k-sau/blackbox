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
    else
      # Disable 2fa
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
      @user.save
      flash.now[:success] = "Two factor authentication setup was successful."
      redirect_to user_url(@user)
    end
  end
end
