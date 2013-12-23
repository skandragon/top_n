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
class TopN < Hash
  # The maxinum number of keys which will be tracked.
  # @return [Fixnum] the configured maximum number of keys to be tracked.
  attr_reader :maxkeys

  # The configured direction.
  # @return [Symbol] either :top or :bottom.
  attr_reader :direction

  # The current value of the minimum (:top) or maximum (:bottom) key.
  # @return [Object] the threshold key.
  attr_reader :threshold_key

  alias_method :super_store, :store
  alias_method :super_bracket_assign, :[]=
  alias_method :super_bracket, :[]

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
  def initialize(default = nil, options = {})
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

    super(default)
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
  # @return [Object] the value passed in.  This will be returned even if
  # the value is not added because there are too many keys already present.
  def store(key, value)
    @threshold_key ||= key

    if has_key?key
      fetch(key) << value
    else
      if size >= @maxkeys
        return value if compare_to_threshold(key)
        delete(@threshold_key)
        adjust_threshold
      end
      super_store(key, [ value ])
      @threshold_key = key if compare_to_threshold(key)
    end

    value
  end

  # Behave like #store, with the same semantics.
  def []=(key, value)
    store(key, value)
  end

  private

  def compare_to_threshold(key)
    if @direction == :top
      key < @threshold_key
    else
      key > @threshold_key
    end
  end

  def adjust_threshold
    if @direction == :top
      @threshold_key = keys.min
    else
      @threshold_key = keys.max
    end
  end

end
