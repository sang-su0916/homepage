# frozen_string_literal: true

module Admin
  class LoginAdmin < BaseUseCase
    def initialize(repository:)
      @repository = repository
    end

    def call(email:, password:)
      errors = validate(email, password)
      return failure(errors) if errors.any?

      admin = @repository.find_by_email(email)

      unless admin && valid_password?(admin, password)
        return failure(auth: [ "이메일 또는 비밀번호가 올바르지 않습니다" ])
      end

      success(admin)
    end

    private

    def validate(email, password)
      errors = {}

      if blank?(email)
        errors[:email] = [ "이메일은 필수입니다" ]
      end

      if blank?(password)
        errors[:password] = [ "비밀번호는 필수입니다" ]
      end

      errors
    end

    def valid_password?(admin, password)
      BCrypt::Password.new(admin.password_digest) == password
    end
  end
end
