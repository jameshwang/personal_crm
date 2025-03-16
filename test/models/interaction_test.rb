require "test_helper"

class InteractionTest < ActiveSupport::TestCase
  def setup
    @interaction = interactions(:recent_call)
  end

  test "should be valid" do
    assert @interaction.valid?
  end

  test "interaction_type should be present" do
    @interaction.interaction_type = nil
    assert_not @interaction.valid?
  end

  test "date should be present" do
    @interaction.date = nil
    assert_not @interaction.valid?
  end

  test "interaction_type should be one of the allowed types" do
    valid_types = ['Call', 'Email', 'Meeting', 'Video Call']
    valid_types.each do |valid_type|
      @interaction.interaction_type = valid_type
      assert @interaction.valid?, "#{valid_type.inspect} should be valid"
    end

    invalid_types = ['SMS', 'Chat', '', nil]
    invalid_types.each do |invalid_type|
      @interaction.interaction_type = invalid_type
      assert_not @interaction.valid?, "#{invalid_type.inspect} should be invalid"
    end
  end

  test "should belong to contact" do
    assert_respond_to @interaction, :contact
  end

  test "should order by date in descending order" do
    first_interaction = interactions(:recent_call)
    second_interaction = interactions(:email_interaction)
    assert_operator first_interaction.date, :>, second_interaction.date
  end
end
