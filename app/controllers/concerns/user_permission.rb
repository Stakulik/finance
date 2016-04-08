module UserPermission

  def user_is_owner?
    @portfolio = get_portfolio
    
    raise(ActiveRecord::RecordNotFound) unless current_user.id == @portfolio.user_id
  end

end