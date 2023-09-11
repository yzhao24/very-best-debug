class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.integer :author_id
      t.string :body
      t.integer :venue_id

      t.timestamps
    end
  end
end
