user = User.create(:fio => "John Galt", :email => "galt@example.com",
                   :password => "qazwsx", :password_confirmation => "qazwsx")

portfolio = user.portfolios.create(:name => "IT компании", :description => "Несколько акций лидеров рынка")

portfolio.stocks.create([ {:name => 'FB', :amount => 1},
                          {:name => 'HTCH', :amount => 1},
                          {:name => 'MSFT', :amount => 1},
                          {:name => 'HPE', :amount => 1},
                          {:name => 'VOD', :amount => 1}
                        ])
