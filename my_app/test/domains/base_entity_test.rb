# frozen_string_literal: true

require "test_helper"

class BaseEntityTest < ActiveSupport::TestCase
  # 테스트용 엔티티 클래스
  class TestEntity < BaseEntity
    attribute :name, :string
    attribute :email, :string

    validates :name, presence: true
  end

  test "엔티티는 속성을 정의할 수 있다" do
    entity = TestEntity.new(id: 1, name: "홍길동", email: "hong@example.com")

    assert_equal 1, entity.id
    assert_equal "홍길동", entity.name
    assert_equal "hong@example.com", entity.email
  end

  test "같은 id를 가진 엔티티는 동등하다" do
    entity1 = TestEntity.new(id: 1, name: "홍길동")
    entity2 = TestEntity.new(id: 1, name: "김철수")

    assert_equal entity1, entity2
  end

  test "다른 id를 가진 엔티티는 동등하지 않다" do
    entity1 = TestEntity.new(id: 1, name: "홍길동")
    entity2 = TestEntity.new(id: 2, name: "홍길동")

    assert_not_equal entity1, entity2
  end

  test "엔티티는 유효성 검증을 수행할 수 있다" do
    valid_entity = TestEntity.new(id: 1, name: "홍길동")
    invalid_entity = TestEntity.new(id: 2, name: nil)

    assert valid_entity.valid?
    assert_not invalid_entity.valid?
    assert invalid_entity.errors[:name].any?
  end

  test "엔티티는 해시 키로 사용될 수 있다" do
    entity1 = TestEntity.new(id: 1, name: "홍길동")
    entity2 = TestEntity.new(id: 1, name: "김철수")

    hash = { entity1 => "value1" }
    hash[entity2] = "value2"

    assert_equal 1, hash.size
    assert_equal "value2", hash[entity1]
  end
end
