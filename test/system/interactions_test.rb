require "application_system_test_case"

class InteractionsTest < ApplicationSystemTestCase
  def setup
    @contact = contacts(:john_doe)
    @interaction = interactions(:recent_call)
  end

  test "visiting the interactions index" do
    visit contact_interactions_path(@contact)
    
    assert_selector "h1", text: "Interactions with #{@contact.full_name}"
    assert_selector "h3", text: "Record New Interaction"
    assert_selector "h3", text: "Past Interactions"
  end

  test "creating a new interaction" do
    visit contact_interactions_path(@contact)

    select "Call", from: "Interaction type"
    fill_in "Date", with: Time.current.strftime("%Y-%m-%dT%H:%M")
    fill_in "Notes", with: "Test interaction notes"

    click_on "Record Interaction"

    assert_text "Interaction was successfully recorded"
    assert_text "Test interaction notes"
  end

  test "deleting an interaction" do
    visit contact_interactions_path(@contact)

    page.accept_confirm do
      within "#interaction_#{@interaction.id}" do
        find("button[title='Delete interaction']").click
      end
    end

    assert_text "Interaction was successfully deleted"
    assert_no_text @interaction.notes
  end

  test "viewing interactions on contact show page" do
    visit contact_path(@contact)

    assert_selector "h3", text: "Recent Interactions"
    assert_link "View All Interactions"
    
    within ".interactions-section" do
      if @contact.interactions.any?
        assert_text @interaction.interaction_type
      else
        assert_text "No interactions recorded yet"
      end
    end
  end

  test "interaction type icons are displayed" do
    visit contact_interactions_path(@contact)

    within "#interaction_#{@interaction.id}" do
      assert_selector "svg.text-indigo-600"
    end
  end
end 