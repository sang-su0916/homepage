# frozen_string_literal: true

require "test_helper"

module Admin
  class ContactsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @password = "secure_password123"
      @admin = AdminRecord.create!(
        email: "admin@lbiz.co.kr",
        password_digest: BCrypt::Password.create(@password)
      )
      login_as_admin

      @contact = ContactRecord.create!(
        name: "홍길동",
        email: "hong@example.com",
        message: "문의 내용입니다.",
        status: "pending"
      )
    end

    test "비로그인 상태에서 접근 시 로그인 페이지로 리다이렉트" do
      delete admin_session_path  # 로그아웃
      get admin_contacts_path

      assert_redirected_to admin_login_path
    end

    test "문의 목록 조회" do
      get admin_contacts_path

      assert_response :success
      assert_select "table"
      assert_select "td", /홍길동/
    end

    test "문의 상세 조회" do
      get admin_contact_path(@contact)

      assert_response :success
      assert_select "h2", /홍길동/
      assert_select ".prose", /문의 내용입니다/
    end

    test "문의 상태를 read로 변경" do
      patch admin_contact_path(@contact), params: {
        contact: { status: "read" }
      }

      assert_redirected_to admin_contacts_path
      @contact.reload
      assert_equal "read", @contact.status
    end

    test "문의 상태를 replied로 변경" do
      patch admin_contact_path(@contact), params: {
        contact: { status: "replied" }
      }

      assert_redirected_to admin_contacts_path
      @contact.reload
      assert_equal "replied", @contact.status
    end

    test "문의 삭제" do
      assert_difference "ContactRecord.count", -1 do
        delete admin_contact_path(@contact)
      end

      assert_redirected_to admin_contacts_path
    end

    test "상태별 문의 필터링" do
      ContactRecord.create!(
        name: "김철수",
        email: "kim@example.com",
        message: "다른 문의",
        status: "read"
      )

      get admin_contacts_path(status: "pending")

      assert_response :success
      assert_select "td", text: /홍길동/
      assert_select "td", text: /김철수/, count: 0
    end

    private

    def login_as_admin
      post admin_session_path, params: {
        email: "admin@lbiz.co.kr",
        password: @password
      }
    end
  end
end
