title "Default role integrated test file"

describe file('/etc/grafana/grafana.ini') do
  it { should exist }
  its('owner') { should eq 'grafana' }
  its('group') { should eq 'grafana' }

  its('content') { should match('instance_name = test') }
  its('content') { should match('format = json') }
  its('content') { should match('level = debug') }
end
