module ApplicationHelper

  def usertags
    usertags = []
    current_or_guest_user.proposals.each do |proposal|
      usertags << proposal.tags.map(&:name)
    end
    usertags.flatten
  end

end
