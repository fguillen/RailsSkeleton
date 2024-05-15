# Choose instrumentations here:
# - https://opentelemetry.io/ecosystem/registry/?language=ruby&component=instrumentation
# - https://github.com/open-telemetry/opentelemetry-ruby-contrib/tree/main/instrumentation

if APP_CONFIG["opentelemetry"]["traces_exporter"].present? && APP_CONFIG["opentelemetry"]["traces_exporter"] != "none"
  ENV["OTEL_TRACES_EXPORTER"] ||= APP_CONFIG["opentelemetry"]["traces_exporter"]
  ENV["OTEL_EXPORTER_OTLP_ENDPOINT"] ||= APP_CONFIG["opentelemetry"]["otlp_endpoint"]

  require "opentelemetry/sdk"
  require "opentelemetry-exporter-otlp"

  OpenTelemetry::SDK.configure do |c|
    c.service_name = "railsskeleton.com"
    c.use_all() # enables all instrumentation!
  end
end
