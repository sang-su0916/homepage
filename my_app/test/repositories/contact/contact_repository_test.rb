# frozen_string_literal: true

require "test_helper"

module Contact
  class ContactRepositoryTest < ActiveSupport::TestCase
    setup do
      @repository = ContactRepository.new
    end

    test "문의를 저장하고 조회할 수 있다" do
      entity = Entities::Contact.new(
        id: nil,
        name: "홍길동",
        email: "hong@example.com",
        phone: "010-1234-5678",
        message: "서비스 문의드립니다.",
        status: "pending"
      )

      saved = @repository.save(entity)

      assert_not_nil saved.id
      assert_equal "홍길동", saved.name
      assert_equal "hong@example.com", saved.email

      found = @repository.find_by_id(saved.id)
      assert_equal saved.id, found.id
      assert_equal "홍길동", found.name
    end

    test "모든 문의를 조회할 수 있다" do
      3.times do |i|
        @repository.save(
          Entities::Contact.new(
            id: nil,
            name: "테스트#{i}",
            email: "test#{i}@example.com",
            message: "메시지#{i}",
            status: "pending"
          )
        )
      end

      all = @repository.find_all
      assert_equal 3, all.size
      assert all.all? { |c| c.is_a?(Entities::Contact) }
    end

    test "문의를 삭제할 수 있다" do
      saved = @repository.save(
        Entities::Contact.new(
          id: nil,
          name: "삭제테스트",
          email: "delete@example.com",
          message: "삭제될 메시지",
          status: "pending"
        )
      )

      @repository.delete(saved.id)

      assert_nil @repository.find_by_id(saved.id)
    end

    test "문의 상태를 업데이트할 수 있다" do
      saved = @repository.save(
        Entities::Contact.new(
          id: nil,
          name: "상태변경",
          email: "status@example.com",
          message: "상태 변경 테스트",
          status: "pending"
        )
      )

      updated_entity = saved.mark_as_read
      @repository.save(updated_entity)

      found = @repository.find_by_id(saved.id)
      assert_equal "read", found.status
    end

    test "상태별로 문의를 조회할 수 있다" do
      @repository.save(Entities::Contact.new(id: nil, name: "A", email: "a@test.com", message: "A", status: "pending"))
      @repository.save(Entities::Contact.new(id: nil, name: "B", email: "b@test.com", message: "B", status: "read"))
      @repository.save(Entities::Contact.new(id: nil, name: "C", email: "c@test.com", message: "C", status: "pending"))

      pending = @repository.find_by_status("pending")
      assert_equal 2, pending.size

      read = @repository.find_by_status("read")
      assert_equal 1, read.size
    end
  end
end
