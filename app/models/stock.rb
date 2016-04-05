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

class Stock < ActiveRecord::Base
  belongs_to :portfolio

  validates :name, presence: true, length: { in: 1..30 }
  validates :portfolio_id, presence: true

  before_save { self.name = name.upcase } 

end
