title "Grafana package installation integration tests"

describe user('grafana') do
  it { should exist }
end

describe group('grafana') do
  it { should exist }
end

describe package('grafana') do
  it { should be_installed }
end
