class CreateClients < ActiveRecord::Migration[6.1]
  def change
    create_table :clients do |t|
      t.string :email
      t.string :password
      t.string :password_digest
      t.string :string

      t.timestamps
    end
  end
end
