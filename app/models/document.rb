class Document < ActiveRecord::Base
  attr_accessible :content, :title, :shared
  before_create :generate_random_id
  before_create :set_title

  belongs_to :creator, :class_name => 'User',
                       :foreign_key => 'user_id',
                       :counter_cache => true

  validate :random_id, :presence   => true,
                       :uniqueness => true

  def to_param
    self.random_id
  end

private

  def set_title
    sibling_count = creator.documents_count
    self.title ||= "Untitled ##{sibling_count + 1}"
  end

  def generate_random_id
    self.random_id = SecureRandom.hex(16)
  end

end
