class Interaction < ApplicationRecord
  belongs_to :user
  belongs_to :contact

  VALID_TYPES = ['Call', 'Email', 'Meeting', 'Video Call'].freeze

  validates :interaction_type, presence: true, inclusion: { in: VALID_TYPES }
  validates :date, presence: true

  default_scope { order(date: :desc) }
end
