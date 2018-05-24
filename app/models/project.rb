class Project < ApplicationRecord
  has_attached_file :logo
  validates_attachment :logo, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  # Explicitly do not validate
  # do_not_validate_attachment_file_type :avatar
end
