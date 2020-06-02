class CreateAdConfirmationLettersExports < ActiveRecord::Migration[4.2]
  def change
    create_table :ad_confirmation_letters_exports do |t|
      t.date :created_on
      t.string :file_name
      t.integer :number_of_letters
      t.string :printed_by
      t.date :printed_on
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
