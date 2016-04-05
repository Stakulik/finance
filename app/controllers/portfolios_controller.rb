class PortfoliosController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @portfolios = Portfolio.eager_load(:stocks).where("user_id == ?", current_user.id)
  end

  def new
  end

  def edit
  end

  def show
    @portfolio = Portfolio.eager_load(:stocks).find(params[:id])
  end


  private

  def portfolio_params
    params.require(:portfolio).permit(
      :name,
      :description,
      :user_id
    )
  end

end
