class Profile < ApplicationRecord
  belongs_to :user
  validates :mob_no, length: { in: 10..14 }
end
