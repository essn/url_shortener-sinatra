class ChangeShortUrlShortUrlToSlug < ActiveRecord::Migration[6.0]
  def change
    remove_column :short_urls, :short_url, :string
    add_column :short_urls, :slug, :string, null: false, index: { unique: true }
  end
end
