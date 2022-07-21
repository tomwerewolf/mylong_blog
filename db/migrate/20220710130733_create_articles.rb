class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.string :status
      t.bigint :category_id
      t.bigint :user_id

      t.timestamps
    end
  end
end
