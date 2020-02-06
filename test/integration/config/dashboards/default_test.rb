title "Grafana dashboards configuration integration tests"

describe file('/var/lib/grafana/provisioning/dashboards/test-example.yml') do
  it { should exist }
  its('owner') { should eq 'grafana' }
  its('group') { should eq 'grafana' }

  its('content') { should match('providers') }
  its('content') { should match('name: default') }
  its('content') { should match('path: /var/lib/grafana/conf/provisioning/dashboards') }
end
