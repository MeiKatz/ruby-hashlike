# module for hash-like objects

My problem was that I wanted to create classes with the same interface as Ruby core hashes. What I don't wanted was to implement each method of Ruby `Hash` each time when I needed somelike this. So I wrote this Ruby module with only one method I have to keep an eye on to implement hash-like classes.

## How to
You only have to include the module and the module `Enumerable` and you're ready to go.
```ruby
class Hashy
  include Enumerable
  include Hashlike
end
```
Neat. But now we only have a class that behaves like a hash without being an instance of `Hash` - not really useful. Let's build a translation class!
```ruby
class GermanTranslation
  include Enumerable
  include Hashlike
  
  attr_reader :orig
  
  def initialize(orig)
    @orig = orig
  end
  
  def to_h
    orig.reduce({}) do |memo, (key, value)|
      key = translate_to_de(key)
      memo[key] = value if key
      memo
    end
  end

  def [](key)
    key = translate_to_en(key)
    super(key) if key
  end

  def []=(key, value)
    key = translate_to_en(key)
    super(key, value) if key
  end

  private
  
  # this is the most important method because all other methods are implemented via this method
  def _hash
    orig
  end

  def translate_to_de(key)
    case key
    when :first_name then :vorname
    when :last_name then :nachname
    when :age then :alter
    end
  end

  def translate_to_en(key)
    case key
    when :vorname then :first_name
    when :nachname then :last_name
    when :alter then :age
    end
  end
end

en = { first_name: "Zepartzat", last_name: "Gozinto", age: 42 }
de = GermanTranslation.new(en)

de[:vorname] # => "Zepartzat"
de.to_h # => { vorname: "Zepartzat", nachname: "Gozinto", alter: 42 }

de[:vorname] = "Foobarz"
de.to_h # => { vorname: "Foobarz", nachname: "Gozinto", alter: 42 }
de.orig # => { first_name: "Foobarz", last_name: "Gozinto", age: 42 }
```
Neat.
