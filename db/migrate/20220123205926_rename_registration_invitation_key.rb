class RenameRegistrationInvitationKey < ActiveRecord::Migration[7.0]
  def change
    rename_column :registration_invitations, :key, :registration_key
  end
end
