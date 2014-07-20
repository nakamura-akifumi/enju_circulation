class CreateMessageTransitions < ActiveRecord::Migration
  def change
    create_table :message_transitions do |t|
      t.string :to_state
      t.text :metadata, default: "{}"
      t.integer :sort_key
      t.integer :message_id
    end

    add_index :message_transitions, :message_id
    add_index :message_transitions, [:sort_key, :message_id], unique: true
  end
end