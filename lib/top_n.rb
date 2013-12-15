##
# This class tracks the top (or bottom) N values added.  Discard the rest.
class TopN
  attr_reader :maxsize
  attr_reader :direction
  attr_reader :size
  attr_reader :minimum_key
  attr_reader :data

  def initialize(options = {})
    options = {
      maxsize: 100,
      direction: :top,
    }.merge(options)

    @maxsize = options[:maxsize]
    @direction = options[:direction]
    @data = {}
    @size = 0
    @minimum_key = nil
  end

  def add(key, value)
    @minimum_key ||= key

    if @size >= @maxsize
      return nil if key < @minimum_key

      @data.delete(@minimum_key)
    end

    unless @data.has_key?key
      @data[key] = []
      @size += 1 if @size < @maxsize
    end

    @data[key] << value

    @minimum_key = [ @minimum_key, key ].min

    @data[key]
  end

  def find(key)
    @data[key]
  end

  def keys
    @data.keys
  end
end
