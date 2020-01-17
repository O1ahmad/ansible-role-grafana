title "Degfault grafana launch integration test-suite"

describe service('grafana-server') do
  it { should be_enabled }
  it { should be_running }
end
