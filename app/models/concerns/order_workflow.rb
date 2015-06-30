module OrderWorkflow
  extend ActiveSupport::Concern
  
  included do
    include AASM
    enum state: { draft: 0, submitted: 1, approved: 2, fulfilled: 3, archived: 4, cancelled: 5 }
    
    aasm column: :state, whiny_transitions: false, enum: true do
      state :draft, :initial => true
      state :submitted
      state :approved
      state :fulfilled
      state :archived
      state :cancelled
      
      event :submit do
        transitions from: :draft, to: :submitted
      end
      
      event :approve do
        transitions from: :submitted, to: :approved
      end

      event :fulfill do
        transitions from: :approved, to: :fulfilled
      end
    
      event :archive do
        transitions from: :fulfilled, to: :archived
      end
      
      event :cancel do
        transitions from: [:draft, :submitted, :approved], to: :cancelled
      end
    end
    
  end
  
  def state_names
    Order.states.keys.map(&:to_sym)
  end
  
  def permissions
    {
      draft:      [:admin, :staff, :principal],
      submitted:  [:admin, :principal, :quantity],
      approved:   [:admin, :warehouse, :finance],
      fulfilled:  [:admin, :finance],
      archived:   [],
      cancelled:  []
    }
  end
  
  def approvables
    {
      draft: [],
      submitted: [:principal, :quantity],
      approved: [],
      fulfilled: [],
      archived: [],
      cancelled: []
    }
  end
  
  def requirements
    {
      draft: [], submitted: [:principal, :quantity], approved: [], fulfilled: [], archived: [], cancelled: []
    }
  end
  
  def required_roles
    Role.where(name: requirements[self.state.to_sym].map(&:to_s))
  end
  
  def requirements_met?
    required_roles.all? do |role|
      approvals.where(role: role).any?
    end
  end
  
  def editable_by?(user)
    user.roles.any? do |role|
      self.permissions[self.state.to_sym].include? role.name.downcase.to_sym
    end
  end
  
  def approvable_by?(user)
    user.roles.any? do |role|
      self.approvables[self.state.to_sym].include? role.name.downcase.to_sym
    end
  end
  
  def next_step
    (aasm.events - [:cancel]).first
  end
  
end