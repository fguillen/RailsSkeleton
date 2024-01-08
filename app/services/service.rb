class Service
  def self.perform(*args)
    instance = new
    instance.perform(*args)
  end

  def perform(_args)
    raise 'You need to overwrite this method in actual service'
  end
end
