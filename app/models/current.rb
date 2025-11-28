class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :user, to: :session, allow_nil: true

    # Pour tests uniquement :
    def user=(u)
      self.session = OpenStruct.new(user: u)
    end
end
