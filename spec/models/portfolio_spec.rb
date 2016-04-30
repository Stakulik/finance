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

describe Portfolio, type: :model do

  describe "is valid" do
    before(:each) { @portfolio = build(:portfolio, user_id: 1) }

    it "with filled attributes" do
      expect{ @portfolio.save }.to change{ Portfolio.count }.by(1)
    end

  end

  describe "is invalid" do
    before(:each) { (@invalid_portfolio = Portfolio.new).valid? }

    it "without name" do
      expect(@invalid_portfolio.errors[:name]).to include("не может быть пустым")
    end

    it "without user_id" do
      expect(@invalid_portfolio.errors[:user_id]).to include("не может быть пустым")
    end

  end

end
