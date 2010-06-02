class Comment < ActiveRecord::Base

  has_many :replies, :class_name => 'Comment'
  belongs_to :story
  belongs_to :comment

end
