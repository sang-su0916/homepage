# frozen_string_literal: true

require "test_helper"

module Contact
  class ContactEntityTest < ActiveSupport::TestCase
    test "문의를 생성할 수 있다" do
      contact = Entities::Contact.new(
        id: 1,
        name: "홍길동",
        email: "hong@example.com",
        phone: "010-1234-5678",
        message: "서비스 문의드립니다.",
        status: "pending"
      )

      assert_equal "홍길동", contact.name
      assert_equal "hong@example.com", contact.email
      assert_equal "pending", contact.status
    end

    test "문의 상태는 pending, read, replied 중 하나여야 한다" do
      valid_contact = Entities::Contact.new(
        id: 1,
        name: "테스트",
        email: "test@example.com",
        message: "테스트",
        status: "pending"
      )

      assert valid_contact.valid?
    end

    test "이메일 주소 값 객체를 생성할 수 있다" do
      email = ValueObjects::EmailAddress.new(value: "test@example.com")

      assert email.frozen?
      assert_equal "test@example.com", email.value
      assert email.valid?
    end

    test "잘못된 이메일 형식은 유효하지 않다" do
      invalid_email = ValueObjects::EmailAddress.new(value: "invalid-email")

      assert_not invalid_email.valid?
    end

    test "전화번호 값 객체를 생성할 수 있다" do
      phone = ValueObjects::PhoneNumber.new(value: "010-1234-5678")

      assert phone.frozen?
      assert_equal "010-1234-5678", phone.value
    end

    test "문의는 읽음 표시할 수 있다" do
      contact = Entities::Contact.new(
        id: 1,
        name: "테스트",
        email: "test@example.com",
        message: "테스트",
        status: "pending"
      )

      read_contact = contact.mark_as_read

      assert_equal "read", read_contact.status
      assert_equal "pending", contact.status # 원본은 불변
    end
  end
end
