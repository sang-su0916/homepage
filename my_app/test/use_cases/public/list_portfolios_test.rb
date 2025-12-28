# frozen_string_literal: true

require "test_helper"

module Public
  class ListPortfoliosTest < ActiveSupport::TestCase
    setup do
      @repository = Portfolio::PortfolioRepository.new
      @use_case = Public::ListPortfolios.new(repository: @repository)
    end

    test "공개된 포트폴리오 목록 조회" do
      # 테스트 데이터 생성
      PortfolioRecord.create!(title: "프로젝트 A", published: true)
      PortfolioRecord.create!(title: "프로젝트 B", published: true)
      PortfolioRecord.create!(title: "비공개 프로젝트", published: false)

      result = @use_case.call

      assert result.success?
      assert_equal 2, result.data.count
      assert result.data.all? { |p| p.published? }
    end

    test "포트폴리오가 없을 때 빈 배열 반환" do
      result = @use_case.call

      assert result.success?
      assert_empty result.data
    end
  end
end
