class User < ActiveRecord::Base
  # validates :name, presence: true

  # validates :email, presence: true
  # validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  # validates :email, uniqueness: true
end
