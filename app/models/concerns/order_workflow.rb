module OrderWorkflow
  extend ActiveSupport::Concern
  
  included do
    include AASM
    enum state: { draft: 0, submitted: 1, fulfilled: 2, archived: 3, cancelled: 4 }
    
    
    aasm :column => :state, :whiny_transitions => false, enum: true do
      state :draft, :initial => true
      state :submitted
      state :fulfilled
      state :archived
      state :cancelled

      event :submit do
        transitions from: :draft, to: :submitted
      end

      event :fulfill do
        transitions from: :submitted, to: :fulfilled
      end
    
      event :archive do
        transitions from: :fulfilled, to: :archived
      end
      
      event :cancel do
        transitions from: [:draft, :submitted], to: :cancelled
      end
    end
    
  end
  
  def permissions
    {
      draft:      [:office, :admin],
      submitted:  [:warehouse, :finance, :custodial, :admin],
      fulfilled:  [:finance, :admin],
      archived:   [],
      cancelled:  []
    }
  end
  
  def approvables
    {
      draft: [],
      submitted: [:warehouse, :custodial],
      fulfilled: [],
      archived: [],
      cancelled: []
    }
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