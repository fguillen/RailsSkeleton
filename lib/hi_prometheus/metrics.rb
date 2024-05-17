require "prometheus/client"

## Usage:
# HiPrometheus::Metrics.counter_increment(:num_logins, { role: "admin", user: user.id })
# HiPrometheus::Metrics.gauge_set(:article_sold_euros, { payment_method: "cash" }, 10.5)
# HiPrometheus::Metrics.benchmark_wrapper(:calculate_something, { label_name: "label_value" }, :calculation) do
#   Services::CalculateSomething.perform #=> ().calculation() => will be set in the label :result
# end
#
class HiPrometheus::Metrics
  def self.instance
    @instance ||= new
  end

  def self.counter_increment(*args)
    instance.counter_increment(*args)
  end

  def self.gauge_set(*args)
    instance.gauge_set(*args)
  end

  def self.gauge_increment(*args)
    instance.gauge_increment(*args)
  end

  def registry
    @registry ||= Prometheus::Client.registry
  end

  def counter_increment(metric, labels = {}, amount = 1)
    log("counter_increment(#{metric}, #{labels}, #{amount})")
    counter(metric, labels).increment(by: amount, labels: labels)
  end

  def gauge_set(metric, labels = {}, value = 1)
    log("gauge_set(#{metric}, #{labels}, #{value})")
    gauge(metric, labels).set(value, labels: labels)
  end

  def gauge_increment(metric, labels = {}, amount = 1)
    log("gauge_increment(#{metric}, #{labels}, #{amount})")
    gauge(metric, labels).increment(by: amount, labels: labels)
  end

  def self.benchmark_wrapper(metric, labels = {}, result_send_method = nil)
    log("benchmark_wrapper(#{metric}, #{labels}, #{result_send_method})")
    counter_increment(:"#{metric}_counter", labels)

    result = nil

    time =
      Benchmark.realtime do
        result = yield
      end

    if !result_send_method.nil?
      labels[:result] = result.send(result_send_method)
    end

    gauge_set(:"#{metric}_duration", labels, time * 1000)

    result # return the block call return
  end

  private

  def self.log(message)
    Rails.logger.debug("[HiPrometheus::Metrics] #{message}")
  end

  def log(message)
    HiPrometheus::Metrics.log(message)
  end

  def counter(metric, labels)
    _counter = registry.get(metric)

    if _counter && !_counter.instance_of?(Prometheus::Client::Counter)
      raise ArgumentError.new("Metric '#{metric}' exists but is not Counter (#{_counter.class.name})")
    end

    if !_counter
      _counter = Prometheus::Client::Counter.new(metric, docstring: metric.to_s.humanize, labels: labels.keys)
      registry.register(_counter)
    end

    _counter
  end

  def gauge(metric, labels)
    _gauge = registry.get(metric)

    if _gauge && !_gauge.instance_of?(Prometheus::Client::Gauge)
      raise ArgumentError.new("Metric '#{metric}' exists but is not Gauge (#{_gauge.class.name})")
    end

    if !_gauge
      _gauge = Prometheus::Client::Gauge.new(metric, docstring: metric.to_s.humanize, labels: labels.keys)
      registry.register(_gauge)
    end

    _gauge
  end
end
