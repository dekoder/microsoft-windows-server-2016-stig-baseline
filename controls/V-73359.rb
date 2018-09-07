domain_role = command("wmic computersystem get domainrole | Findstr /v DomainRole").stdout.strip

control "V-73359" do
  title "Kerberos user logon restrictions must be enforced."
  desc  "This policy setting determines whether the Kerberos Key Distribution
  Center (KDC) validates every request for a session ticket against the user
  rights policy of the target computer. The policy is enabled by default, which
  is the most secure setting for validating that access to target resources is
  not circumvented.

  "
  if domain_role == '4' || domain_role == '5'
    impact 0.5
  else
    impact 0.0
  end
  tag "gtitle": "SRG-OS-000112-GPOS-00057"
  tag "satisfies": ["SRG-OS-000112-GPOS-00057", "SRG-OS-000113-GPOS-00058"]
  tag "gid": "V-73359"
  tag "rid": "SV-88011r1_rule"
  tag "stig_id": "WN16-DC-000020" 
  tag "fix_id": "F-79801r1_fix"
  tag "cci": ["CCI-001941", "CCI-001942"]
  tag "nist": ["IA-2 (8)", "Rev_4"]
  tag "nist": ["IA-2 (9)", "Rev_4"]
  tag "documentable": false
  tag "check": "This applies to domain controllers. It is NA for other systems.

  Verify the following is configured in the Default Domain Policy.
   
  Open \"Group Policy Management\".

  Navigate to \"Group Policy Objects\" in the Domain being reviewed (Forest >>
  Domains >> Domain).

  Right-click on the \"Default Domain Policy\".

  Select \"Edit\".

  Navigate to Computer Configuration >> Policies >> Windows Settings >> Security
  Settings >> Account Policies >> Kerberos Policy.

  If the \"Enforce user logon restrictions\" is not set to \"Enabled\", this is a
  finding."
  tag "fix": "Configure the policy value in the Default Domain Policy for
  Computer Configuration >> Policies >> Windows Settings >> Security Settings >>
  Account Policies >> Kerberos Policy >> \"Enforce user logon restrictions\" to
  \"Enabled\"."
  describe security_policy do
    its("TicketValidateClient") { should eq 1}
  end if domain_role == '4' || domain_role == '5'

  describe "System is not a domain controller, control not applicable" do
    skip "System is not a domain controller, control not applicable"
  end if domain_role != '4' && domain_role != '5'

end
