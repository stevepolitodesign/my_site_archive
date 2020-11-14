require 'test_helper'

class PlanTest < ActiveSupport::TestCase
  def setup
    @plan = Plan.new(name: "name", price_in_cents: 1000, processor_id: "123_abc", )
  end
  
  test "should be valid" do
    assert @plan.valid?
  end

  test "should have a name" do
    @plan.name = ""
    assert_not @plan.valid?
  end

  test "should set uuid" do
    @plan.save
    assert_not_nil @plan.reload.uuid
  end
end
