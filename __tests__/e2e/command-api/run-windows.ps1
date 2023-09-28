$ErrorActionPreference="Stop"

$env:fc_component_function_name="node16-$($env:OS)-$($env:PROCESSOR_ARCHITECTURE)-$($env:RANDSTR)"

Write-Host "test command instance/version/alias/concurrency/provision ..."
s3 deploy -y
s3 invoke

s3 instance list

s3 version publish --description test
s3 version list
s3 version remove --version-id latest  -y
s3 version publish --description test

s3 concurrency put --reserved-concurrency 80
s3 concurrency get
s3 concurrency remove -y

s3 alias list
s3 alias publish --alias-name test --version-id latest
s3 alias get --alias-name test
s3 alias list
s3 alias list --table
s3 alias remove --alias-name test  -y
s3 alias publish --alias-name test --version-id latest

s3 provision put --qualifier test --ac --target 2 --scheduled-actions '[{"name":"scheduled-actions","startTime":"2023-08-15T02:04:00.000Z","endTime":"2033-08-15T02:04:00.000Z","target":1,"scheduleExpression":"cron(0 0 4 * * *)"}]' --target-tracking-policies '[{"name":"target-tracking-policies","startTime":"2023-08-15T02:05:00.000Z","endTime":"2033-08-15T02:05:00.000Z","metricType":"ProvisionedConcurrencyUtilization","metricTarget":0.6,"minCapacity":1,"maxCapacity":3}]'
s3 provision get --qualifier test
s3 provision list
s3 provision remove --qualifier test -y
s3 provision list
s3 provision put --qualifier test --target 2 

s3 remove -y


Write-Host "test layer ..."
$layer_name="pyyaml-layer-$($env:OS)-$($env:PROCESSOR_ARCHITECTURE)-$($env:RANDSTR)"
s3 layer list 
s3 layer list --prefix python
s3 layer info --layer-name Python39-Gradio --version-id 1
s3 layer download --layer-name Python39-Gradio --version-id 1
s3 layer publish --layer-name $layer_name --code ./pyyaml-layer.zip --compatible-runtime "python3.9,python3.10,custom,custom.debian10"
s3 layer list --prefix $layer_name
s3 layer list --prefix $layer_name --table
s3 layer versions --layer-name $layer_name
s3 layer remove -y --layer-name $layer_name