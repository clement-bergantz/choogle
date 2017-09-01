class Tag < ApplicationRecord
	has_many :proposal_tags
	validates :color, presence: true
	validates :name, presence: true, uniqueness: true, length: { maximum: 20 }

  COLORS = %w(
    #1abc9c
    #2ecc71
    #3498db
    #9b59b6
    #34495e
    #f1c40f
    #e67e22
    #e74c3c
    #95a5a6
    #E91E63
    #9C27B0
    #673AB7
    #3F51B5
    #FFC107
    #8BC34A
    #795548
    #607D8B
    #009688
    #FF5722
  )
  def color_hex
    index = name.each_byte.reduce(:+)
    COLORS[ index % COLORS.size ]
  end

end
