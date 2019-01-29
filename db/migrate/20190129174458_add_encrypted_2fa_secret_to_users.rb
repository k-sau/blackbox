class AddEncrypted2faSecretToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :encrypted_2fa_secret, :string
  end
end
