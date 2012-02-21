module IntegrationHelper
  def login(user)
    visit login_path
    fill_in('Email', with: user.email)
    fill_in('Password', with: user.password)
    click_button('user_session_submit')
  end

  def logout
    user_session = UserSession.find
    user_session.destroy if user_session.present?
  end
end
