class Expense < ApplicationRecord
    belongs_to :user
    validates :title, presence: true, length: { minimum: 2 }
    validates :value, presence: true, numericality: true
    validate :validate_created_at

    private

    def convert_created_at
        begin
            self.created_at = Date.civil(self.created_at.year.to_i, self.created_at.month.to_i, self.created_at.day.to_i)
        rescue => error
            false
        end
    end

    def validate_created_at
        errors.add("Created at", "is invalid.") unless convert_created_at
    end
end
