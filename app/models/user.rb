class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ACCESSIBLE_ATTRS = [:email, :password, :password_confirmation, :remember_me]
  attr_accessible *ACCESSIBLE_ATTRS

  has_many :documents

  def anonymous?
    is_a? AnonymousUser
  end

end
