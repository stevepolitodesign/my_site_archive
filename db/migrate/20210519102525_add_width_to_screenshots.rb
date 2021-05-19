class AddWidthToScreenshots < ActiveRecord::Migration[6.0]
  def change
    add_column :screenshots, :width, :integer, default: 10204
  end
end
