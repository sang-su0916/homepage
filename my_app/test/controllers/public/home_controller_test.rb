# frozen_string_literal: true

require "test_helper"

module Public
  class HomeControllerTest < ActionDispatch::IntegrationTest
    test "홈페이지 접속 성공" do
      get root_path

      assert_response :success
      assert_select "h1", /비즈니스/
    end

    test "회사 소개 섹션 표시" do
      get root_path

      assert_response :success
      assert_select "#about"
    end

    test "서비스 소개 섹션 표시" do
      get root_path

      assert_response :success
      assert_select "#services"
    end
  end
end
