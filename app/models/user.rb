class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:confirmable

  has_one :profile, dependent: :destroy
  has_one :employee, dependent: :destroy
  has_one :admin, dependent: :destroy
  
  has_one :picture, as: :imageable , dependent: :destroy
  accepts_nested_attributes_for :picture, update_only: true

  accepts_nested_attributes_for :profile, update_only: true

  has_many :employee_skills, dependent: :destroy
  has_many :skills, through: :employee_skills

  has_many :chats , dependent: :destroy 
  

end
