module UserSessionHelper

  def sign_in(user, email = nil, password = nil)
    visit new_user_session_path

    expect(page).to have_text("Вход в аккаунт")

    fill_in "user[email]", :with => email || user.email
    fill_in "user[password]", :with => password || user.password

    click_button('Войти')

    expect(page).to have_text("Вы зашли как #{email || user.email}")
  end

  def sign_in_failed(email, password)
    visit new_user_session_path

    expect(page).to have_text("Вход в аккаунт")

    fill_in "user[email]", :with => email
    fill_in "user[password]", :with => password

    click_button('Войти')

    expect(page).to have_text("Неверный адрес e-mail или пароль")
  end

end