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

class StocksController < ApplicationController
  include UserPermission

  before_action :authenticate_user!
  before_action :user_is_owner?
  before_action :check_for_cancel, :only => [:create, :update]

  def new
    @portfolio = get_portfolio
    @stock = @portfolio.stocks.build
  end

  def create
    @portfolio = get_portfolio
    @stock = @portfolio.stocks.build(stock_params)

    if @stock.save
      redirect_to @portfolio
    else
      render 'new'
    end
  end

  def edit
    @stock = get_stock
    @portfolio = get_portfolio
  end

  def update
    @stock = get_stock
    @portfolio = get_portfolio

    if @stock.update_attributes(stock_params)
      redirect_to @portfolio
    else
      render 'edit'
    end
  end

  def destroy
    Stock.find(params[:id]).destroy
    redirect_to :back
  end

  private

  def stock_params
    params.require(:stock).permit(
      :name,
      :amount,
      :portfolio_id
    )
  end

  def get_stock
    Stock.find(params[:id])
  end

  def get_portfolio
    if params[:portfolio_id]
      Portfolio.find(params[:portfolio_id])
    else
      @stock = get_stock
      Portfolio.find(@stock.portfolio_id)
    end
  end

  def check_for_cancel
    if params[:commit] == "Отменить"
      redirect_to portfolio_path(params[:stock][:portfolio_id])
    end
  end

end
