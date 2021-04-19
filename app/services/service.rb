class Service
  def self.perform(*args)
    instance = self.new
    instance.perform(*args)
  end

  def perform(args)
    raise 'You need to overwrite this method in actual service'
  end
end
