# frozen_string_literal: true

require "test_helper"

module Admin
  class UpdateContactStatusTest < ActiveSupport::TestCase
    setup do
      @repository = Contact::ContactRepository.new
      @use_case = Admin::UpdateContactStatus.new(repository: @repository)

      # 테스트용 문의 생성
      @contact = ContactRecord.create!(
        name: "홍길동",
        email: "hong@example.com",
        message: "테스트 문의입니다.",
        status: "pending"
      )
    end

    test "문의 상태를 read로 변경 성공" do
      result = @use_case.call(
        id: @contact.id,
        status: "read"
      )

      assert result.success?
      assert_equal "read", result.data.status
    end

    test "문의 상태를 replied로 변경 성공" do
      result = @use_case.call(
        id: @contact.id,
        status: "replied"
      )

      assert result.success?
      assert_equal "replied", result.data.status
    end

    test "존재하지 않는 문의 상태 변경 실패" do
      result = @use_case.call(
        id: 99999,
        status: "read"
      )

      assert result.failure?
      assert_includes result.errors[:contact], "문의를 찾을 수 없습니다"
    end

    test "유효하지 않은 상태로 변경 시도 실패" do
      result = @use_case.call(
        id: @contact.id,
        status: "invalid_status"
      )

      assert result.failure?
      assert_includes result.errors[:status], "유효하지 않은 상태입니다"
    end

    test "ID 없이 상태 변경 시도 실패" do
      result = @use_case.call(
        id: nil,
        status: "read"
      )

      assert result.failure?
      assert_includes result.errors[:id], "ID는 필수입니다"
    end

    test "상태값 없이 변경 시도 실패" do
      result = @use_case.call(
        id: @contact.id,
        status: ""
      )

      assert result.failure?
      assert_includes result.errors[:status], "상태는 필수입니다"
    end
  end
end
