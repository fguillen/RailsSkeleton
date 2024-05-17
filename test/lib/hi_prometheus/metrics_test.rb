require "test_helper"

class HiPrometheus::MetricsTest < Minitest::Test
  def test_counter_increment
    HiPrometheus::Metrics.counter_increment(:my_counter, { label_1: "value_1" })

    counter = Prometheus::Client.registry.get(:my_counter)
    assert_equal(1, counter.get(labels: { label_1: "value_1" }))

    HiPrometheus::Metrics.counter_increment(:my_counter, { label_1: "value_1" }, 5)
    assert_equal(6, counter.get(labels: { label_1: "value_1" }))

    HiPrometheus::Metrics.counter_increment(:my_counter, { label_1: "value_2" })
    assert_equal(6, counter.get(labels: { label_1: "value_1" }))
    assert_equal(1, counter.get(labels: { label_1: "value_2" }))
  end

  def test_gauge_set
    HiPrometheus::Metrics.gauge_set(:my_gauge, { label_1: "value_1" }, 1)

    gauge = Prometheus::Client.registry.get(:my_gauge)
    assert_equal(1, gauge.get(labels: { label_1: "value_1" }))

    HiPrometheus::Metrics.gauge_set(:my_gauge, { label_1: "value_1" }, 5)
    assert_equal(5, gauge.get(labels: { label_1: "value_1" }))

    HiPrometheus::Metrics.gauge_set(:my_gauge, { label_1: "value_2" }, 1)
    assert_equal(5, gauge.get(labels: { label_1: "value_1" }))
    assert_equal(1, gauge.get(labels: { label_1: "value_2" }))
  end

  def test_gauge_increment
    HiPrometheus::Metrics.gauge_increment(:my_gauge_2, { label_1: "value_1" })

    gauge = Prometheus::Client.registry.get(:my_gauge_2)
    assert_equal(1, gauge.get(labels: { label_1: "value_1" }))

    HiPrometheus::Metrics.gauge_increment(:my_gauge_2, { label_1: "value_1" }, 5)
    assert_equal(6, gauge.get(labels: { label_1: "value_1" }))

    HiPrometheus::Metrics.gauge_increment(:my_gauge_2, { label_1: "value_2" })
    assert_equal(6, gauge.get(labels: { label_1: "value_1" }))
    assert_equal(1, gauge.get(labels: { label_1: "value_2" }))
  end

  def test_when_counter_in_a_gauge_raise_exception
    HiPrometheus::Metrics.counter_increment(:my_counter_2)

    exception =
      assert_raises(ArgumentError) do
        HiPrometheus::Metrics.gauge_set(:my_counter_2)
      end

    assert_equal("Metric 'my_counter_2' exists but is not Gauge (Prometheus::Client::Counter)", exception.message)
  end

  def test_when_gauge_in_a_counter_raise_exception
    HiPrometheus::Metrics.gauge_set(:my_gauge_3)

    exception =
      assert_raises(ArgumentError) do
        HiPrometheus::Metrics.counter_increment(:my_gauge_3)
      end

    assert_equal("Metric 'my_gauge_3' exists but is not Counter (Prometheus::Client::Gauge)", exception.message)
  end

  def test_benchmark_wrapper
    result = OpenStruct.new(method_name: "method_result")

    HiPrometheus::Metrics.expects(:counter_increment).with(:metric_name_counter, { label_name: "label_value" })
    HiPrometheus::Metrics.expects(:gauge_set).with(:metric_name_duration, { label_name: "label_value", result: "method_result" }, is_a(Numeric))

    block_return =
      HiPrometheus::Metrics.benchmark_wrapper(:metric_name, { label_name: "label_value" }, :method_name) do
        result
      end

    assert_equal(result, block_return)
  end
end
