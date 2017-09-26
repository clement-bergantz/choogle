class Choogle < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :proposals
  has_many :notifications
  has_many :places, through: :proposals

  validates :slug, presence: true

  validate do |choogle|
    choogle.errors.add(:base, "Please add a title to your poll, so your friends understand what it is") if choogle.title.blank?
    choogle.errors.add(:base, "Please tell your friends when the event will take place") if choogle.happens_at.blank?
    choogle.errors.add(:base, "Please set a deadline for your poll") if choogle.due_at.blank?
  end

  validate :happens_at_cannot_be_in_the_past, :due_at_cannot_be_in_the_past, :due_at_must_be_before_happens_at

  before_validation :generate_slug, on: :create

  def generate_slug
    slug = SecureRandom.urlsafe_base64(5)
    while Choogle.find_by(slug: slug)
      slug = SecureRandom.urlsafe_base64(5)
    end
    self.slug = slug
  end

  # slug in the params
  def to_param
    slug
  end

  def happens_at_cannot_be_in_the_past
    if happens_at.present? && happens_at < Date.today
      errors.add(:happens_at, "Sorry, but you can not use choogle in the past 😊")
    end
  end

  def due_at_cannot_be_in_the_past
    if due_at.present? && due_at < Date.today
      errors.add(:due_at, "The deadline can not be in the past 😊")
    end
  end

  def due_at_must_be_before_happens_at
    if due_at.present? && happens_at.present? && due_at >= happens_at
      errors.add(:base, "The deadline should be set before the date of your event 😊")
    end
  end

  # def winning_proposal
  #   proposals.
  # end
end
