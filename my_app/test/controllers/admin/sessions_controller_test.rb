# frozen_string_literal: true

require "test_helper"

module Admin
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @password = "secure_password123"
      @admin = AdminRecord.create!(
        email: "admin@lbiz.co.kr",
        password_digest: BCrypt::Password.create(@password)
      )
    end

    test "로그인 폼 페이지 접속" do
      get admin_login_path

      assert_response :success
      assert_select "form"
      assert_select "input[name='email']"
      assert_select "input[name='password']"
    end

    test "올바른 자격증명으로 로그인 성공" do
      post admin_session_path, params: {
        email: "admin@lbiz.co.kr",
        password: @password
      }

      assert_redirected_to admin_root_path
      assert session[:admin_id].present?
    end

    test "잘못된 자격증명으로 로그인 실패" do
      post admin_session_path, params: {
        email: "admin@lbiz.co.kr",
        password: "wrong_password"
      }

      assert_response :unprocessable_entity
      assert_select ".bg-red-50"  # Error container
      assert_nil session[:admin_id]
    end

    test "로그아웃 성공" do
      # 먼저 로그인
      post admin_session_path, params: {
        email: "admin@lbiz.co.kr",
        password: @password
      }

      # 로그아웃
      delete admin_session_path

      assert_redirected_to admin_login_path
      assert_nil session[:admin_id]
    end
  end
end
