class AddAttachmentAvatarToSaleProfiles < ActiveRecord::Migration
  def self.up
    change_table :sale_profiles do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :sale_profiles, :avatar
  end
end
