class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.string :title
      t.float :value

      t.timestamps
    end
  end
end
