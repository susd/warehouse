# == Schema Information
#
# Table name: approvals
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  role_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Approval < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  belongs_to :order
  
  validate :approvable_by_user
  
  def approvable_by_user
    order.approvable_by? self.user
  end
end
