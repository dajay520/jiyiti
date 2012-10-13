class AddUserIdToQqusers < ActiveRecord::Migration
  def change
    add_column :qqusers, :user_id, :integer

  end
end
