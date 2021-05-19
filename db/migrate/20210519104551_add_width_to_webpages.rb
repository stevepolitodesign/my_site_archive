class AddWidthToWebpages < ActiveRecord::Migration[6.0]
  def change
    add_column :webpages, :width, :integer, default: 1024
  end
end
