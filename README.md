Berater
======
A simple rate limiter, backed by Redis


#### Install
```gem install berater```


#### Usage
```ruby
require 'berater'
require 'redis'

Berater.configure Redis.new

begin
  5.times do
    puts Berater.incr 'hi', 2, 10
  end
rescue Berater::Overloaded; end

```

----
![Gem](https://img.shields.io/gem/dt/berater?style=plastic)
[![codecov](https://codecov.io/gh/dpep/berater_rb/branch/master/graph/badge.svg?token=1L7OD80182)](https://codecov.io/gh/dpep/berater_rb)
