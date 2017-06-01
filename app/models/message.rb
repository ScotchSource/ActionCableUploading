class Message < ApplicationRecord
  belongs_to :user

  validates :body, presence: true, unless: :attachment_data

  after_create_commit :broadcast_message

  include AttachmentUploader[:attachment]

  # virtual attributes for temp storage of attachment's original name
  def attachment_name=(name)
    @attachment_name = name
  end

  def attachment_name
    @attachment_name
  end

  private

  def broadcast_message
    MessageBroadcastJob.perform_later(self)
  end
end
