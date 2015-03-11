module OrderWorkflow
  extend ActiveSupport::Concern
  
  included do
    include AASM
    enum state: { draft: 0, reviewing: 1, submitted: 2, fulfilled: 3, archived: 4, cancelled: 5 }
    
    aasm :column => :state, :whiny_transitions => false, enum: true do
      state :draft, :initial => true
      state :reviewing
      state :submitted
      state :fulfilled
      state :archived
      state :cancelled
      
      event :review do
        transitions from: :draft, to: :reviewing
      end
      
      event :submit do
        transitions from: :reviewing, to: :submitted
      end

      event :fulfill do
        transitions from: :submitted, to: :fulfilled
      end
    
      event :archive do
        transitions from: :fulfilled, to: :archived
      end
      
      event :cancel do
        transitions from: [:draft, :reviewing, :submitted], to: :cancelled
      end
    end
    
  end
  
  def permissions
    {
      draft:      [:admin, :office, :principal],
      reviewing:  [:admin, :principal, :custodial],
      submitted:  [:admin, :warehouse, :finance],
      fulfilled:  [:admin, :finance],
      archived:   [],
      cancelled:  []
    }
  end
  
  def approvables
    {
      draft: [],
      reviewing: [:custodial, :principal],
      submitted: [],
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