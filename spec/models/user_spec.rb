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

require 'rails_helper'

RSpec.describe User, type: :model do
  describe "is valid" do
    before(:each) { @user = build(:user) }

    it "with filled attributes" do
      expect{ @user.save }.to change{ User.count }.by(1)
    end

    it "without phone" do
      @user.phone = nil

      expect{ @user.save }.to change{ User.count }.by(1)
    end

  end

  describe "is invalid" do

    context "without" do
      before(:each) do
        @invalid_user = User.new
        @invalid_user.valid?
      end

      it "fio" do
        expect(@invalid_user.errors[:fio]).to include("can't be blank")
      end

      it "email" do
        expect(@invalid_user.errors[:email]).to include("can't be blank")
      end

    end

    context "with" do
      before(:each) do
        @invalid_user = User.new( :fio => "Abc", :email => "a@a.r", :phone => "#{'a' * 20}ex@.com" )
        @invalid_user.valid?
      end

      it "fio < 5 symbols" do
        expect(@invalid_user.errors[:fio]).to include("is too short (minimum is 5 characters)")
      end

      it "email < 6 symbols " do
        expect(@invalid_user.errors[:email]).to include("is too short (minimum is 6 characters)")
      end

      it "phone > 20 symbols" do
        expect(@invalid_user.errors[:phone]).to include("is too long (maximum is 20 characters)")
      end

    end

    context "" do
      before(:each) { @user = build(:user) }

      it "without unique email" do
        @user.save
        user2 = build(:user, :male, email: @user.email.upcase)

        expect{ user2.save }.to_not change{ User.count }
      end

      it "without @ symbol in email" do
        @user.email = "example.com"

        expect{ @user.save }.to_not change{ User.count }
      end

      it "with empty phone" do
        @user.email = ""

        expect{ @user.save }.to_not change{ User.count }
      end

    end
    # it "without password" do

    # end

  end
end
