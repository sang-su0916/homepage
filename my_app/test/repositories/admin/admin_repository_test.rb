# frozen_string_literal: true

require "test_helper"

module Admin
  class AdminRepositoryTest < ActiveSupport::TestCase
    setup do
      @repository = AdminRepository.new
    end

    test "관리자를 저장하고 조회할 수 있다" do
      entity = Entities::Admin.new(
        id: nil,
        email: "admin@lbizpartners.com",
        password_digest: "hashed_password_123"
      )

      saved = @repository.save(entity)

      assert_not_nil saved.id
      assert_equal "admin@lbizpartners.com", saved.email

      found = @repository.find_by_id(saved.id)
      assert_equal saved.id, found.id
    end

    test "이메일로 관리자를 조회할 수 있다" do
      @repository.save(
        Entities::Admin.new(
          id: nil,
          email: "test@example.com",
          password_digest: "hash123"
        )
      )

      found = @repository.find_by_email("test@example.com")

      assert_not_nil found
      assert_equal "test@example.com", found.email
    end

    test "존재하지 않는 이메일은 nil을 반환한다" do
      found = @repository.find_by_email("notexist@example.com")
      assert_nil found
    end

    test "관리자를 삭제할 수 있다" do
      saved = @repository.save(
        Entities::Admin.new(
          id: nil,
          email: "delete@example.com",
          password_digest: "hash"
        )
      )

      @repository.delete(saved.id)
      assert_nil @repository.find_by_id(saved.id)
    end

    test "이메일 중복 여부를 확인할 수 있다" do
      @repository.save(
        Entities::Admin.new(
          id: nil,
          email: "exist@example.com",
          password_digest: "hash"
        )
      )

      assert @repository.email_exists?("exist@example.com")
      assert_not @repository.email_exists?("new@example.com")
    end
  end
end
