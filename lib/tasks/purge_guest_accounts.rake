namespace :purge_guest_accounts do
  desc "Deletes guest users and associated records"
  task perform: :environment do
    PurgeGuestAccountsJob.perform_later
  end

end
