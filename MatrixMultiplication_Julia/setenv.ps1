param($num=24)

[System.Environment]::SetEnvironmentVariable('JULIA_NUM_THREADS', $num,[System.EnvironmentVariableTarget]::User)