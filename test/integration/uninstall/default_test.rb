title "Grafana uninstall integration tests"

describe service('grafana') do
  it { should_not be_installed }
  it { should_not be_enabled }
  it { should_not be_running }
end

describe file('/etc/systemd/system/grafana.service') do
  it { should_not exist }
end

describe directory('/opt/grafana') do
  it { should_not exist }
end

describe directory('/etc/grafana') do
  it { should_not exist }
end

describe directory('/var/log/grafana') do
  it { should_not exist }
end

describe directory('/var/lib/grafana') do
  it { should_not exist }
end

describe user('grafana') do
  it { should_not exist }
end

describe group('grafana') do
  it { should_not exist }
end
