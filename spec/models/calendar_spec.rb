require 'spec_helper'

describe Calendar do
  class SchedulableDouble
    def happening_on?(date)
      date == Date.current
    end
  end

  describe '#organize_by_date' do 
    it "organizes the items according to when they are happening" do 
      collection = [SchedulableDouble.new]
      calendar = Calendar.new(collection, Date.current).organize_by_date
      expect(calendar[Date.current]).to match_array collection
    end
  end
end