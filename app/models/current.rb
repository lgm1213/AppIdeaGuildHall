class Current < ActiveSupport::CurrentAttributes
  attribute :session, :user, :campaign, :membership

  delegate :user, to: :session, allow_nil: true
end
