module Hashlike
  # @overwrite
  def to_h
    @_hash ||= {}
  end

  def ==(other)
    other.respond_to?(:to_h) && other.to_h == self._hash
  end

  alias_method :eql?, :==

  def [](key)
    _hash[key]
  end

  def []=(key, value)
    _hash[key] = value
  end

  def assoc(obj)
    _hash.assoc(obj)
  end

  def clear
    _hash.clear
    self
  end

  def compare_by_identity
    _hash.compare_by_identity
    self
  end

  def compare_by_identity?
    _hash.compare_by_identity?
  end

  def delete(key, &block)
    _hash.delete(key, &block)
  end

  def delete_if(&block)
    if block_given?
      instance = self

      each do |key, value|
        instance.delete(key) if block.call(key, value)
      end

      self
    else
      each
    end
  end

  def each(&block)
    _hash.each(&block)
  end

  def each_key(&block)
    if block_given?
      keys.each do |key|
        block.call(key)
      end

      self
    else
      Enumerator.new(keys)
    end
  end

  alias :each_pair :each

  def each_value(&block)
    if block_given?
      values.each do |value|
        block.call(value)
      end

      self
    else
      Enumerator.new(values)
    end
  end

  def empty?
    _hash.empty?
  end

  def fetch(key, *rest, &block)
    if self.key?(key)
      self.key(key)
    elsif block_given?
      block.call(key)
    elsif rest.count == 1
      rest[0]
    else
      fail KeyError, "key not found: #{key}"
    end
  end

  def flatten(*rest)
    self.class.new(_hash.flatten(*rest))
  end

  def hash
    _hash.hash
  end

  def inspect
    _hash.inspect
  end

  def invert
    self.class.new(_hash.invert)
  end

  def keep_if(&block)
    if block_given?
      instance = self

      each do |key, value|
        instance.delete(key) unless block.call(key, value)
      end

      self
    else
      each
    end
  end

  def key(value)
    _hash.select { |key, val| val == value }.first.keys.first
  end

  def key?(key)
    _hash.key?(key)
  end

  alias :has_key? :key?
  alias :include? :key?
  alias :member? :key?

  def keys
    _hash.select { |key, value| key?(key) }.to_h.keys
  end

  def length
    _hash.length
  end

  def merge(other_hashlike, &block)
    self.class.new(_hash.merge(other_hashlike, &block))
  end

  def merge!(other_hashlike, &block)
    _hash.merge!(other_hashlike, &block)
    self
  end

  def rassoc(obj)
    _hash.rassoc(obj)
  end

  def rehash
    self.class.new(_hash.rehash)
  end

  def reject(&block)
    if block_given?
      self.class.new(_hash.reject(&block))
    else
      each
    end
  end

  def reject!(&block)
    if block_given?
      _hash.reject!(&block)
      self
    else
      each
    end
  end

  def replace(other_hashlike)
    _hash.replace(other_hashlike)
    self
  end

  def select(&block)
    if block_given?
      self.class.new(_hash.select(&block))
    else
      each
    end
  end

  def select!(&block)
    if block_given?
      _hash.select!(&block)
      self
    else
      each
    end
  end

  def shift
    unless empty?
      _hash.shift
    end
  end

  def size
    _hash.size
  end

  def store(key, value)
    self[key] = value
    self
  end

  def to_a
    _hash.to_a
  end

  def to_hash
    self
  end

  def to_s
    _hash.to_s
  end

  def update(other_hashlike, &block)
    _hash.merge!(other_hashlike, &block)
    self
  end

  def value?(value)
    _hash.value?(value)
  end

  alias :has_value? :value?

  def values
    _hash.select { |key, value| value?(value) }.to_h.values
  end

  def values_at(*rest)
    instance = self
    rest.map { |key| instance[key] }
  end

  def _hash
    to_h
  end
end
