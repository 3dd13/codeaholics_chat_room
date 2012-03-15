class ChatRoom < ActiveRecord::Base
  class UnauthorizedOperationError < StandardError; end
    
  #   TODO move this key to environment
  attr_encrypted :password, :key => "no one can see this key!", :attribute => 'password_encrypted'
  
  belongs_to :hosted_by_user, :class_name => "User"
  has_many :messages, :dependent => :destroy
  
  state_machine :status, :initial => :pending do
    event :start do
      transition :pending => :started
    end

    event :close do
      transition :started => :closed
    end

    state :pending do
      def can_start?
        true
      end
      def can_close?
        false
      end
    end
    
    state :started do
      def can_start?
        false
      end
      def can_close?
        true
      end
    end
    state :closed
  end
  
  def add_attendee(new_comer)
    @attendees ||= []
    @attendees << new_comer unless @attendees.include?(new_comer)
  end
  
  def start_by_user(user)
    raise UnauthorizedOperationError if user != self.hosted_by_user
    self.start! 
  end
  
  def close_by_user(user)
    raise UnauthorizedOperationError if user != self.hosted_by_user
    self.close! 
  end
  
  def verify_password?(provided_password)
    provided_password.present? && self.password == provided_password
  end
  
  def access_control
    private_room? ? "private" : "public"
  end
  
  def self.started
    self.where(:status => "started")
  end
end
