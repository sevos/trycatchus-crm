class Note < ActiveRecord::Base
  belongs_to :contact
  validates :title, presence: true
  belongs_to :owner, class_name: 'User'
end
