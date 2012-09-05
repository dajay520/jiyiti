class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :open_id
      t.string :email
      t.string :phone
      t.string :name
      t.string :remark
      t.string :status
      t.string :type

      t.timestamps
    end
  end
end
