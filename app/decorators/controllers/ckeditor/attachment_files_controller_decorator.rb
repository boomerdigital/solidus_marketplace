# frozen_string_literal: true

module Ckeditor
  module AttachmentFilesControllerDecorator
    def self.prepended(base)
      base.load_and_authorize_resource class: 'Ckeditor::AttachmentFile'
      base.after_filter :set_supplier, only: [:create]
    end

    def index
    end

    private

    def set_supplier
      if try_spree_current_user.supplier? and @attachment
        @attachment.supplier = try_spree_current_user.supplier
        @attachment.save
      end
    end

    if defined?(Ckeditor::AttachmentFilesController)
      Ckeditor::AttachmentFilesController.prepend self
    end
  end
end
