# frozen_string_literal: true

require "test_helper"

module Admin
  class CreatePortfolioTest < ActiveSupport::TestCase
    setup do
      @repository = Portfolio::PortfolioRepository.new
      @use_case = Admin::CreatePortfolio.new(repository: @repository)
    end

    test "포트폴리오 생성 성공" do
      params = {
        title: "새 웹사이트 프로젝트",
        description: "최신 기술을 활용한 반응형 웹사이트",
        client: "XYZ 기업",
        image_url: "https://example.com/image.jpg",
        published: false
      }

      result = @use_case.call(params)

      assert result.success?
      assert_not_nil result.data
      assert_equal "새 웹사이트 프로젝트", result.data.title
      assert_equal "XYZ 기업", result.data.client
      assert_equal false, result.data.published
    end

    test "제목 없이 포트폴리오 생성 실패" do
      params = {
        title: "",
        description: "설명",
        client: "고객사"
      }

      result = @use_case.call(params)

      assert result.failure?
      assert_includes result.errors[:title], "제목은 필수입니다"
    end

    test "공개 상태로 포트폴리오 생성" do
      params = {
        title: "공개 프로젝트",
        published: true
      }

      result = @use_case.call(params)

      assert result.success?
      assert result.data.published?
    end

    test "기본값으로 비공개 상태 설정" do
      params = {
        title: "기본 프로젝트"
      }

      result = @use_case.call(params)

      assert result.success?
      assert_not result.data.published?
    end
  end
end
