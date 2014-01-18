class UserMailer < ActionMailer::Base
  default from: "green_mercury@codescouts.org"

  def miss_you(user)
    @user = user

    mail to: user.email, subject: "We miss you!"
  end
end
