class AddSocialIdentifier < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.string :rpx_identifier
    end
  end
end
