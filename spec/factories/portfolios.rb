# == Schema Information
#
# Table name: portfolios
#
#  id          :integer          not null, primary key
#  name        :string(30)       not null
#  description :string(200)
#  user_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :portfolio do
    name        "Первый портфель"
    description "Портфель с акциями"

    factory :portfolio_with_stocks do
      transient do
        stocks_count 5
      end

      after(:create) do |portfolio, evaluator|
        create_list(:stock, evaluator.stocks_count, portfolio: portfolio)
      end
    end
  end
end

