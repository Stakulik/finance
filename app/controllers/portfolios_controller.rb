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
  include UserPermission

  before_action :authenticate_user!
  before_action :user_is_owner?, :except => [:index, :new, :create]
  before_action :check_for_cancel, :only => [:create, :update]
  before_action :get_portfolio, :only => [:edit, :update, :destroy]
  
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
  end

  def update
    if @portfolio.update_attributes(portfolio_params)
      redirect_to portfolios_path
    else
      render 'edit'
    end
  end

  def destroy
    @portfolio.destroy
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
    @portfolio = Portfolio.find(params[:id])
  end

  def check_for_cancel
    if params[:commit] == "Отменить"
      redirect_to portfolios_path
    end
  end

end
