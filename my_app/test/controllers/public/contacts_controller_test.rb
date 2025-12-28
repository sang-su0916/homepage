# frozen_string_literal: true

require "test_helper"

module Public
  class ContactsControllerTest < ActionDispatch::IntegrationTest
    test "문의 폼 페이지 접속" do
      get new_contact_path

      assert_response :success
      assert_select "form"
      assert_select "input[name='contact[name]']"
      assert_select "input[name='contact[email]']"
      assert_select "textarea[name='contact[message]']"
    end

    test "문의 등록 성공" do
      assert_difference "ContactRecord.count", 1 do
        post contacts_path, params: {
          contact: {
            name: "홍길동",
            email: "hong@example.com",
            phone: "010-1234-5678",
            message: "서비스 문의드립니다."
          }
        }
      end

      assert_redirected_to contact_success_path
      follow_redirect!
      assert_select "h1", /문의가 접수되었습니다/
    end

    test "유효하지 않은 데이터로 문의 등록 실패" do
      assert_no_difference "ContactRecord.count" do
        post contacts_path, params: {
          contact: {
            name: "",
            email: "invalid-email",
            message: ""
          }
        }
      end

      assert_response :unprocessable_entity
      assert_select ".bg-red-50"  # Error message container
    end

    test "문의 성공 페이지 접속" do
      get contact_success_path

      assert_response :success
      assert_select "h1", /문의가 접수되었습니다/
    end
  end
end
