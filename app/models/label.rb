class Label < ApplicationRecord
  has_many :join_task_labels, dependent: :destroy
  has_many :tasks, through: :join_task_labels
end
