# frozen_string_literal: true

require "test_helper"

module Public
  class GetPortfolioDetailTest < ActiveSupport::TestCase
    setup do
      @repository = Portfolio::PortfolioRepository.new
      @use_case = Public::GetPortfolioDetail.new(repository: @repository)
    end

    test "공개된 포트폴리오 상세 조회 성공" do
      portfolio = PortfolioRecord.create!(
        title: "웹사이트 리뉴얼",
        description: "기업 홈페이지 전면 개편",
        client: "ABC 주식회사",
        published: true
      )

      result = @use_case.call(id: portfolio.id)

      assert result.success?
      assert_equal "웹사이트 리뉴얼", result.data.title
      assert_equal "기업 홈페이지 전면 개편", result.data.description
    end

    test "비공개 포트폴리오 조회 시 실패" do
      portfolio = PortfolioRecord.create!(
        title: "비공개 프로젝트",
        published: false
      )

      result = @use_case.call(id: portfolio.id)

      assert result.failure?
      assert_includes result.errors[:portfolio], "포트폴리오를 찾을 수 없습니다"
    end

    test "존재하지 않는 포트폴리오 조회 시 실패" do
      result = @use_case.call(id: 99999)

      assert result.failure?
      assert_includes result.errors[:portfolio], "포트폴리오를 찾을 수 없습니다"
    end

    test "ID 없이 조회 시 실패" do
      result = @use_case.call(id: nil)

      assert result.failure?
      assert_includes result.errors[:id], "ID는 필수입니다"
    end
  end
end
