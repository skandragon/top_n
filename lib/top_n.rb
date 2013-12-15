##
# This class tracks the top (or bottom) N values added.  Discard the rest.
class TopN
  attr_reader :maxsize
  attr_reader :direction
  attr_reader :size
  attr_reader :threshold_key
  attr_reader :data

  def initialize(options = {})
    options = {
      maxsize: 100,
      direction: :top,
    }.merge(options)

    unless [:top, :bottom].include?options[:direction]
      raise ArgumentError.new("direction must be :top or :bottom")
    end

    @maxsize = options[:maxsize]
    @direction = options[:direction]
    @data = {}
    @size = 0
    @threshold_key = nil
  end

  def add(key, value)
    if @direction == :top
      add_top(key, value)
    else
      add_bottom(key, value)
    end
  end

  def add_top(key, value)
    @threshold_key ||= key

    if @size >= @maxsize
      return nil if key < @threshold_key
      @data.delete(@threshold_key)
    end

    unless @data.has_key?key
      @data[key] = []
      @size += 1 if @size < @maxsize
    end

    @data[key] << value

    @threshold_key = key if key < @threshold_key

    @data[key]
  end

  def add_bottom(key, value)
    @threshold_key ||= key

    if @size >= @maxsize
      return nil if key > @threshold_key
      @data.delete(@threshold_key)
    end

    unless @data.has_key?key
      @data[key] = []
      @size += 1 if @size < @maxsize
    end

    @data[key] << value

    @threshold_key = key if key > @threshold_key

    @data[key]
  end

  def find(key)
    @data[key]
  end

  def keys
    @data.keys
  end
end
