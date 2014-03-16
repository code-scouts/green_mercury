class PreexistingMember < ActiveRecord::Base

  def application_class
    if is_mentor
      MentorApplication
    else
      MemberApplication
    end
  end
end
