if Rails.env.production?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :authentication => :plain,
    :address => "smtp.eu.mailgun.org",
    :port => 587,
    :domain => "admin@skladis.com",
    :user_name => ENV['SMTP_USERNAME'],
    :password => ENV['SMTP_PASSWORD']
  }
end
