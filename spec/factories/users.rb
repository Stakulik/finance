# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  fio        :string(30)       not null
#  email      :string(20)       not null
#  phone      :string(20)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :user do
    fio   "Агеев Иван Федорович"
    email "van@example.com"
    phone "8 931 123 45 67"

    trait :male do
      fio   "Сигов Олег Андреевич"
      email "sig@example.com"
      phone "8 905 222 33 14"
    end

  end
end
