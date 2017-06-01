class AttachmentUploader < Shrine
  plugin :add_metadata

  add_metadata do |io, context|
   {'filename' => context[:record].attachment_name}
  end

  plugin :data_uri
end