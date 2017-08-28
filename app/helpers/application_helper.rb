module ApplicationHelper

  def usertags
    usertags = []
    current_or_guest_user.proposals.each do |proposal|
      usertags << proposal.tags.map(&:name)
    end
    usertags.flatten
  end

  def sort_prop_by_upvotes(proposals)
    sorted = proposals.sort_by do |proposal|
      proposal.upvotes.size
    end
    sorted.reverse
  end
end
