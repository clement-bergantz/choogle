namespace :users do
  desc "TODO"
  task delete_30_days_old_guests: :environment do
    User.where(['created_at < ? AND email LIKE ?', 30.days.ago, '%@example.com']).count
  end

end
