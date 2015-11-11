class SodaMachine
  def dispense(code, change_inserted)
    soda_type = soda_type_for(code)
    return nil if soda_type == nil
    num_sodas = (change_inserted/ soda_type.cost).floor
    case num_sodas
      when 0
        return false
      when 1
        return new_soda(soda_type)
      else
        return Array.new(num_sodas) { new_soda(soda_type) }
    end
  end
end

#Rewrite
class SodaMachine
  def dispense(code, change_inserted)
    soda_type = soda_type_for(code)
    return [] if soda_type == nil
    num_sodas = (change_inserted/ soda_type.cost ).floor
    return Array.new(num_sodas) { new_soda(soda_type) }
  end
end