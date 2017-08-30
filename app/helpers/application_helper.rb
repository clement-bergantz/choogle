module ApplicationHelper

  # This helper is used to sort proposals by upvotes (most in first place)
  def sort_prop_by_upvotes(proposals)
    sorted = proposals.sort_by do |proposal|
      proposal.upvotes.size
    end
    sorted.reverse
  end

  def guest_first_name
    if current_or_guest_user.first_name.scan(/guest/) != []
      ""
    else
      current_or_guest_user.first_name
    end
  end

  def guest_email
    if current_or_guest_user.email.scan(/guest/) != []
      ""
    else
      current_or_guest_user.email
    end
  end

end
