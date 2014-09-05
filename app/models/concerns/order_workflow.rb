module OrderWorkflow
  extend ActiveSupport::Concern
  
  included do
    include AASM
    enum state: { draft: 0, pending: 1, fulfilled: 2, archived: 3, canceled: 4 }
    
    
    aasm :column => :state, :whiny_transitions => false do
      state :draft, :initial => true
      state :pending
      state :fulfilled
      state :archived
      state :canceled

      event :submit do
        transitions from: :draft, to: :pending
      end

      event :fulfill do
        transitions from: :pending, to: :fulfilled
      end
    
      event :archive do
        transitions from: :fulfilled, to: :archived
      end
      
      event :cancel do
        transitions from: [:draft, :pending], to: :canceled
      end
    end
    
  end
  
  
end