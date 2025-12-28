# frozen_string_literal: true

require "test_helper"

module Admin
  class PortfoliosControllerTest < ActionDispatch::IntegrationTest
    setup do
      @password = "secure_password123"
      @admin = AdminRecord.create!(
        email: "admin@lbiz.co.kr",
        password_digest: BCrypt::Password.create(@password)
      )
      login_as_admin

      @portfolio = PortfolioRecord.create!(
        title: "기존 프로젝트",
        description: "기존 설명",
        published: false
      )
    end

    test "비로그인 상태에서 접근 시 로그인 페이지로 리다이렉트" do
      delete admin_session_path  # 로그아웃
      get admin_portfolios_path

      assert_redirected_to admin_login_path
    end

    test "포트폴리오 목록 조회" do
      get admin_portfolios_path

      assert_response :success
      assert_select "table"
      assert_select "td", /기존 프로젝트/
    end

    test "포트폴리오 생성 폼 페이지" do
      get new_admin_portfolio_path

      assert_response :success
      assert_select "form"
      assert_select "input[name='portfolio[title]']"
    end

    test "포트폴리오 생성 성공" do
      assert_difference "PortfolioRecord.count", 1 do
        post admin_portfolios_path, params: {
          portfolio: {
            title: "새 프로젝트",
            description: "새 설명",
            client: "고객사",
            published: true
          }
        }
      end

      assert_redirected_to admin_portfolios_path
      follow_redirect!
      assert_select ".bg-green-100"  # Flash notice
    end

    test "유효하지 않은 데이터로 포트폴리오 생성 실패" do
      assert_no_difference "PortfolioRecord.count" do
        post admin_portfolios_path, params: {
          portfolio: { title: "" }
        }
      end

      assert_response :unprocessable_entity
      assert_select ".bg-red-50"  # Error container
    end

    test "포트폴리오 수정 폼 페이지" do
      get edit_admin_portfolio_path(@portfolio)

      assert_response :success
      assert_select "input[value='기존 프로젝트']"
    end

    test "포트폴리오 수정 성공" do
      patch admin_portfolio_path(@portfolio), params: {
        portfolio: { title: "수정된 제목" }
      }

      assert_redirected_to admin_portfolios_path
      @portfolio.reload
      assert_equal "수정된 제목", @portfolio.title
    end

    test "포트폴리오 삭제" do
      assert_difference "PortfolioRecord.count", -1 do
        delete admin_portfolio_path(@portfolio)
      end

      assert_redirected_to admin_portfolios_path
    end

    test "이미지와 함께 포트폴리오 생성" do
      image = fixture_file_upload("test_image.png", "image/png")

      assert_difference "PortfolioRecord.count", 1 do
        post admin_portfolios_path, params: {
          portfolio: {
            title: "이미지 포트폴리오",
            description: "이미지 설명",
            image: image
          }
        }
      end

      assert_redirected_to admin_portfolios_path
      portfolio = PortfolioRecord.last
      assert portfolio.image.attached?
    end

    test "이미지 수정" do
      image = fixture_file_upload("test_image.png", "image/png")

      patch admin_portfolio_path(@portfolio), params: {
        portfolio: { image: image }
      }

      assert_redirected_to admin_portfolios_path
      @portfolio.reload
      assert @portfolio.image.attached?
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
