class Article < ApplicationRecord
  validates :title, presence: true 
  validates :content, presence: true
  validates :slug,presence: true, uniqueness: {case_sensitive: false}

  scope :recent, -> {order(created_at: :desc)}
end
