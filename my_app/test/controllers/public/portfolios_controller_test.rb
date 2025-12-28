# frozen_string_literal: true

require "test_helper"

module Public
  class PortfoliosControllerTest < ActionDispatch::IntegrationTest
    setup do
      @published_portfolio = PortfolioRecord.create!(
        title: "웹사이트 리뉴얼",
        description: "기업 홈페이지 전면 개편",
        client: "ABC 주식회사",
        published: true
      )
      @unpublished_portfolio = PortfolioRecord.create!(
        title: "비공개 프로젝트",
        published: false
      )
    end

    test "포트폴리오 목록 조회" do
      get portfolios_path

      assert_response :success
      assert_select "article", 1  # Portfolio card
      assert_select "h2", /웹사이트 리뉴얼/
    end

    test "비공개 포트폴리오는 목록에 표시되지 않음" do
      get portfolios_path

      assert_response :success
      assert_select "h2", text: /비공개 프로젝트/, count: 0
    end

    test "포트폴리오 상세 조회" do
      get portfolio_path(id: @published_portfolio.id)

      assert_response :success
      assert_select "h1", /웹사이트 리뉴얼/
      assert_select ".prose", /기업 홈페이지 전면 개편/
    end

    test "비공개 포트폴리오 상세 조회 시 404" do
      get portfolio_path(id: @unpublished_portfolio.id)

      assert_response :not_found
    end

    test "존재하지 않는 포트폴리오 조회 시 404" do
      get portfolio_path(id: 99999)

      assert_response :not_found
    end

    test "제목으로 포트폴리오 검색" do
      PortfolioRecord.create!(title: "디지털 전환 프로젝트", client: "D사", published: true)

      get portfolios_path, params: { q: "디지털" }

      assert_response :success
      assert_select "h2", /디지털 전환 프로젝트/
      assert_select "p", /\"디지털\" 검색 결과/
    end

    test "클라이언트명으로 포트폴리오 검색" do
      get portfolios_path, params: { q: "ABC" }

      assert_response :success
      assert_select "h2", /웹사이트 리뉴얼/
    end

    test "검색 결과가 없을 때 메시지 표시" do
      get portfolios_path, params: { q: "존재하지않는키워드" }

      assert_response :success
      assert_select "p", /검색 결과가 없습니다/
    end

    test "검색 시 비공개 포트폴리오는 제외됨" do
      get portfolios_path, params: { q: "비공개" }

      assert_response :success
      assert_select "h2", text: /비공개 프로젝트/, count: 0
    end

    test "빈 검색어로 조회하면 전체 목록 표시" do
      get portfolios_path, params: { q: "" }

      assert_response :success
      assert_select "article", minimum: 1
    end
  end
end
