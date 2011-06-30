class InitialSetup < ActiveRecord::Migration
  # FIXME: use new 3.1 generatiaon
  def self.up
    create_table :authors, :force => true do |t|
      t.string :name, :null => false
      t.integer :author_address_id
      t.integer :author_address_extra_id
      t.string :organization_id
      t.string :owned_essay_id
    end
    create_table :comments, :force => true do |t|
      t.integer :post_id, :null => false
      t.text    :body, :null => false
      t.integer :taggings_count, :default => 0
    end
    create_table :essays, :force => true do |t|
      t.string :name
      t.string :writer_id
      t.string :writer_type
      t.string :category_id
      t.string :author_id
    end
    create_table :posts, :force => true do |t|
      t.integer :author_id
      t.string  :title, :null => false
      t.text    :body, :null => false
      t.integer :comments_count, :default => 0
      t.integer :taggings_count, :default => 0
      t.integer :taggings_with_delete_all_count, :default => 0
      t.integer :taggings_with_destroy_count, :default => 0
      t.integer :tags_count, :default => 0
      t.integer :tags_with_destroy_count, :default => 0
      t.integer :tags_with_nullify_count, :default => 0
    end            
  end

  def self.down
    drop_table :posts
    drop_table :essays
    drop_table :comments
    drop_table :authors
  end
end
