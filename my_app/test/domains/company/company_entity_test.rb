# frozen_string_literal: true

require "test_helper"

module Company
  class CompanyEntityTest < ActiveSupport::TestCase
    test "회사 정보를 생성할 수 있다" do
      company = Entities::Company.new(
        id: 1,
        name: "엘비즈파트너스",
        description: "비즈니스 컨설팅 전문 기업"
      )

      assert_equal "엘비즈파트너스", company.name
      assert_equal "비즈니스 컨설팅 전문 기업", company.description
    end

    test "팀 멤버를 생성할 수 있다" do
      member = Entities::TeamMember.new(
        id: 1,
        name: "홍길동",
        position: "대표이사",
        bio: "20년 경력의 컨설턴트",
        photo_url: "/images/team/hong.jpg"
      )

      assert_equal "홍길동", member.name
      assert_equal "대표이사", member.position
    end

    test "회사 연혁을 생성할 수 있다" do
      history = Entities::History.new(
        id: 1,
        year: 2020,
        month: 3,
        title: "회사 설립",
        description: "엘비즈파트너스 법인 설립"
      )

      assert_equal 2020, history.year
      assert_equal "회사 설립", history.title
    end

    test "비전 값 객체를 생성할 수 있다" do
      vision = ValueObjects::Vision.new(
        title: "글로벌 비즈니스 파트너",
        description: "고객의 성공을 위한 최고의 파트너가 됩니다"
      )

      assert vision.frozen?
      assert_equal "글로벌 비즈니스 파트너", vision.title
    end

    test "미션 값 객체를 생성할 수 있다" do
      mission = ValueObjects::Mission.new(
        title: "가치 창출",
        description: "고객과 함께 지속 가능한 가치를 창출합니다"
      )

      assert mission.frozen?
      assert_equal "가치 창출", mission.title
    end
  end
end
