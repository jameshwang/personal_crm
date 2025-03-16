require "test_helper"

class ContactTest < ActiveSupport::TestCase
  def setup
    @contact = contacts(:john_doe)
  end

  test "should be valid" do
    assert @contact.valid?
  end

  test "first_name should be present" do
    @contact.first_name = nil
    assert_not @contact.valid?
  end

  test "last_name should be present" do
    @contact.last_name = nil
    assert_not @contact.valid?
  end

  test "email should be present" do
    @contact.email = nil
    assert_not @contact.valid?
  end

  test "email should be unique" do
    duplicate_contact = @contact.dup
    duplicate_contact.email = @contact.email
    @contact.save
    assert_not duplicate_contact.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @contact.email = valid_address
      assert @contact.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @contact.email = invalid_address
      assert_not @contact.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "full_name should combine first_name and last_name" do
    assert_equal "John Doe", @contact.full_name
  end

  test "should have many reminders" do
    assert_respond_to @contact, :reminders
  end

  test "should have many interactions" do
    assert_respond_to @contact, :interactions
  end

  test "should destroy associated reminders when destroyed" do
    initial_count = @contact.reminders.count
    @contact.reminders.create!(title: "Test Reminder", date: Time.current, status: "pending")
    assert_difference('Reminder.count', -(initial_count + 1)) do
      @contact.destroy
    end
  end

  test "should destroy associated interactions when destroyed" do
    initial_count = @contact.interactions.count
    @contact.interactions.create!(interaction_type: "Call", date: Time.current)
    assert_difference('Interaction.count', -(initial_count + 1)) do
      @contact.destroy
    end
  end
end
