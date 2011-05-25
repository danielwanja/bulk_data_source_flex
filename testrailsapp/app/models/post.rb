class Post < ActiveRecord::Base
  module NamedExtension
    def author
      'lifo'
    end
  end

  belongs_to :author do
    def greeting
      "hello"
    end
  end

  has_one :last_comment, :class_name => 'Comment', :order => 'id desc'

  has_many   :comments do
    def find_most_recent
      find(:first, :order => "id DESC")
    end
  end

end