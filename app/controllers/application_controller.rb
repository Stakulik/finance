class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :render_404


  def after_sign_in_path_for(resource)
    portfolios_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

private

  def render_404(exception)
    respond_to do |format|
      format.html { render template: 'errors/error_404', layout: 'layouts/application', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end

end
