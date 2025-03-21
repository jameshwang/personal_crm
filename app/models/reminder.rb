class Reminder < ApplicationRecord
  belongs_to :user
  belongs_to :contact, optional: true
  
  validates :title, presence: true
  validates :date, presence: true
  validates :status, presence: true, inclusion: { in: ['pending', 'completed'] }
  
  before_validation :set_default_status
  
  scope :upcoming, -> { where(status: 'pending').where('date >= ?', Time.current).order(date: :asc) }
  scope :past_due, -> { where(status: 'pending').where('date < ?', Time.current).order(date: :desc) }
  scope :completed, -> { where(status: 'completed').order(date: :desc) }
  scope :pending, -> { where(status: 'pending') }
  scope :today, -> { pending.where('date >= ? AND date <= ?', Time.current.beginning_of_day, Time.current.end_of_day) }
  scope :this_week, -> { pending.where('date >= ? AND date <= ?', Time.current.beginning_of_week, Time.current.end_of_week) }
  scope :by_date, ->(start_date, end_date) { where('date >= ? AND date <= ?', start_date, end_date) }
  
  def past_due?
    date < Time.current && status == 'pending'
  end
  
  def upcoming?
    date >= Time.current && status == 'pending'
  end

  def pending?
    status == 'pending'
  end

  def completed?
    status == 'completed'
  end

  private

  def set_default_status
    self.status ||= 'pending'
  end
end
