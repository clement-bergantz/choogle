namespace :users do
  desc "Deleting guests older than 30 days"
  task delete_30_days_old_guests: :environment do
    User.where(['created_at < ? AND email LIKE ?', 30.days.ago, '%@example.com']).each do |user|
      user.destroy
    end
  end

end
