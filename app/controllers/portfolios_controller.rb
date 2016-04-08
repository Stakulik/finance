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

class PortfoliosController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_cancel, :only => [:create, :update]
  
  def index
    @portfolios = Portfolio.eager_load(:stocks).where("user_id = ?", current_user.id)
  end

  def show
    @portfolio = Portfolio.eager_load(:stocks).find(params[:id])
  end

  def new
    @portfolio = current_user.portfolios.build
  end

  def create
    @portfolio = current_user.portfolios.build(portfolio_params)

    if @portfolio.save
      redirect_to @portfolio
    else
      render 'new'
    end
  end

  def edit
    @portfolio = get_portfolio
  end

  def update
    @portfolio = get_portfolio

    if @portfolio.update_attributes(portfolio_params)
      redirect_to @portfolio
    else
      render 'edit'
    end
  end

  def destroy
    Portfolio.find(params[:id]).destroy
    redirect_to portfolios_path
  end

  private

  def portfolio_params
    params.require(:portfolio).permit(
      :name,
      :description,
      :user_id
    )
  end

  def get_portfolio
    Portfolio.find(params[:id])
  end

  def check_for_cancel
    if params[:commit] == "Отменить"
      redirect_to portfolios_path
    end
  end

end
