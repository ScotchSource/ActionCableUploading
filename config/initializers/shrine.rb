require "shrine"
require "shrine/storage/file_system"

Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store"),
}

Shrine.plugin :activerecord
Shrine.plugin :determine_mime_type
Shrine.plugin :validation_helpers, default_messages: {
    mime_type_inclusion: ->(whitelist) {
      "isn't of allowed type. It must be an image."
    }
}

Shrine::Attacher.validate do
  validate_mime_type_inclusion [
                                   'image/jpeg',
                                   'image/png',
                                   'image/gif'
                               ]
  validate_max_size 1.megabyte
end
