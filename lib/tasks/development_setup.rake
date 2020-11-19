namespace :development_setup do
  desc "TODO"
  task perform: [:environment, "db:drop", "db:create", "db:schema:load", "db:fixtures:load", "attach_sample_screenshots:perform"] do
  end
end
