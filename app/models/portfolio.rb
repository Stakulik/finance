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

class Portfolio < ActiveRecord::Base
  include QuotesManipulation

  has_many :stocks, :dependent => :destroy
  belongs_to :user

  validates :name, presence: true, length: { in: 1..30 }
  validates :user_id, presence: true
  validates :description, length: { in: 0..200 }

end
