class AddActivationKeyToRegistrationInvitation < ActiveRecord::Migration[6.1]
  def change
    add_column :registration_invitations, :activation_key, :string, null: false, default: false
  end
end
