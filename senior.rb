#Your message
def age
  if trying_impress?
    return @age + 5
  elsif trying_to_be_teengaer
    return @age - 3
  else
    return @age
  end
end

#My message
def age
# i am honest
  return @age
end

#Mine-Cell example
mine_cell = Cell.new_mine
flag_cell = Cell.new_flag
mine_cell.contents = :flag

def choose(cell)
  if cell.contents == :mine
    game_over
  else next_turn
  end
end

#Rewrite
def mine?
  @contents == :mine
end

def flag!
  @contents == :flags
end

def choose(cell)
  if cell.mine?
    game_over
  else
    next_turn
  end
end