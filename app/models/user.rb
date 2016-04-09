# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  fio                    :string(30)       default(""), not null
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
  has_many :portfolios, :dependent => :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { in: 6..20 }, 
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, :password_confirmation, presence: true, length: { in: 6..20 }, if: :password
  validates_confirmation_of :password

  before_save { self.email = email.downcase }


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

end
