class AddTwoFactorStateToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :two_factor_state, :string
  end
end
