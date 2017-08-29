module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_or_guest_user
  end
end
