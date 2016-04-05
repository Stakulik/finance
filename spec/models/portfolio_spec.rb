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

require 'rails_helper'

RSpec.describe Portfolio, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
