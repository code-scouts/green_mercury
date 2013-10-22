module UserApplication
  module ClassMethods
    def pending 
      self.where(approved_date: nil, rejected_date: nil)
    end

    def rejected
      self.where("rejected_date <= ? AND (approved_date IS NULL OR rejected_date >= approved_date)", Time.now)      
    end
  end

  def user 
    User.fetch_from_uuid(user_uuid)
  end

  def rejected?
    !rejected_date.nil? && (approved_date.nil? || rejected_date > approved_date)
  end

  def approved?
    !approved_date.nil? && (rejected_date.nil? || approved_date > rejected_date)
  end

  def self.included(base)
    base.extend ClassMethods
  end
end
