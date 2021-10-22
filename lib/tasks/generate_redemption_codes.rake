# rails "generate_redemption_codes:perform[100, 1, YYYYMMDD]"
namespace :generate_redemption_codes do
  desc "TODO"
  task :perform, [:number_of_records_to_create, :plan_id, :trial_ends_at] => [:environment] do |task, args|
    args[:number_of_records_to_create].to_i.times do |i|
      redemption_code = RedemptionCode.new(
        plan_id: args[:plan_id],
        trial_ends_at: args[:trial_ends_at].present? ? args[:trial_ends_at].to_date : nil,
        value: SecureRandom.alphanumeric
      )
      puts redemption_code.attributes if redemption_code.save
    end
    puts RedemptionCode.last(args[:number_of_records_to_create].to_i).pluck(:value)
  end

end
