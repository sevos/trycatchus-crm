class Contact < ActiveRecord::Base
  validates :name, :email, presence: true
  has_many :notes
  belongs_to :owner, class_name: 'User'
end
