# frozen_string_literal: true

require "test_helper"

module Public
  class SubmitContactTest < ActiveSupport::TestCase
    setup do
      @repository = Contact::ContactRepository.new
      @use_case = Public::SubmitContact.new(repository: @repository)
    end

    test "문의 등록 성공" do
      params = {
        name: "홍길동",
        email: "hong@example.com",
        phone: "010-1234-5678",
        message: "서비스 문의드립니다."
      }

      result = @use_case.call(params)

      assert result.success?
      assert_not_nil result.data
      assert_equal "홍길동", result.data.name
      assert_equal "hong@example.com", result.data.email
      assert_equal "pending", result.data.status
    end

    test "이름 없이 문의 등록 실패" do
      params = {
        name: "",
        email: "hong@example.com",
        message: "서비스 문의드립니다."
      }

      result = @use_case.call(params)

      assert result.failure?
      assert_includes result.errors[:name], "이름은 필수입니다"
    end

    test "이메일 없이 문의 등록 실패" do
      params = {
        name: "홍길동",
        email: "",
        message: "서비스 문의드립니다."
      }

      result = @use_case.call(params)

      assert result.failure?
      assert_includes result.errors[:email], "이메일은 필수입니다"
    end

    test "잘못된 이메일 형식으로 문의 등록 실패" do
      params = {
        name: "홍길동",
        email: "invalid-email",
        message: "서비스 문의드립니다."
      }

      result = @use_case.call(params)

      assert result.failure?
      assert_includes result.errors[:email], "이메일 형식이 올바르지 않습니다"
    end

    test "메시지 없이 문의 등록 실패" do
      params = {
        name: "홍길동",
        email: "hong@example.com",
        message: ""
      }

      result = @use_case.call(params)

      assert result.failure?
      assert_includes result.errors[:message], "메시지는 필수입니다"
    end
  end
end
