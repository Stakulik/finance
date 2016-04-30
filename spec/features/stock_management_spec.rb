require "rails_helper"

describe "Stock management:", :type => :feature do
  before(:all) { @user = create(:user_with_portfolio) }
  before(:each) { @user.reload }

  scenario "Creating new stock" do
    sign_in(@user)

    expect(page).to_not have_text("у вас нет созданных портфелей")

    click_link("Первый портфель")

    click_link("Добавить акцию")

    click_button("Добавить")

    expect(page).to have_text("Название не может быть пустым")

    fill_in "stock[name]", :with => "MSFT"
    select "19", :from => "stock[amount]"

    click_button("Добавить")

    expect(page).to have_text("Ваши акции:")
    expect(page).to have_text("Количество: 19")
  end

  scenario "get 404 page for foreign stocks (edit)" do 
    stock = create(:stock, portfolio_id: 1)
    user2 = create(:user, :male)

    sign_in(user2)

    visit edit_stock_path(stock.id) # stock belongs to other user (@user)

    expect(page).to have_text("Не найдено!")
  end

  # must be last, because for webkit is used truncation
  scenario "Editing and deleting stock", js: true do
    portfolio = create(:portfolio, name: "Убыточные акции", user: @user )
    stock = create(:stock, portfolio: portfolio)

    sign_in(@user)

    click_link(portfolio.name)

    expect(page).to have_text(stock.name)

    within(".actions") { click_link("Изменить") }

    fill_in "stock[name]", :with => ""

    click_button("Сохранить")

    expect(page).to have_text("Название не может быть пустым")

    fill_in "stock[name]", :with => "OLOLO"
    select "17", :from => "stock[amount]"

    click_button("Сохранить")

    expect(page).to have_text("OLOLO")
    expect(page).to have_text("Количество: 17")

    within(".actions") { page.accept_confirm { click_link("Удалить") } }

    expect(page).to have_text("в портфеле нет акций")
  end

end
