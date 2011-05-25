class Author < ActiveRecord::Base
  
  def as_json(options={})
    #super(:include =>{:pots => :comments})
    super(:include =>{:posts => {:include  => :comments}}) 
  end  
  
  has_many :posts
  has_many :comments, :through => :posts

  has_one :essay, :primary_key => :name, :as => :writer

  def label
    "#{id}-#{name}"
  end


  validates_presence_of :name

end
