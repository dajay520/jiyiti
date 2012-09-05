class CreateQqusers < ActiveRecord::Migration
  def change
    create_table :qqusers do |t|
      t.string :open_id
      t.string :name
      t.string :token
      t.date :gmt_created
      t.date :gmt_modified

      t.timestamps
    end
  end
end
