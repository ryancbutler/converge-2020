# 2020, Simple checks for Windows Golden Image (Ryan Butler @ryan_c_butler)

control 'windows-001' do
	title 'OS Check'
	desc 'This OS should be Windows. This test is silly.'
	impact 'critical'
	describe os.family do
		it { should eq 'windows' }
	end
end

control 'windows-002' do
	title 'Citrix Broker Agent Service Check'
	desc 'This is a simple check to make sure the Citrix Desktop Agent (BrokerAgent) is running'
	impact 'critical'
	describe service('BrokerAgent') do
		it { should be_installed }
		it { should be_enabled }
		it { should be_running }
	end
end

control 'windows-003' do
	title 'Make sure Chrome EXE is present'
	desc 'Chrome should be installed on the image'
	impact 'critical'
	describe file('C:\Program Files\Google\Chrome\Application\chrome.exe') do
		it { should exist }
	end
end

control 'windows-004' do
	title 'Make sure FSlogix Registry Key is Present'
	desc 'Testing to make sure the FSlogix Registry key is present'
	impact 'critical'
	describe registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\FSLogix') do
		it { should exist }
	end
end

control 'windows-005' do
	title 'Make sure RDS and Remote assistance are installed'
	desc 'RDS and RA needs to be installed'
	impact 'critical'
	describe windows_feature('RDS-RD-Server') do
		it { should be_installed }
	end
	describe windows_feature('Remote-Assistance') do
		it { should be_installed }
	end
end

