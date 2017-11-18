class TimeUpJob < ApplicationJob
  queue_as :default

  def perform(choogle_id)
    choogle = Choogle.find(choogle_id)
    puts "Let's complete this Choogle..."
    choogle.completed = true
    choogle.save
    puts "Aaaaand it's done!"
  end
end
