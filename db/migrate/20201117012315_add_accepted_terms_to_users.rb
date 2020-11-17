class AddAcceptedTermsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :accepted_terms, :boolean, null: false
  end
end
