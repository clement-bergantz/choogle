module ApplicationHelper

  # This helper is used to sort proposals by upvotes (most in first place)
  def sort_prop_by_upvotes(proposals)
    sorted = proposals.sort_by do |proposal|
      proposal.upvotes.size
    end
    sorted.reverse
  end
end
