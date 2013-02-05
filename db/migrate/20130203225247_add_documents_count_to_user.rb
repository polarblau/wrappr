class AddDocumentsCountToUser < ActiveRecord::Migration
  def up
    add_column :users, :documents_count, :integer, :default => 0

    User.reset_column_information
    User.find(:all).each do |u|
      User.update_counters u.id, :documents_count => u.documents.length
    end
  end

  def down
    remove_column :users, :documents_count
  end
end
