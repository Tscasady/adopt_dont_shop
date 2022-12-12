class AddPetBidReasonToApplication < ActiveRecord::Migration[5.2]
  def change
    add_column :applications, :bid_reason, :string
  end
end
