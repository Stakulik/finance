require "rails_helper"

describe "User management:", :type => :feature do

  scenario "register new user" do
    visit new_user_registration_path

    expect(page).to have_text("Регистрация нового пользователя")

    click_button("Зарегистрироваться")

    expect(page).to have_text("E-mail имеет неверное значение")
    expect(page).to have_text("Пароль не может быть пустым")

    fill_in "user[email]", :with => "galt@example.com"
    fill_in "user[password]", :with => "qazwsx111"
    fill_in "user[password_confirmation]", :with => "qazwsx"

    click_button("Зарегистрироваться")

    expect(page).to have_text("Пароль и подтверждение должны совпадать")

    fill_in "user[password]", :with => "qazwsx"
    fill_in "user[password_confirmation]", :with => "qazwsx"

    click_button("Зарегистрироваться")

    expect(page).to have_text("Вы зашли как galt@example.com")
  end

  scenario "stop authentication with nonexistent email" do

    sign_in_failed("lol@example.com", "password")

  end

  describe "" do
    before(:all) { @user = create(:user) }
    before(:each) { @user.reload }

    scenario "user is redirected without authentication" do
      portfolio = create(:portfolio, user_id: @user.id )

      sign_in(@user)

      expect(page).to have_text(portfolio.name)

      visit portfolio_path(portfolio.id)

      expect(page).to have_text("Портфель #{portfolio.name}")

      click_link("Выйти")

      expect(current_path).to eq "/"

      visit portfolios_path(@user.id)

      expect(page).to have_text("Вам необходимо войти в систему")

      visit portfolio_path(portfolio.id)

      expect(page).to have_text("Вам необходимо войти в систему")

      visit portfolio_path(100500) # random number

      expect(page).to have_text("Вам необходимо войти в систему")
    end

    scenario "change user's password" do
      sign_in(@user)

      within("nav") { click_link(@user.email) }

      expect(page).to have_text("Редактирование информации")

      fill_in "user[password]", :with => "newpass"
      fill_in "user[password_confirmation]", :with => "newpass"
      fill_in "user[current_password]", :with => @user.password

      click_button("Изменить")

      expect(current_path).to eq "/"
      expect(page).to have_text("Вы зашли как #{@user.email}")
    end

    scenario "change user's email" do
      sign_in(@user)

      within("nav") { click_link(@user.email) }

      expect(page).to have_text("Редактирование информации")

      fill_in "user[email]", :with => "new_mail@example.com"
      fill_in "user[current_password]", :with => @user.password

      click_button("Изменить")

      expect(page).to have_text("Вы зашли как new_mail@example.com")
    end

    # must be last, because for webkit is used truncation
    scenario "remove user's account", js: true do
      sign_in(@user)

      within("nav") { click_link(@user.email) }

      expect(page).to have_text("Редактирование информации")

      page.accept_confirm { click_button "Удалить мой аккаунт" }

      expect(page).to_not have_text("Вы зашли как #{@user.email}")

      sign_in_failed(@user.email, @user.password)
    end

  end

end