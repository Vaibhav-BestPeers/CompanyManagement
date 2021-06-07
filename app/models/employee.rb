class Employee < User
    has_one :picture, as: :imageable , dependent: :destroy
    accepts_nested_attributes_for :picture, update_only: true
end
