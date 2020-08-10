class CreateShortUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :short_urls do |t|
      t.string :original_url, null: false
      t.string :short_url, index: { unique: true }, null: false
      t.string :secret_key, index: { unique: true }, null: false

      t.timestamps
    end
  end
end
