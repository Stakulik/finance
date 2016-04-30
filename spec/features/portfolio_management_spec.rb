require "rails_helper"

describe "Portfolio management:", :type => :feature do

  describe "" do
    before(:all) { @user = create(:user) }
    before(:each) do
      @user.reload
      @portfolio = create(:portfolio, user: @user)
    end

    scenario "Creating new portfolio" do
      sign_in(@user)

      click_link("Создать портфель")

      click_button("Добавить")

      expect(page).to have_text("Название не может быть пустым")

      fill_in "portfolio[name]", :with => "IT companies"
      fill_in "portfolio[description]", :with => "Some description"

      click_button("Добавить")

      expect(page).to have_text("Портфель IT companies")
    end

    scenario "Editing portfolio" do
      sign_in(@user)

      expect(page).to have_text(@portfolio.name)

      within(".actions") { click_link("Изменить") }

      fill_in "portfolio[name]", :with => ""

      click_button("Сохранить")

      expect(page).to have_text("Название не может быть пустым")

      fill_in "portfolio[name]", :with => "First pocket"
      fill_in "portfolio[description]", :with => "A few words"

      click_button("Сохранить")

      expect(page).to have_text("Ваши портфели")
      expect(page).to have_text("First pocket")
      expect(page).to have_text("A few words")
    end

    scenario "get 404 page for foreign portfolios (show/edit)" do 
      user2 = create(:user, :male)

      sign_in(user2)

      visit portfolio_path(@portfolio.id) # portfolio belongs to other user (@user)

      expect(page).to have_text("Не найдено!")

      visit edit_portfolio_path(@portfolio.id)

      expect(page).to have_text("Не найдено!")

      visit portfolio_path(100500)

      expect(current_path).to eq "/portfolios/100500" # nonexistent portfolio
      expect(page).to have_text("Не найдено!")
    end

  end

  describe "with webkit", js: true  do
    before(:each) do
      @user = create(:user, email: "new@example.com")
      @portfolio = create(:portfolio_with_stocks, stocks_count: 1, user: @user)
    end

    scenario "show graphics only with stocks amount > 0" do
      sign_in(@user)

      click_link(@portfolio.name)

      expect(page).to have_text("Средневзвешенная стоимость портфеля")
      
      within(".actions") { click_link("Изменить") }

      select "0", :from => "stock[amount]"

      click_button("Сохранить")

      expect(page).to_not have_text("Средневзвешенная стоимость портфеля")
    end

    scenario "Getting and deleting portfolio" do
      sign_in(@user)

      click_link(@portfolio.name)

      expect(page).to have_text("Портфель #{@portfolio.name}")
      
      within("nav") { click_link("Портфели") }

      expect(page).to have_text("Ваши портфели")

      within(".actions") { page.accept_confirm { click_link("Удалить") } }

      expect(page).to have_text("у вас нет созданных портфелей")
    end

  end

end
