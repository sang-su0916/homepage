# frozen_string_literal: true

require "test_helper"

module Admin
  class AdminEntityTest < ActiveSupport::TestCase
    test "관리자를 생성할 수 있다" do
      admin = Entities::Admin.new(
        id: 1,
        email: "admin@lbizpartners.com",
        password_digest: "hashed_password"
      )

      assert_equal "admin@lbizpartners.com", admin.email
    end

    test "관리자 이메일은 필수이다" do
      admin = Entities::Admin.new(id: 1, email: nil)

      assert_not admin.valid?
      assert admin.errors[:email].any?
    end

    test "관리자 이메일 형식이 올바른지 검증한다" do
      valid_admin = Entities::Admin.new(
        id: 1,
        email: "admin@example.com",
        password_digest: "hash"
      )

      invalid_admin = Entities::Admin.new(
        id: 2,
        email: "invalid-email",
        password_digest: "hash"
      )

      assert valid_admin.valid?
      assert_not invalid_admin.valid?
    end
  end
end
