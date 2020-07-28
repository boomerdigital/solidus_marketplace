# frozen_string_literal: true

module Ckeditor
  module AssetDecorator
    def self.prepended(base)
      base.belongs_to :supplier, class_name: '::Spree::Supplier'
    end

    if defined?(Ckeditor::Asset)
      Ckeditor::Asset.prepend self
    end
  end
end
