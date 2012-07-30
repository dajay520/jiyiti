class AddGmtCreateToLoseweight < ActiveRecord::Migration
  def change
    add_column :loseweights, :gmt_create, :datetime

    add_column :loseweights, :gmt_modified, :datetime

  end
end
