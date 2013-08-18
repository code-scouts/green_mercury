class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :rpx_connectable

  before_create :blank_email_is_null

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

  # The RegistrationsController sets email to an empty string on
  # social registration from twitter. BUT that means the unique
  # index on email is violated by the second twitter registration.
  # Setting it to null rather than empty string allows multiple users
  # with blank emails.
  def blank_email_is_null
    if email.blank?
      self.email = nil
    end
  end
end
