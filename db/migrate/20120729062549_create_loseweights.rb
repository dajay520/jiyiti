class CreateLoseweights < ActiveRecord::Migration
  def change
    create_table :loseweights do |t|
      t.string :weight
      t.string :hipline
      t.string :legline
      t.date :update_date

      t.timestamps
    end
  end
end
