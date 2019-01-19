function foo
{
    $script:CallStack = Get-PSCallStack
    $script:InvocationInfo = $MyInvocation
}

function bar
{
    foo
}

function baz
{
    bar
}
