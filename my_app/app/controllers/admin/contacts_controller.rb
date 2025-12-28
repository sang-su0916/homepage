# frozen_string_literal: true

module Admin
  class ContactsController < BaseController
    before_action :set_contact, only: [ :show, :update, :destroy ]

    def index
      page = (params[:page] || 1).to_i

      result = if params[:status].present?
        contact_repository.find_by_status_paginated(status: params[:status], page: page)
      else
        contact_repository.find_all_paginated(page: page)
      end

      @pagy = Pagy.new(count: result[:total_count], page: page)
      @contacts = result[:items]
    end

    def show
    end

    def update
      use_case = ::Admin::UpdateContactStatus.new(repository: contact_repository)
      result = use_case.call(
        id: @contact.id,
        status: params[:contact][:status]
      )

      if result.success?
        redirect_to admin_contacts_path, notice: "문의 상태가 변경되었습니다."
      else
        @errors = result.errors
        render :show, status: :unprocessable_entity
      end
    end

    def destroy
      contact_repository.delete(@contact.id)
      redirect_to admin_contacts_path, notice: "문의가 삭제되었습니다."
    end

    private

    def set_contact
      @contact = contact_repository.find_by_id(params[:id].to_i)
      render file: Rails.public_path.join("404.html"), status: :not_found, layout: false unless @contact
    end

    def contact_repository
      Contact::ContactRepository.new
    end
  end
end
