class AddRemarkToLoseweight < ActiveRecord::Migration
  def change
    add_column :loseweights, :remark, :string

  end
end
