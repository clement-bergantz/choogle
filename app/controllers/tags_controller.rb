class TagsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:tag_color]

  def tag_color
    render json: { color: Tag.new(name: params[:tag]).color_hex }
  end
end
