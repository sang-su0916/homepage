# frozen_string_literal: true

module Admin
  class CreatePortfolio < BaseUseCase
    def initialize(repository:)
      @repository = repository
    end

    def call(params)
      errors = validate(params)
      return failure(errors) if errors.any?

      entity = Portfolio::Entities::Portfolio.new(
        id: nil,
        title: params[:title],
        description: params[:description],
        client: params[:client],
        published: params.fetch(:published, false)
      )

      saved_entity = @repository.save(entity, image: params[:image])
      success(saved_entity)
    end

    private

    def validate(params)
      errors = {}

      if blank?(params[:title])
        errors[:title] = [ "제목은 필수입니다" ]
      end

      errors
    end
  end
end
