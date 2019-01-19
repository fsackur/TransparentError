Describe 'New-ErrorRecord' {

    $Result = New-ErrorRecord -Message "I am an error"

    It 'Outputs an ErrorRecord' {
        $Result | Should -BeOfType ([System.Management.Automation.ErrorRecord])
        $Result.ToString() | Should -Be "I am an error"
    }
}
