class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :isbn
      t.text :description
      t.date :published_date
      t.integer :page_count
      t.integer :author_id
      t.integer :category_id

      t.timestamps
    end
  end
end
