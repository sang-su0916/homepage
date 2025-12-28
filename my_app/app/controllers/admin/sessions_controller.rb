# frozen_string_literal: true

module Admin
  class SessionsController < ApplicationController
    layout "admin_login", only: [ :new ]

    # Admin doesn't use locale in URLs
    def default_url_options
      {}
    end

    def new
    end

    def create
      use_case = ::Admin::LoginAdmin.new(repository: admin_repository)
      result = use_case.call(
        email: params[:email],
        password: params[:password]
      )

      if result.success?
        session[:admin_id] = AdminRecord.find_by(email: params[:email]).id
        redirect_to admin_root_path, notice: "로그인되었습니다."
      else
        @errors = result.errors
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      session[:admin_id] = nil
      redirect_to admin_login_path, notice: "로그아웃되었습니다."
    end

    private

    def admin_repository
      ::Admin::AdminRepository.new
    end
  end
end
