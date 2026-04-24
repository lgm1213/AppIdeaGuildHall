class Campaign::Invitation < ApplicationRecord
  belongs_to :campaign

  before_create :generate_token

  private
    def generate_token
      self.token = loop do
        candidate = SecureRandom.alphanumeric(8).upcase
        break candidate unless Campaign::Invitation.exists?(token: candidate)
      end
    end
end
