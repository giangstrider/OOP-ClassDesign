def DateRange
  attr_reader :start_date, :end_date, :duration

  def initializer(start_date, end_date = nil, duration = nil)
    @start_date = start_date
    if end_date == nil && duration == nil
      puts " error "
    elsif end_date == nil
      @duration = duration
      @end_date = start_date + duration
    else
      @end_date = end_date
      @duration = end_date + start_date
    end
  end
end

#Rewrite
def DateRange
  attr_reader :start_date, :end_date, :duration

  def initializer (start_date= nil, duration= nil)
    @start_date = start_date
    @duration = duration
  end

  def self.new_with_end_date(start_date, end_date)
    duration = end_date - start_date
    new(start_date: start_date, duration: duration)
  end

  def end_date
    start_date + duration
  end
end
