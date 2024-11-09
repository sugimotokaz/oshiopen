class Notification < ApplicationRecord
  belongs_to :visitor, class_name: "User"
  belongs_to :visited, class_name: "User"
  belongs_to :article, optional: true
  belongs_to :comment, optional: true
end
