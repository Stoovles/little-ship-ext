class Review < ApplicationRecord
  belongs_to :item
  belongs_to :user

  validates_presence_of :title, :description, :rating
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5}
end
