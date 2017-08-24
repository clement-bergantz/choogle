class Choogle < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :proposals
  has_many :notifications
  has_many :places, through: :proposals

  validates :slug, presence: true
  validates :title, presence: true
  validates :happens_at, presence: true
  validates :due_at, presence: true

  validate :happens_at_cannot_be_in_the_past, :due_at_cannot_be_in_the_past, :due_at_must_be_before_happens_at

  # slug in the params
  def to_param
    slug
  end

  def happens_at_cannot_be_in_the_past
    if happens_at.present? && happens_at < Date.today
      errors.add(:happens_at, "Event date must be in the future")
    end
  end

  def due_at_cannot_be_in_the_past
    if due_at.present? && due_at < Date.today
      errors.add(:due_at, "Closing votes date must be in the future")
    end
  end

  def due_at_must_be_before_happens_at
    if due_at >= happens_at
      errors.add(:due_at, "Due date should be set before Choogle date!")
    end
  end

end
