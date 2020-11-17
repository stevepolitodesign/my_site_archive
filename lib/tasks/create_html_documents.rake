namespace :create_html_documents do
  desc "Capture source code for webpages."
  task perform: :environment do
    CreateHtmlDocumentsJob.perform_later
  end
end
