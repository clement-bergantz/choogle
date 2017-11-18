namespace :choogle do
  desc "Sending an email when a Choogle reaches its deadline"
  task complete: :environment do
    Choogle.where("DATE(due_at) = ? AND completed = ?", Time.zone.today, false).find_each do |choogle|
      choogle.notifications.each do |notification|
        if choogle.due_at_tz < Time.current
          UserMailer.results(notification.user.id)
        end
      end
      TimeUpJob.perform_later(choogle.id)
    end
  end

end
