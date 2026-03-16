class CreateDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :documents do |t|
      t.uuid :content_store_id, null: false
      t.string :title, null: false
      t.vector :embedding, limit: 2560
      t.timestamps
    end
  end
end
