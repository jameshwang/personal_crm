class Contact < ApplicationRecord
  has_many :interactions, dependent: :destroy
  has_many :reminders, dependent: :destroy
  has_many :contact_tags, dependent: :destroy
  has_many :tags, through: :contact_tags

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }

  def full_name
    "#{first_name} #{last_name}"
  end
end
