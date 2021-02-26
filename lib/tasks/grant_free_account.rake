# rails "grant_free_account:perform[user@example.com, some_password, abc123]"
namespace :grant_free_account do
  desc "Create a user and grant them a free account."
  task :perform, [:email, :password, :processor_id] => [:environment] do |task, args|
    @user = User.create(
      email: args.email,
      password: args.password,
      password_confirmation: args.password,
      confirmed_at: Time.zone.now,
      accepted_terms: true,
      processor: :fake_processor,
      processor_id: rand(1_000_000),
      pay_fake_processor_allowed: true
    )
    @user.subscribe(plan: args.processor_id)
  end

end