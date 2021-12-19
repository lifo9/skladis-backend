class CreateRegistrationInvitations < ActiveRecord::Migration[6.1]
  def change
    create_table :registration_invitations do |t|
      t.references :user, null: true, foreign_key: true
      t.string :key, null: false
      t.boolean :used, null: false, default: false

      t.timestamps
    end
  end
end
