namespace :images_attacher do
  desc "TODO"
  task perform: :environment do
    ImagesAttacherJob.perform_later
  end

end
