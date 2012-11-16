class CreateBounties < ActiveRecord::Migration
  def change
    create_table :bounties do |t|
      t.integer :user_id
      t.integer :issue_id
      t.integer :price

      t.timestamps
    end
  end
end
