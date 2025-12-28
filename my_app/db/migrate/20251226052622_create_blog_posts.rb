class CreateBlogPosts < ActiveRecord::Migration[8.1]
  def change
    create_table :blog_posts do |t|
      t.string :title, null: false
      t.text :excerpt
      t.text :content
      t.string :author
      t.string :category
      t.string :image_url
      t.boolean :published, default: false
      t.datetime :published_at

      t.timestamps
    end

    add_index :blog_posts, :published
    add_index :blog_posts, :category
    add_index :blog_posts, :published_at
  end
end
