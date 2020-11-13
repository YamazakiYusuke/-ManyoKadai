class Task < ApplicationRecord
  belongs_to :user
  has_many :join_task_labels, dependent: :destroy
  has_many :labels, through: :join_task_labels

  validates :title, presence: true
  validates :content, presence: true

  scope :title_scope, -> (params_sarch_title) { where('title like?', "%#{params_sarch_title}%") }
  scope :status_scope, -> (params_sarch_status) { where(status:params_sarch_status) }
  scope :label_scope, -> (params_sarch_label) { where(id: params_sarch_label)}

  enum priority: { '低' => 0, '中' => 1, '高' => 2 }
end
