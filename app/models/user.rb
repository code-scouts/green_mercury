class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :rpx_connectable

  def has_password?
    encrypted_password.present?
  end

  protected

  # Users' email and password aren't required, because they may
  # have signed in using a social provider. Some providers
  # (notably Twitter) don't provide email >:(
  def email_required?
    false
  end

  # This is somewhat confusing. This tells Devise to do password
  # confirmation checks if password confirmation was passed.
  def password_required?
    !password_confirmation.nil?
  end
end
