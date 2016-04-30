# == Schema Information
#
# Table name: stocks
#
#  id           :integer          not null, primary key
#  name         :string(30)       not null
#  amount       :integer          default(0)
#  portfolio_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :stock do
    name    "AAPL"
    amount  1
    portfolio

    trait :fb do
      name "FB"
    end

    trait :htch do
      name "HTCH"
    end

    trait :msft do
      name "MSFT"
    end

  end
end