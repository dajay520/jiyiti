class AddUserIdToLoseweights < ActiveRecord::Migration
  def change
    add_column :loseweights, :user_id, :integer

  end
end
