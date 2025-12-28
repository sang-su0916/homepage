# frozen_string_literal: true

require "test_helper"

module Service
  class ServiceEntityTest < ActiveSupport::TestCase
    test "서비스를 생성할 수 있다" do
      service = Entities::Service.new(
        id: 1,
        title: "경영 컨설팅",
        description: "기업 성장을 위한 전략 수립",
        icon: "briefcase",
        active: true,
        position: 1
      )

      assert_equal "경영 컨설팅", service.title
      assert service.active
    end

    test "서비스는 활성/비활성 상태를 가진다" do
      active_service = Entities::Service.new(id: 1, title: "활성", active: true)
      inactive_service = Entities::Service.new(id: 2, title: "비활성", active: false)

      assert active_service.active?
      assert_not inactive_service.active?
    end

    test "서비스 카테고리를 생성할 수 있다" do
      category = Entities::ServiceCategory.new(
        id: 1,
        name: "컨설팅",
        slug: "consulting"
      )

      assert_equal "컨설팅", category.name
      assert_equal "consulting", category.slug
    end

    test "서비스는 position으로 정렬 가능하다" do
      service1 = Entities::Service.new(id: 1, title: "첫번째", position: 1)
      service2 = Entities::Service.new(id: 2, title: "두번째", position: 2)

      services = [service2, service1].sort_by(&:position)
      assert_equal "첫번째", services.first.title
    end
  end
end
