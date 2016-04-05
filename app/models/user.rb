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

class User < ActiveRecord::Base
  has_many :portfolios

  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { in: 6..20 }, 
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :phone, length: { in: 6..20 }, if: :phone
  validates :fio, presence: true, length: { in: 5..30 }
  validates :password, presence: true, length: { in: 6..20 }

  before_save { self.email = email.downcase }

  # если новая запись - выслать письмо

  accepts_nested_attributes_for :portfolios, allow_destroy: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

end
