class AddDiretorColumn < ActiveRecord::Migration
  def up
    add_column :movies, :director, :string
  end

  def down
  end
end
