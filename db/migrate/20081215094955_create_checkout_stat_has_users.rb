class CreateCheckoutStatHasUsers < ActiveRecord::Migration[5.1]
  def self.up
    create_table :checkout_stat_has_users do |t|
      t.integer :user_checkout_stat_id, null: false
      t.integer :user_id, null: false
      t.integer :checkouts_count, default: 0, null: false

      t.timestamps
    end
    add_index :checkout_stat_has_users, :user_checkout_stat_id
    add_index :checkout_stat_has_users, :user_id
  end

  def self.down
    drop_table :checkout_stat_has_users
  end
end
