class ApplicationMailer < ActionMailer::Base
  default from: 'donotreply@mysitestatus.com'
  layout 'mailer'
end
