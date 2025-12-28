# frozen_string_literal: true

module Public
  class SubmitContact < BaseUseCase
    def initialize(repository:)
      @repository = repository
    end

    def call(params)
      errors = validate(params)
      return failure(errors) if errors.any?

      entity = Contact::Entities::Contact.new(
        id: nil,
        name: params[:name],
        email: params[:email],
        phone: params[:phone],
        message: params[:message],
        status: "pending"
      )

      saved_entity = @repository.save(entity)
      success(saved_entity)
    end

    private

    def validate(params)
      errors = {}

      if blank?(params[:name])
        errors[:name] = [ "이름은 필수입니다" ]
      end

      if blank?(params[:email])
        errors[:email] = [ "이메일은 필수입니다" ]
      elsif !valid_email?(params[:email])
        errors[:email] = [ "이메일 형식이 올바르지 않습니다" ]
      end

      if blank?(params[:message])
        errors[:message] = [ "메시지는 필수입니다" ]
      end

      errors
    end

    def valid_email?(email)
      Shared::EmailValidator.valid?(email)
    end
  end
end
