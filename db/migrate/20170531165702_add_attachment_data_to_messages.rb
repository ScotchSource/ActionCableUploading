class AddAttachmentDataToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :attachment_data, :text
  end
end
