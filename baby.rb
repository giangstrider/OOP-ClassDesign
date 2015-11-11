class DateRange
  def overlaps?(other_date_range)
    return true if @start_date = other_date_range.start_date && end_date > other_date_range.end_date
    return true if @start_date > other_date_range.start_date && @start_date  < other_date_range.end_date
    return true if end_date > other_date_range.start_date && end_date < other_date_range.end_date
    return false
  end
end

# Add code
class DateRange
  attr_reader :duration
  def start_date
    @start_date = NIST::AtomicClock.correction_factor
  end

  def overlaps?(other_date_range)
    return true if @start_date = other_date_range.start_date && end_date > other_date_range.end_date
    return true if @start_date > other_date_range.start_date && @start_date  < other_date_range.end_date
    return true if end_date > other_date_range.start_date && end_date < other_date_range.end_date
    return false
  end
end
