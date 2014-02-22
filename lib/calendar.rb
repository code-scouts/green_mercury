class Calendar
  def initialize(collection, date)
    @collection = collection
    @month = [*date.beginning_of_month..date.end_of_month]
  end

  def organize_by_date
    calendar = create(@month)    
    @collection.each do |event|
      @month.each do |day|
        calendar[day] << event if event.happening_on?(day)
      end
    end

    calendar
  end

  private

  def create(month)
    month.inject({}) { |h,l| h[l] = []; h }
  end
end
