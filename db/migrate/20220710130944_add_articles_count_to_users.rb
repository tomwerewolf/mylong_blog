class AddArticlesCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :articles_count, :integer
  end
end
