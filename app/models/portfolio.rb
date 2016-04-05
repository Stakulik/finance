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
  has_many :stocks
  belongs_to :user

  validates :name, presence: true, length: { in: 1..30 }
  validates :user_id, presence: true
  validates :description, length: { in: 1..200 }, if: :description

  accepts_nested_attributes_for :stocks, allow_destroy: true

end
