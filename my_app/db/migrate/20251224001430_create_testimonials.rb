class CreateTestimonials < ActiveRecord::Migration[8.1]
  def change
    create_table :testimonials do |t|
      t.references :portfolio, null: false, foreign_key: true
      t.string :author
      t.string :company
      t.text :content
      t.integer :rating

      t.timestamps
    end
  end
end
