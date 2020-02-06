title "Grafana service launch integration tests"

describe service('grafana-server') do
  it { should be_enabled }
  it { should be_running }
end
