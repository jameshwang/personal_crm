require "test_helper"

module Api
  class RemindersControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
      @other_user = users(:two)
      @reminder = reminders(:one)
      @reminder.update(user: @user)
    end

    test "should get index" do
      get api_reminders_url, headers: auth_headers(@user), as: :json
      assert_response :success
    end

    test "should get filtered reminders" do
      get api_reminders_url, params: { status: 'pending' }, headers: auth_headers(@user), as: :json
      assert_response :success
    end

    test "should create reminder" do
      assert_difference('Reminder.count') do
        post api_reminders_url,
             params: { reminder: { 
               title: 'New Reminder', 
               date: Time.current, 
               status: 'pending',
               contact_id: contacts(:one).id 
             } },
             headers: auth_headers(@user),
             as: :json
      end

      assert_response :success
      assert_equal 'New Reminder', JSON.parse(response.body)['data']['reminder']['title']
    end

    test "should create reminder without contact" do
      assert_difference('Reminder.count') do
        post api_reminders_url,
             params: { reminder: { 
               title: 'New Reminder', 
               date: Time.current,
               status: 'pending'
             } },
             headers: auth_headers(@user),
             as: :json
      end

      assert_response :success
      assert_equal 'New Reminder', JSON.parse(response.body)['data']['reminder']['title']
    end

    test "should show reminder" do
      get api_reminder_url(@reminder), headers: auth_headers(@user), as: :json
      assert_response :success
    end

    test "should update reminder" do
      patch api_reminder_url(@reminder),
            params: { reminder: { title: 'Updated Title' } },
            headers: auth_headers(@user),
            as: :json
      assert_response :success
      @reminder.reload
      assert_equal 'Updated Title', @reminder.title
    end

    test "should destroy reminder" do
      assert_difference('Reminder.count', -1) do
        delete api_reminder_url(@reminder), headers: auth_headers(@user), as: :json
      end

      assert_response :success
    end

    test "should not access other user's reminder" do
      other_reminder = reminders(:two)
      other_reminder.update(user: @other_user)
      
      get api_reminder_url(other_reminder), headers: auth_headers(@user), as: :json
      assert_response :not_found
    end
  end
end 