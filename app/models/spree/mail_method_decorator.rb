Spree::Core::MailMethod.class_eval do
  def settings
    mail_server_settings
  end
end