class Post < ActiveRecord::Base
  module NamedExtension
    def author
      'lifo'
    end
  end

  scope :containing_the_letter_a, where("body LIKE '%a%'")
  scope :ranked_by_comments, order("comments_count DESC")

  scope :limit_by, lambda {|l| limit(l) }
  scope :with_authors_at_address, lambda { |address| {
      :conditions => [ 'authors.author_address_id = ?', address.id ],
      :joins => 'JOIN authors ON authors.id = posts.author_id'
    }
  }

  belongs_to :author do
    def greeting
      "hello"
    end
  end

  belongs_to :author_with_posts, :class_name => "Author", :foreign_key => :author_id, :include => :posts
  belongs_to :author_with_address, :class_name => "Author", :foreign_key => :author_id, :include => :author_address

  has_one :last_comment, :class_name => 'Comment', :order => 'id desc'

  scope :with_special_comments, :joins => :comments, :conditions => {:comments => {:type => 'SpecialComment'} }
  scope :with_very_special_comments, joins(:comments).where(:comments => {:type => 'VerySpecialComment'})
  scope :with_post, lambda {|post_id|
    { :joins => :comments, :conditions => {:comments => {:post_id => post_id} } }
  }

  has_many   :comments do
    def find_most_recent
      find(:first, :order => "id DESC")
    end
  end


  def self.top(limit)
    ranked_by_comments.limit_by(limit)
  end

  def self.reset_log
    @log = []
  end

  def self.log(message=nil, side=nil, new_record=nil)
    return @log if message.nil?
    @log << [message, side, new_record]
  end

  def self.what_are_you
    'a post...'
  end
end

class SpecialPost < Post; end

class StiPost < Post
  self.abstract_class = true
  has_one :special_comment, :class_name => "SpecialComment"
end
