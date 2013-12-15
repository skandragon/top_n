##
# This class tracks the top (or bottom) N values added.  Discard the rest.
class TopN
  attr_reader :maxsize
  attr_reader :direction

  def initialize(options = {})
    options = {
      maxsize: 100,
      direction: :top,
    }.merge(options)

    @maxsize = options[:maxsize]
    @direction = options[:direction]
  end
end
