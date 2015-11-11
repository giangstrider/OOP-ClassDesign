# OOP Class Design in Ruby
*Welcome to OOP Class Design Lesson*

OOP is very basic important thing in development today, follow these rules will make your own OOP and design to next level
This tutorial write in Ruby, but you can use for another language
Idea of tutorial show by `rhacker` - in `Ruby VietNam`, I change them to document for easier to learn!

If you have any questions, please make an issues or pull requests if have any interesting things. Every question will update in README.
Let's go!

### 1. Baby
`Who am I? `. You asked yourself.

```ruby
class DateRange
  def overlaps?(other_date_range)
    return true if @start_date = other_date_range.start_date && end_date > other_date_range.end_date
    return true if @start_date > other_date_range.start_date && @start_date  < other_date_range.end_date
    return true if end_date > other_date_range.start_date && end_date < other_date_range.end_date
    return false
  end
end
```

About the logic, it's no problem. But might be you think it's wrong somewhere?
Might be many condition but all return `true`.
But in this case, you shouldn't refactor because logic range too difficult.
 
*Hint:*
 The case may be wrong is `start_date`. Because it's value of time (second), it's change every second, so might be wrong at the time you used it.
 Solution:
 ```ruby
 attr_reader :duration
 def start_date
    @start_date = NIST::AtomicClock.correction_factor
 end
 ```
 And in `overlaps` function, we will use `start_date` obviously `@start_date`. `start_date` is the message for yourself, define start_date of this object, not attribute, need exactly value.
 And `overlaps` function or some people whom implement this no need to know how it's compute exactly.

##### Questions

 You might ask: 'So the meaning of use `start_date` obviously `@start_date` ?'

 Because you need exactly value of time, so start_date is computed attribute. You need to use `start_date` because it will give you exactly time in the time you used it, and `@start_date` don't give you that chance.


### 2. Child
`I promised `.
It's talk about Function( or method). `When I was a child, I promised to do something`.
In design function, you must make sure input types is same. And ouput must be *consitent*, never give `nil` output.

```ruby
class SodaMachine
  def dispense(code, change_inserted)
    soda_type = soda_type_for(code) return nil if soda_type == nil num_sodas = (change_inserted/ soda_type.cost).floor
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
```


Let's see `dispense` function. It's return 3 types of value output: `nil`, `boolean` and `object`. So ... Fail design. Let' rewrite:

```ruby
def dispense(code, change_inserted)
  soda_type = soda_type_for(code)
  return [] if soda_type == nil
  num_sodas = (change_inserted/ soda_type.cost ).floor
  return Array.new(num_sodas) { new_soda(soda_type) }
end
```

Now, return type is Array. If you value is `nil`, you should return an `empty` Array, so if it's nil, return the empty of that type.



### 3. Teenager

```ruby
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
```


Let's see `DateRange` method. It have 3 attributes, and 1 of these can compute from 2 others. In this case, `duration` can equals `end_date - start_date`.
The rule is `You don't want grow up`. Make sure that don't grow up your object, just enough the attributes, don't give any extras. Rewrite it:

```ruby
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
```

`initilize` method accept 2 attributes. `new_with_end_date` method process atribute then callback to `initialize`. `end_date` is computed attribute, you make it become a function.

*Summary*: Find which attribute can computed, make it become a function. It be clearly that is a computed attribute from already atrribute. It's very flexible in test case.



### 4. Adult
`Always say NO`. Say NO with bad dependencies. Look back to `disense` method in *Child* rule.

```ruby
def dispense(code, change_inserted)
  soda_type = soda_type_for(code)
  return [] if soda_type == nil
  num_sodas = (change_inserted/ soda_type.cost ).floor
  return Array.new(num_sodas) { new_soda(soda_type) }
end
```

Think about which value can be bad, wrong input or ... something.
- First, `change_inserted` must be >= 0 ? Because no one put -1 coin to machine.
- Second, `soda_type.cost` might be equals 0.
So write statement to make sure it's not wrong.

```ruby
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
```

Somebody may be told you that : `soda_type.cost` must make sure > 0 in `soda_type` object, so we don't need to check. What do you think?
Yes, that right. `dispense` method control before `soda_type`, but you must make sure `soda_type.cost` > 0 when you create this object.
So idea is `Say NO from beginning`.

```ruby
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
```

Check type first, bussiness logic later.



### 5. Senior
`Who are you?`.
We have 2 objects: `you` and `me`, all these is child of `Person` object. I asked you about your age.
You can answer like this:

```ruby
def age
  if trying_impress?
    return @age + 5
  elsif trying_to_be_teengaer
    return @age - 3
  else
    return @age
  end
end
```

You hidden your age, you only send message to me. So, I also have message, but not like you:

```ruby
def age
# i am honest
  return @age
end
```

1 message give the age, but method of `you` and `me` are different.
Idea is always give simple information is `age`, no give and extras.
Let's make another example, you should be clear:

```ruby
mine_cell = Cell.new_mine
flag_cell = Cell.new_flag
mine_cell.contents = :flag

def choose(cell)
  if cell.contents == :mine
    game_over
  else next_turn
  end
end
```

`cell.contents` get `contents` from `cell`. So what message they want to send there? They want check that cell is really a mine. Rule is `don't give any extras`.

Rewrite it:

```ruby
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
```

Always send message for the other, give exactly they need, `don't give any extras`.




