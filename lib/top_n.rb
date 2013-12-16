##
# This class tracks the top (or bottom) N values for a set of keys.
#
# As keys and values are added, only the largest (or smallest) keys will
# be recorded.  As larger (or smaller) keys are added, unneeded items are
# removed.
#
# Keys may be any object that is comparable with < and >.  Values may be
# any object, and are not processed beyond appending them to an internal
# list.
#
# @note
#   Note that while the number of keys is restricted, the values are not.
#   This can cause memory issues if many values are added to the same key.
#   If this is the type of data you are tracking, you may need a different
#   solution.
class TopN
  # The maxinum number of keys which will be tracked.
  # @return [Fixnum] the configured maximum number of keys to be tracked.
  attr_reader :maxkeys

  # The configured direction.
  # @return [Symbol] either :top or :bottom.
  attr_reader :direction

  # The current number of keys we are tracking.
  # @return [FixNum] the count, which will be 0 up to :maxkeys.
  attr_reader :keycount

  # The current value of the minimum (:top) or maximum (:bottom) key.
  # @return [Object] the threshold key.
  attr_reader :threshold_key

  # The currently tracked data as one blob.  This is tied to the
  # current implementation, so its use is not recommended.
  # @return [Hash] the internal data structure containing the keys and
  #  values.  The keys to the returned Hash are the tracked keys, and
  #  the values at those keys is the list of values.
  attr_reader :data

  ##
  # Create a new TopN object.  Options available:
  #
  # @param [Hash] options the options used to configure the TopN object.
  #
  # @option options [Fixnum] :maxkeys The maximum number of keys to track.
  #  Must be a positive Fixnum.  Defaults to 100.
  #
  # @option options [Symbol] :direction Configure the direction.
  #  If this is :top, the largest keys will be maintained.  If :bottom,
  #  the smallest keys will be maintained.  Any other value throws an
  #  exception.
  #  Defaults to :top.
  #
  # @raise [ArgumentError] if an invalid value is detected for any option.
  #
  # @example Create with default options
  #   topn = TopN.new
  #
  # @example Create with a maximum size of 10, and track smaller values
  #   topn = TopN.new(maxkeys: 10, direction: :bottom)
  #
  def initialize(options = {})
    options = {
      maxkeys: 100,
      direction: :top,
    }.merge(options)

    options.keys.each do |opt|
      unless [:maxkeys, :direction].include?opt
        raise ArgumentError.new("invalid option #{opt}")
      end
    end

    @maxkeys = options[:maxkeys]
    @direction = options[:direction]
    @keycount = 0
    @threshold_key = nil

    unless [:top, :bottom].include?(@direction)
      raise ArgumentError.new("direction must be :top or :bottom")
    end

    unless @maxkeys.is_a?Fixnum
      raise ArgumentError.new("maxkeys must be a Fixnum")
    end

    if @maxkeys <= 0
      raise ArgumentError.new("maxkeys must be >= 1")
    end
  end

  ##
  # Add a key, value pair.
  #
  # @param [Object] key the key, which must be compariable with < and >.
  # @param [Object] value the value, which is added to the key's list of
  #  values.  Adding the same value to a key multiple times results in
  #  duplicate values being recorded.
  #
  # If the key already exists, the value will be appended to the existing list
  # of values at that key.
  #
  # If an existing (key, value) is permitted, and will result in the list of
  # values at that key having the same value multiple times.
  #
  # @return [Array] if the value was added to the key's list.
  #
  # @return [nil] if the value was not added because the key is too small or
  # large to be tracked.
  def add(key, value)
    if @direction == :top
      add_top(key, value)
    else
      add_bottom(key, value)
    end
  end

  ##
  # Find and return the list of values for a key.
  #
  # @return [Array<Object>] the list of values for 'key'.
  #
  # @return [nil] if the key does not exist.
  def find(key)
    @data[key]
  end

  ##
  # Return the list of currently tracked keys.
  #
  # @return [Array<Object>] the list of values for this key.
  #  Order is not guaranteed to match the oder which they were added.
  def keys
    @data.keys
  end

  private

  ##
  # Add a (key, value) when the direction is :top.
  def add_top(key, value)
    @threshold_key ||= key

    if @data.has_key?key
      @data[key] << value
    else
      if @keycount >= @maxkeys
        return nil if key < @threshold_key
        @data.delete(@threshold_key)
        @keycount -= 1
        @threshold_key = @data.keys.min
      end
      @data[key] = [ value ]
      @keycount += 1
      @threshold_key = key if key < @threshold_key
    end

    @data[key]
  end

  ##
  # Add a (key, value) when the direction is :bottom.
  def add_bottom(key, value)
    @threshold_key ||= key

    if @data.has_key?key
      @data[key] << value
    else
      if @keycount >= @maxkeys
        return nil if key > @threshold_key
        @data.delete(@threshold_key)
        @keycount -= 1
        @threshold_key = @data.keys.max
      end
      @data[key] = [ value ]
      @keycount += 1
      @threshold_key = key if key > @threshold_key
    end

    @data[key]
  end
end
