class CreatePortfolios < ActiveRecord::Migration[8.1]
  def change
    create_table :portfolios do |t|
      t.string :title, null: false
      t.text :description
      t.string :client
      t.string :image_url
      t.boolean :published, null: false, default: false

      t.timestamps
    end

    add_index :portfolios, :published
  end
end
