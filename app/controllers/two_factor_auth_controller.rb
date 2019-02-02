class TwoFactorAuthController < ApplicationController

  def new
    if params[:twoFA][:twoFA_auth] == "on"
      # Enable 2FA
      secret_2fa = SecureRandom.alphanumeric(16)
      totp = ROTP::TOTP.new(secret_2fa)
      @user = User.find_by(id: params[:twoFA][:twoFA_userId])
      qr_link = totp.provisioning_uri(@user.email)
      @qr = RQRCode::QRCode.new( qr_link, :size => 18, :level => :h )
    else
      # Disable 2fa
    end
  end
end
