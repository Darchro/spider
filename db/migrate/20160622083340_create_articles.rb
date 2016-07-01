class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.references :account, index: true
      t.references  :category, index: true
      t.string :title
      t.integer :cnt_read
      t.integer :cnt_like
      t.integer :cnt_comment
      t.integer :cnt_admiration
      t.timestamps
    end
  end
end
