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
