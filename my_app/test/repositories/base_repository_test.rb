# frozen_string_literal: true

require "test_helper"

class BaseRepositoryTest < ActiveSupport::TestCase
  test "BaseRepository는 추상 클래스로 직접 인스턴스화할 수 없다" do
    assert_raises(NotImplementedError) { BaseRepository.new }
  end

  test "BaseRepository는 CRUD 메서드 인터페이스를 정의한다" do
    # 테스트용 레포지토리 구현
    class TestRepository < BaseRepository
      def initialize
        @store = {}
        @next_id = 1
      end

      def find_all
        @store.values
      end

      def find_by_id(id)
        @store[id]
      end

      def save(entity)
        entity_with_id = entity.id ? entity : entity.class.new(id: @next_id, **entity.attributes.except("id"))
        @next_id += 1 unless entity.id
        @store[entity_with_id.id] = entity_with_id
        entity_with_id
      end

      def delete(id)
        @store.delete(id)
      end
    end

    # 테스트용 엔티티
    class TestEntity < BaseEntity
      attribute :name, :string
    end

    repo = TestRepository.new

    # save 테스트
    entity = TestEntity.new(name: "테스트")
    saved = repo.save(entity)
    assert_equal 1, saved.id
    assert_equal "테스트", saved.name

    # find_by_id 테스트
    found = repo.find_by_id(1)
    assert_equal saved, found

    # find_all 테스트
    repo.save(TestEntity.new(name: "테스트2"))
    all = repo.find_all
    assert_equal 2, all.size

    # delete 테스트
    deleted = repo.delete(1)
    assert_not_nil deleted
    assert_nil repo.find_by_id(1)
  end

  test "BaseRepository 서브클래스는 필수 메서드를 구현해야 한다" do
    class IncompleteRepository < BaseRepository
      # 아무것도 구현하지 않음
    end

    repo = IncompleteRepository.new
    assert_raises(NotImplementedError) { repo.find_all }
    assert_raises(NotImplementedError) { repo.find_by_id(1) }
    assert_raises(NotImplementedError) { repo.save(nil) }
    assert_raises(NotImplementedError) { repo.delete(1) }
  end
end
