module ApplicationHelper

  # This helper is used to get all tags of the current user
  def usertags
    usertags = []
    current_or_guest_user.proposals.each do |proposal|
      usertags << proposal.tags.map(&:name)
    end
    usertags.flatten
  end

  # This heloer is used to sort proposals by upvotes (most in first place)
  def sort_prop_by_upvotes(proposals)
    sorted = proposals.sort_by do |proposal|
      proposal.upvotes.size
    end
    sorted.reverse
  end
end
