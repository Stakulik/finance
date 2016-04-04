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

class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { in: 6..20 }, 
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :phone, length: { in: 6..20 }, if: :phone
  validates :fio, presence: true, length: { in: 5..30 }

  before_save { self.email = email.downcase }

end
