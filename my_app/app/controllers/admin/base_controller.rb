# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    layout "admin"
    before_action :require_admin

    # Admin doesn't use locale in URLs
    def default_url_options
      {}
    end

    private

    def require_admin
      unless current_admin
        redirect_to admin_login_path, alert: "로그인이 필요합니다."
      end
    end

    def current_admin
      return @current_admin if defined?(@current_admin)

      @current_admin = session[:admin_id] && AdminRecord.find_by(id: session[:admin_id])
    end
    helper_method :current_admin
  end
end
