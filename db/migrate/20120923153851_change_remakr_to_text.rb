class ChangeRemakrToText < ActiveRecord::Migration
  def change
    change_column :loseweights, :remark, :text

  end
end
