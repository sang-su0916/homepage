# frozen_string_literal: true

module Public
  class ContactsController < BaseController
    def new
      @contact = OpenStruct.new
    end

    def create
      use_case = ::Public::SubmitContact.new(repository: contact_repository)
      result = use_case.call(contact_params)

      if result.success?
        redirect_to contact_success_path
      else
        @contact = OpenStruct.new(contact_params)
        @errors = result.errors
        render :new, status: :unprocessable_entity
      end
    end

    def success
    end

    private

    def contact_repository
      Contact::ContactRepository.new
    end

    def contact_params
      params.require(:contact).permit(:name, :email, :phone, :message)
    end
  end
end
