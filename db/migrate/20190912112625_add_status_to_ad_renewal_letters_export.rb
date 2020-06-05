class AddStatusToAdRenewalLettersExport < ActiveRecord::Migration[4.2]
  def change
    add_column :ad_renewal_letters_exports, :status, :integer, default: 0
  end
end
