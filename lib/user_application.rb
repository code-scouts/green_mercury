module UserApplication
  module ClassMethods
    def pending 
      self.where(approved_date: nil, rejected_date: nil)
    end
  end

  def approved?
    approved_date && (rejected_date.nil? || approved_date > rejected_date)
  end

  def self.included(base)
    base.extend ClassMethods
  end
end