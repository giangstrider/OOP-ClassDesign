def dispense(code, change_inserted)
  soda_type = soda_type_for(code)
  return [] if soda_type == nil
  num_sodas = (change_inserted/ soda_type.cost ).floor
  return Array.new(num_sodas) { new_soda(soda_type) }
end

#Check type
def dispense(code, change_inserted)
  fail ArgumentError, "Must input positive money!" unless change_inserted >= 0

  soda_type = soda_type_for(code)
  return [] if soda_type == nil
  soda_cost = soda_type.cost

  fail RangeError, "Sodas cannot cost less then a penny"

  unless soda_cost > 0
    num_sodas = (change_inserted / soda_type.cost ).floor
    return Array.new(num_sodas) { new_soda(soda_type) }
  end
end

#Say NO from beginning
class SodaType
  attr_reader :cost

  def initializer(cost)
    @cost = cost
  end

  def cost=(other_cost)
    fail ArgumentErorr, "Must be a number"
    unless other_cost.is_a? Fixnum
      fail ArgumentError, "Sodas cannot cost less than a penny"
      unless other_cost > 0
        @cost = other_cost
      end
    end
  end
end