# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  fio                    :string(30)       not null
#  email                  :string(20)       not null
#  phone                  :string(20)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
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
