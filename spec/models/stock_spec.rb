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

require 'rails_helper'

RSpec.describe Stock, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
