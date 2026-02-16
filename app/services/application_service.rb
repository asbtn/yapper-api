class ApplicationService

  include ActiveModel::Validations

  attr_reader :result

  def call
    raise NotImplementedError
  end

  def self.call(*, **)
    new(*, **).call
  end

  def success?
    errors.empty?
  end

  def failure?
    !success?
  end

  private

  def success(object = nil)
    @result = object
    errors.clear
    self
  end

  def failure(key, error)
    @result = nil
    errors.add(key, error)
    self
  end

end
