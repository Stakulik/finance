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

describe Stock, type: :model do
  
  describe "is valid" do
    before(:each) { @stock = build(:stock, portfolio_id: 1)  }

    it "with filled attributes" do
      expect{ @stock.save }.to change{ Stock.count }.by(1)
    end

  end

  describe "is invalid" do
    before(:each) { (@invalid_stock = Stock.new).valid? }

    it "without name" do
      expect(@invalid_stock.errors[:name]).to include("не может быть пустым")
    end

    it "without portfolio_id" do
      expect(@invalid_stock.errors[:portfolio_id]).to include("не может быть пустым")
    end
    
  end

  it "will be removed with portfolio" do
    portfolio = create(:portfolio_with_stocks)

    expect{ portfolio.destroy }.to change{ Stock.count }
  end 

end
