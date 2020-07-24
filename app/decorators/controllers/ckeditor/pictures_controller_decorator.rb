# frozen_string_literal: true

module Ckeditor
  module PicturesControllerDecorator
    def self.prepended(base)
      base.load_and_authorize_resource class: 'Ckeditor::Picture'
      base.after_filter :set_supplier, only: [:create]
    end

    def index
    end

    private

    def set_supplier
      if spree_current_user.supplier? and @picture
        @picture.supplier = spree_current_user.supplier
        @picture.save
      end
    end

    if defined?(Ckeditor::PicturesController)
      Ckeditor::PicturesController.prepend self
    end
  end
end
