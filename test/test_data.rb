require 'helper'

class TestData < Minitest::Test
  def test_data_is_empty_on_create
    topn = TopN.new(nil, maxkeys: 2)
    assert_equal({}, topn)
  end

  def test_data
    topn = TopN.new(nil, maxkeys: 2)
    topn[1] = 1
    topn[2] = 2
    topn[3] = 3
    assert_equal([ [2, [2]], [3, [ 3 ]] ], topn.sort)
  end

  def test_keys
    topn = TopN.new(nil, maxkeys: 2)
    topn[1] = 1
    topn[2] = 2
    topn[3] = 3
    assert_equal [2, 3], topn.keys.sort
  end
end
