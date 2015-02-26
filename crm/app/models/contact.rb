class Contact < ActiveRecord::Base
  validates :name, :email, presence: true
  has_many :notes
end
