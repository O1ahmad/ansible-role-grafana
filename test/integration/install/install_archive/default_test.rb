title "Grafana archive installation integration tests"

describe user('grafana') do
  it { should exist }
end

describe group('grafana') do
  it { should exist }
end

describe directory('/opt/grafana') do
  it { should exist }
  its('owner') { should eq 'grafana' }
  its('group') { should eq 'grafana' }
  its('mode') { should cmp '0755' }
end
