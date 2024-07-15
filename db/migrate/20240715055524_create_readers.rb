class CreateReaders < ActiveRecord::Migration[6.1]
  def change
    create_table :readers do |t|
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
