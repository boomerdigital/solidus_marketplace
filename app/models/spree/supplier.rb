module Spree
  class Supplier < Spree::Base
    extend FriendlyId
    friendly_id :name, use: :slugged

    attr_accessor :password, :password_confirmation

    belongs_to :user, class_name: Spree.user_class.to_s, optional: true
    belongs_to :admin, class_name: Spree.user_class.to_s, optional: true
    belongs_to :address, class_name: 'Spree::Address'
    accepts_nested_attributes_for :address

    if defined?(Ckeditor::Asset)
      has_many :ckeditor_pictures
      has_many :ckeditor_attachment_files
    end

    has_many :supplier_variants
    has_many :variants, through: :supplier_variants
    has_many :products, through: :variants
    has_many :stock_locations
    has_many :shipments, through: :stock_locations
    has_many :users, class_name: Spree.user_class.to_s
    has_many :admins, class_name: Spree.user_class.to_s
    accepts_nested_attributes_for :admins

    validates :commission_flat_rate, presence: true
    validates :commission_percentage, presence: true
    validates :name, presence: true, uniqueness: true
    validates :url, format: { with: URI::regexp(%w(http https)), allow_blank: true }

    before_validation :check_url

    before_create :set_commission
    after_create :assign_user
    after_create :create_stock_location
    after_create :send_welcome, if: -> { SolidusMarketplace::Config[:send_supplier_email] }

    self.whitelisted_ransackable_attributes = %w[name]

    scope :active, -> { where(active: true) }

    def deleted?
      deleted_at.present?
    end

    def user_ids_string
      user_ids.join(',')
    end

    def admin_ids_string
      admin_ids.join(',')
    end

    def user_ids_string=(user_ids)
      self.user_ids = user_ids.to_s.split(',').map(&:strip)
    end

    def admin_ids_string=(admin_ids)
      self.admin_ids = admin_ids.to_s.split(',').map(&:strip)
    end

    # Retreive the stock locations that has available
    # stock items of the given variant
    def stock_locations_with_available_stock_items(variant)
      stock_locations.select { |sl| sl.available?(variant) }
    end

    protected

    def assign_user
      if self.users.empty?
        self.users << self.admin
        self.save
      end
    end

    def check_url
      unless self.url.blank? or self.url =~ URI::regexp(%w(http https))
        self.url = "http://#{self.url}"
      end
    end

    def create_stock_location
      if self.stock_locations.empty?
        location = self.stock_locations.build(
          active: true,
          country_id: self.address.try(:country_id),
          name: self.name,
          state_id: self.address.try(:state_id)
        )
        # It's important location is always created.  Some apps add validations that shouldn't break this.
        location.save validate: false
      end
    end

    def send_welcome; end

    def set_commission
      unless changes.has_key?(:commission_flat_rate)
        self.commission_flat_rate = SolidusMarketplace::Config[:default_commission_flat_rate]
      end
      unless changes.has_key?(:commission_percentage)
        self.commission_percentage = SolidusMarketplace::Config[:default_commission_percentage]
      end
    end
  end
end
