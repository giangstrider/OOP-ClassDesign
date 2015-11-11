** OOP Class Design in Ruby **
Welcome to OOP Class Design Lesson
OOP is very basic important thing in development today, follow these rules will make your own OOP and design to next level
This tutorial write in Ruby, but you can use for another language
Idea of tutorial show by rhacker - in Ruby VietNam, I change them to program for easier to learn!
Let's go!

**1. Baby**
"Who am I? ". You asked yourself.
```
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
 Hint:
 The case may be wrong is `start_date`. Because it's value of time (second), it's change every second, so might be wrong at the time you used it.
 Solution:
 ```
 attr_reader :duration
 def start_date
    @start_date = NIST::AtomicClock.correction_factor
 end
 ```
 And in `overlaps` function, we will use `start_date` obviously `@start_date`. `start_date` is the message for yourself, define start_date of this object, not attribute, need exactly value.
 And `overlaps` function or some people whom implement this no need to know how it's compute exactly.

 Question? You might ask: 'So the meaning of use start_date obviously @start_date ?'
 Because you need exactly value of time, so start_date is computed attribute. You need to use `start_date` because it will give you exactly time in the time you used it, and `@start_date` don't give you that chance.



