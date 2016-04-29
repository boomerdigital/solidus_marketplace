class Spree::Supplier < Spree::Base
  belongs_to :address, class_name: 'Spree::Address'
  has_many   :users, class_name: Spree.user_class.to_s

  after_create :assign_user



  # Instance Methods
  scope :active, -> { where(active: true) }

  def deleted?
    deleted_at.present?
  end

  def user_ids_string
    user_ids.join(',')
  end

  def user_ids_string=(s)
    self.user_ids = s.to_s.split(',').map(&:strip)
  end

  #==========================================
  # Protected Methods

  protected

  def assign_user
    if self.users.empty?
      if user = Spree.user_class.find_by_email(self.email)
        self.users << user
        self.save
      end
    end
  end

end