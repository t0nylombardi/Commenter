class CreateInviteToken < ActiveRecord::Migration
  def change
    create_table :invite_token do |t|
      t.string :user_id
      t.string :token

      t.timestamps
    end
  end
end