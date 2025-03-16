require "application_system_test_case"

class RemindersTest < ApplicationSystemTestCase
  def setup
    @contact = contacts(:john_doe)
    @reminder = reminders(:upcoming_reminder)
  end

  test "visiting the reminders index" do
    visit contact_reminders_path(@contact)
    
    assert_selector "h2", text: "Reminders for #{@contact.full_name}"
    assert_selector "h3", text: "Add New Reminder"
    
    # Check for reminder sections
    if @contact.reminders.upcoming.any?
      assert_selector "h3", text: "Upcoming Reminders"
    end
    
    if @contact.reminders.past_due.any?
      assert_selector "h3", text: "Past Due Reminders"
    end
    
    if @contact.reminders.completed.any?
      assert_selector "h3", text: "Completed Reminders"
    end
  end

  test "creating a new reminder" do
    visit contact_reminders_path(@contact)

    fill_in "Title", with: "New Test Reminder"
    # fill_in "Date", with: 1.day.from_now.strftime("%%m-%d-%YT%H:%M")
    fill_in "Description", with: "Test description"
    select "Pending", from: "Status"

    click_on "Create Reminder"

    assert_text "Reminder was successfully created"
    assert_text "New Test Reminder"
  end

  test "updating a reminder's status" do
    visit contact_reminders_path(@contact)

    within "#reminder_#{@reminder.id}" do
      click_on "Complete"
    end

    assert_text "Reminder was successfully updated"
  end

  test "deleting a reminder" do
    visit contact_reminders_path(@contact)

    page.accept_confirm do
      within "#reminder_#{@reminder.id}" do
        click_on "Delete"
      end
    end

    assert_text "Reminder was successfully deleted"
    assert_no_text @reminder.title
  end

  test "viewing reminders on contact show page" do
    visit contact_path(@contact)

    assert_selector "h3", text: "Recent Reminders"
    assert_link "View All Reminders"
    
    within ".reminders-section" do
      if @contact.reminders.any?
        assert_text @reminder.title
      else
        assert_text "No reminders yet"
      end
    end
  end
end 