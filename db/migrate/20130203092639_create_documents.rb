class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.text :content
      t.string :title, :null => true
      t.string :random_id
      t.boolean :shared, :default => false
      t.integer :user_id

      t.timestamps
    end

    add_index :documents, :random_id, :unique => true
  end
end
