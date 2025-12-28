# frozen_string_literal: true

require "test_helper"

module Admin
  class LoginAdminTest < ActiveSupport::TestCase
    setup do
      @repository = Admin::AdminRepository.new
      @use_case = Admin::LoginAdmin.new(repository: @repository)

      # 테스트용 관리자 생성
      @password = "secure_password123"
      @admin = AdminRecord.create!(
        email: "admin@lbiz.co.kr",
        password_digest: BCrypt::Password.create(@password)
      )
    end

    test "올바른 이메일과 비밀번호로 로그인 성공" do
      result = @use_case.call(
        email: "admin@lbiz.co.kr",
        password: @password
      )

      assert result.success?
      assert_not_nil result.data
      assert_equal "admin@lbiz.co.kr", result.data.email
    end

    test "잘못된 비밀번호로 로그인 실패" do
      result = @use_case.call(
        email: "admin@lbiz.co.kr",
        password: "wrong_password"
      )

      assert result.failure?
      assert_includes result.errors[:auth], "이메일 또는 비밀번호가 올바르지 않습니다"
    end

    test "존재하지 않는 이메일로 로그인 실패" do
      result = @use_case.call(
        email: "nonexistent@lbiz.co.kr",
        password: @password
      )

      assert result.failure?
      assert_includes result.errors[:auth], "이메일 또는 비밀번호가 올바르지 않습니다"
    end

    test "이메일 없이 로그인 시도 실패" do
      result = @use_case.call(
        email: "",
        password: @password
      )

      assert result.failure?
      assert_includes result.errors[:email], "이메일은 필수입니다"
    end

    test "비밀번호 없이 로그인 시도 실패" do
      result = @use_case.call(
        email: "admin@lbiz.co.kr",
        password: ""
      )

      assert result.failure?
      assert_includes result.errors[:password], "비밀번호는 필수입니다"
    end
  end
end
