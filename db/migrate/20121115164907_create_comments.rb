class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.datetime :git_update_at
      t.integer :git_number
      t.string :owner_name
      t.string :owner_image
      t.integer :issue_id

      t.timestamps
    end
  end
end
