class ErrorSerializer

  def initialize(errors)
    @errors = errors
  end

  def self.from_hash(errors_hash)
    errors = ActiveModel::Errors.new(Object.new)
    errors_hash.each { |attr, msgs| Array(msgs).each { |msg| errors.add(attr, msg) } }
    new(errors)
  end

  def serializable_hash
    {
      errors: {
        full_messages: errors.full_messages,
        details: errors.to_hash
      }
    }
  end

  private

  attr_reader :errors

end
