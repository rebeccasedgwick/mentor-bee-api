class ChangeColumnDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:users, :pic, nil)
  end
end
