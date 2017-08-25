class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @choogle = Choogle.new
    @proposal = Proposal.new
    @user = current_or_guest_user
  end

end
