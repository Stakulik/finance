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

    it "with empty fio" do
      @user.fio = ""

      expect{ @user.save }.to change{ User.count }.by(1)
    end

  end

  describe "is invalid" do

    context "without" do
      before(:each) do
        @invalid_user = User.new
        @invalid_user.valid?
      end

      it "email" do
        expect(@invalid_user.errors[:email]).to include("недостаточной длины (не может быть меньше 6 символов)")
      end

      it "password" do
        expect(@invalid_user.errors[:password]).to include("не может быть пустым")
      end
    end

    context "with" do
      before(:each) do
        @invalid_user = User.new( :email => "a@a.r", :password => "qaz" )
        @invalid_user.valid?
      end

      it "email < 6 symbols " do
        expect(@invalid_user.errors[:email]).to include("недостаточной длины (не может быть меньше 6 символов)")
      end

      it "password < 6 symbols" do
        expect(@invalid_user.errors[:password]).to include("недостаточной длины (не может быть меньше 6 символов)")
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

      it "without password" do
        @user.password = nil

        expect{ @user.save }.to_not change{ User.count }
      end

    end

  end

end
