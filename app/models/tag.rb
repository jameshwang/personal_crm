class Tag < ApplicationRecord
  has_many :contact_tags, dependent: :destroy
  has_many :contacts, through: :contact_tags
  
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
  before_save :capitalize_name
  
  private
  
  def capitalize_name
    self.name = name.capitalize if name.present?
  end
end
