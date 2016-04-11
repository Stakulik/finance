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

# require 'rails_helper'

# RSpec.describe StocksController, type: :controller do

#   describe "GET #new" do
#     it "returns http success" do
#       get :new
#       expect(response).to have_http_status(:success)
#     end
#   end

#   describe "GET #edit" do
#     it "returns http success" do
#       get :edit
#       expect(response).to have_http_status(:success)
#     end
#   end

# end
