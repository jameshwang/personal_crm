require "test_helper"

class ReminderTest < ActiveSupport::TestCase
  def setup
    @reminder = reminders(:upcoming_reminder)
  end

  test "should be valid" do
    assert @reminder.valid?
  end

  test "title should be present" do
    @reminder.title = nil
    assert_not @reminder.valid?
  end

  test "date should be present" do
    @reminder.date = nil
    assert_not @reminder.valid?
  end

  test "status should be present" do
    @reminder.status = nil
    assert_not @reminder.valid?
  end

  test "status should be either pending or completed" do
    valid_statuses = ['pending', 'completed']
    valid_statuses.each do |valid_status|
      @reminder.status = valid_status
      assert @reminder.valid?, "#{valid_status.inspect} should be valid"
    end

    invalid_statuses = ['invalid', 'in_progress', '']
    invalid_statuses.each do |invalid_status|
      @reminder.status = invalid_status
      assert_not @reminder.valid?, "#{invalid_status.inspect} should be invalid"
    end
  end

  test "should belong to contact" do
    assert_respond_to @reminder, :contact
  end

  test "upcoming scope should return future pending reminders" do
    upcoming_reminders = Reminder.upcoming
    upcoming_reminders.each do |reminder|
      assert reminder.date > Time.current
      assert_equal 'pending', reminder.status
    end
  end

  test "past_due scope should return past pending reminders" do
    past_due_reminders = Reminder.past_due
    past_due_reminders.each do |reminder|
      assert reminder.date < Time.current
      assert_equal 'pending', reminder.status
    end
  end

  test "completed scope should return completed reminders" do
    completed_reminders = Reminder.completed
    completed_reminders.each do |reminder|
      assert_equal 'completed', reminder.status
    end
  end

  test "past_due? should return true for past pending reminders" do
    @reminder.date = 1.day.ago
    @reminder.status = 'pending'
    assert @reminder.past_due?
  end

  test "upcoming? should return true for future pending reminders" do
    @reminder.date = 1.day.from_now
    @reminder.status = 'pending'
    assert @reminder.upcoming?
  end

  test "pending? should return true for pending reminders" do
    @reminder.status = 'pending'
    assert @reminder.pending?
  end

  test "completed? should return true for completed reminders" do
    @reminder.status = 'completed'
    assert @reminder.completed?
  end
end
